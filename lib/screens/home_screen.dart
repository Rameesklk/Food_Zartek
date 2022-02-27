import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_zartek/constant/my_colors.dart';
import 'package:food_zartek/constant/my_functions.dart';
import 'package:food_zartek/constant/string.dart';
import 'package:food_zartek/models/category_model.dart';
import 'package:food_zartek/providers/home_provider.dart';
import 'package:food_zartek/screens/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'order_summary_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider =
        Provider.of<HomeProvider>(context, listen: false);

    return Consumer<HomeProvider>(builder: (context, value, child) {
      return Scaffold(
        backgroundColor: myWhite,
        body: FutureBuilder<Welcome>(
          future: value.categoriesT,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return DefaultTabController(
                  length: snapshot.data!.tableMenuList.length,
                  child: Scaffold(
                      appBar: AppBar(
                        backgroundColor: myWhite,
                        iconTheme: IconThemeData(color: Colors.grey.shade700),
                        actions: <Widget>[
                          Stack(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.shopping_cart_rounded),
                                tooltip: 'My Cart',
                                onPressed: () {
                                  homeProvider.funCalculation();
                                  callNext(const OrderSummaryScreen(), context);
                                },
                              ),
                              Consumer<HomeProvider>(
                                  builder: (context, value, child) {
                                return value.dishCount != 0
                                    ? Positioned(
                                        right: 8,
                                        top: 6,
                                        child: Container(
                                            height: 15,
                                            width: 15,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red),
                                            child: Center(
                                              child: Text(
                                                  value.dishCount.toString(),
                                                  style: const TextStyle(
                                                      color: myWhite,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            )),
                                      )
                                    : const SizedBox();
                              })
                            ],
                          ),
                        ],
                        bottom: TabBar(
                          isScrollable: true,
                          labelColor: myPink,
                          indicatorColor: myPink,
                          tabs: List<Widget>.generate(
                              snapshot.data!.tableMenuList.length, (int index) {
                            var category = snapshot.data!.tableMenuList[index];
                            return Tab(text: category.menuCategory);
                          }),
                        ),
                      ),
                      drawer: drawerMenu(context),
                      body: TabBarView(
                        children: List<Widget>.generate(
                            snapshot.data!.tableMenuList.length, (int index) {
                          var category = snapshot.data!.tableMenuList[index];

                          return tabScreen(context, category.categoryDishes);
                        }),
                      )));
            } else {
              return const Center(child: const CircularProgressIndicator());
            }
          },
        ),
      );
    });
  }

  Widget drawerMenu(BuildContext context) {
    HomeProvider homeProvider =
        Provider.of<HomeProvider>(context, listen: false);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
                colors: [
                  myGreen,
                  myLightGreen,
                ],
              ),
            ),
            child: Consumer<HomeProvider>(builder: (context, value, child) {
              return Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: value.isGoogleLoggedIn
                    ? Column(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: myWhite,
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(value.userObj!.photoUrl!),
                              radius: 38,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(value.userObj!.displayName!),
                          const SizedBox(
                            height: 5,
                          ),
                          Text("Uid")
                        ],
                      )
                    : Column(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: myWhite,
                            child: CircleAvatar(
                              backgroundImage: AssetImage(googleLogo),
                              radius: 38,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(value.phoneNumber!),
                          const SizedBox(
                            height: 5,
                          ),
                          Text("Uid")
                        ],
                      ),
              );
            }),
          ),
          InkWell(
            onTap: () {
              if (homeProvider.isPhoneLoggedIn) {
                firebaseAuth.signOut();
                homeProvider.isPhoneLoggedIn = false;
              } else {
                googleSignIn.signOut();
                homeProvider.isGoogleLoggedIn = false;
              }

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: const ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
            ),
          ),
        ],
      ),
    );
  }

  Widget tabScreen(BuildContext context, List<CategoryDish> dishList) {
    HomeProvider homeProvider =
        Provider.of<HomeProvider>(context, listen: false);

    return Container(
      child: ListView.builder(
          itemCount: dishList.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: 20,
                            width: 20,
                            child: Image.asset(dishList[index].dishType == 1
                                ? nonVegIcon
                                : vegIcon)),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(dishList[index].dishName,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "INR: " +
                                        dishList[index].dishPrice.toString(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    dishList[index].dishCalories.toString() +
                                        " Calories",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black38,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(dishList[index].dishDescription,
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.black26)),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              height: 40,
                              width: 140,
                              padding: const EdgeInsets.all(8),
                              // width: queryData.size.width*.8,
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: <Color>[myGreen, myLightGreen]),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  )),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: IconButton(
                                      icon: Icon(Icons.remove),
                                      alignment: Alignment.centerLeft,
                                      color: myWhite,
                                      iconSize: 25,
                                      tooltip: 'Remove',
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 10.0),
                                      onPressed: () {
                                        homeProvider.funDecrement(
                                            dishList, index);
                                      },
                                    ),
                                  ),
                                  Consumer<HomeProvider>(
                                      builder: (context, value, child) {
                                    return Text(
                                      dishList[index].quantity.toString(),
                                      style: TextStyle(
                                        fontSize: 20, color: myWhite,
                                        // fontWeight: FontWeight.w100,
                                      ),
                                    );
                                  }),
                                  Flexible(
                                    child: IconButton(
                                      icon: Icon(Icons.add),
                                      alignment: Alignment.centerRight,
                                      color: myWhite,
                                      iconSize: 25,
                                      tooltip: 'Add',
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 5.0),
                                      onPressed: () {
                                        homeProvider.funIncrement(
                                            dishList, index);
                                        // homeProvider.funIncrement(dishList[index].quantity,dishList[index].dishName,dishList[index].dishPrice,dishList[index].dishCalories.toString());
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Text(
                                  dishList[index].addonCat.isNotEmpty
                                      ? "Customization Available"
                                      : "",
                                  style:
                                      TextStyle(fontSize: 14, color: myPink)),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 75,
                        width: 75,
                        margin: EdgeInsets.only(left: 8, right: 5),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),

                          // child: Image.network(
                          // dishList[index].dishImage,
                          // fit: BoxFit.cover,
                          // ),

                          child: Image.asset(
                            dummyImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
