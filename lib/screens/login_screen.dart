import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_zartek/constant/my_colors.dart';
import 'package:food_zartek/constant/my_functions.dart';
import 'package:food_zartek/constant/string.dart';
import 'package:food_zartek/providers/home_provider.dart';
import 'package:food_zartek/screens/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String verificationId;
  bool showLoading = false;
  bool _isLoggedIn=false;
  int _otpCodeLength = 6;
  late String phoneNumber;
  final FocusNode _pinPutFocusNode = FocusNode();
  String Code = "";

  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference mRootReference =
      FirebaseDatabase.instance.reference();
  late BuildContext context;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();


  GoogleSignIn googleSignIn=GoogleSignIn();
  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if (authCredential.user != null) {
        callNext(HomeScreen(), context);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      _scaffoldKey.currentState!
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  getPhoneFormWidget(context) {
    setState(() => this.context = context);

    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return Align(
      alignment: Alignment.center,
      child: Container(
        height: MediaQuery.of(context).size.height * 3.5 / 10,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    height: 45,
                    width: 290,
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      cursorColor: Colors.greenAccent,
                      decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          hintText: "Enter your mobile number",
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.0),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Container(
                    child: MaterialButton(
                      onPressed: () async {
                        if (phoneController.text.length == 10) {
                          setState(() {
                            showLoading = true;
                          });
                          phoneNumber = "+91" + phoneController.text;
                          await _auth.verifyPhoneNumber(
                            timeout: const Duration(seconds: 5),
                            phoneNumber: "+91" + phoneController.text,
                            verificationCompleted: (phoneAuthCredential) async {
                              setState(() {
                                showLoading = false;
                              });
                              // signInWithPhoneAuthCredential(phoneAuthCredential);
                            },
                            verificationFailed: (verificationFailed) async {
                              setState(() {
                                showLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          verificationFailed.message ?? "")));
                            },
                            codeSent: (verificationId, resendingToken) async {
                              setState(() {
                                showLoading = false;
                                currentState =
                                    MobileVerificationState.SHOW_OTP_FORM_STATE;
                                this.verificationId = verificationId;

                                listenOtp();
                              });
                            },
                            codeAutoRetrievalTimeout: (verificationId) async {},
                          );
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            backgroundColor: Colors.white,
                            content: Text(
                              "Please enter valid phonenumber",
                            ),
                          ));
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
                        height: 50,
                        // width: queryData.size.width*.8,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[myGreen, myLightGreen]),
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            )),
                        child: const Center(
                            child: Text(
                          "Log in",
                          style: TextStyle(
                            fontSize: 12, color: myWhite,
                            // fontWeight: FontWeight.w100,
                          ),
                        )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getOtpFormWidget(context) {
    HomeProvider homeProvider= Provider.of<HomeProvider>(context, listen: false);

    setState(() => this.context = context);
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: MediaQuery.of(context).size.height * 3 / 10,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: const Text(
                    "OTP Verification",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "OTP send to your Number",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: PinFieldAutoFill(
                      codeLength: 6,
                      focusNode: _pinPutFocusNode,
                      keyboardType: TextInputType.number,
                      autoFocus: true,
                      controller: otpController,
                      currentCode: "",
                      decoration: const BoxLooseDecoration(
                          textStyle: TextStyle(color: Colors.black),
                          radius: Radius.circular(5),
                          strokeColorBuilder: FixedColorBuilder(myBlue)),
                      onCodeChanged: (pin) {
                        if (pin!.length == 6) {
                          PhoneAuthCredential phoneAuthCredential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId, smsCode: pin);
                          signInWithPhoneAuthCredential(phoneAuthCredential);
                          otpController.text = pin;
                          setState(() {
                            Code = pin;
                            homeProvider.phoneNumber=phoneNumber;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(),
              Flexible(
                flex: 1,
                child: Image.asset(
                  firebaseLogo,
                  height: 160,
                ),
              ),
              Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: showLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : currentState ==
                                  MobileVerificationState.SHOW_MOBILE_FORM_STATE
                              ? getPhoneFormWidget(context)
                              : getOtpFormWidget(context),
                    ),
                  ),
                  const SizedBox(height: 10),
                  signInButton(context, googleLogo, "Google")
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget signInButton(BuildContext context, String icon, String title) {
    HomeProvider homeProvider= Provider.of<HomeProvider>(context, listen: false);

    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Container(
      width: queryData.size.width * 0.8,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
        ],
        gradient:const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
                colors: [
                  myBlue,
                  myBlue,
                ],
              ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
        onPressed: () async {

           googleSignIn.signIn().then((value) {
             setState(() {
               homeProvider.isGoogleLoggedIn=true;
               homeProvider.userObj=value;
               if(value!.email.isNotEmpty){
                 callNext(HomeScreen(), context);
               }


             });
          }).catchError((e){


             print(e);
           });

        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image(
                image: AssetImage(icon),
                height: 25.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: queryData.size.width * 0.2),
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: myWhite)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> listenOtp() async {
    SmsAutoFill().listenForCode;
  }
}
