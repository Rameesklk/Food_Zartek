import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_zartek/providers/home_provider.dart';
import 'package:food_zartek/screens/home_screen.dart';
import 'package:food_zartek/screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(

              backgroundColor: Colors.grey,
              body: Container(child: Center(child: Text("Error")),),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {

          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context)=> HomeProvider(),),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Food Zartek',
              theme: ThemeData(
                backgroundColor: Colors.white,
                fontFamily: 'Quicksand',
              ),
              home:const LoginScreen(),

            ),
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          home: Scaffold(
            body: Container(
              child: Center(child: Text("Loading",style: TextStyle(color:Colors.white),)),),
          ),
        );
      },
    );
  }
}
