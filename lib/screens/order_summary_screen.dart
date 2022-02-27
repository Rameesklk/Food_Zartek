import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_zartek/constant/my_colors.dart';
import 'package:food_zartek/constant/my_functions.dart';
import 'package:food_zartek/constant/string.dart';
import 'package:food_zartek/providers/home_provider.dart';
import 'package:provider/provider.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Summary",style:TextStyle(
            fontSize: 18,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold
        ) ,),
        leading: InkWell(
            onTap: (){
              back(context);
            },
            child: const Icon(Icons.arrow_back)),
        backgroundColor: myWhite,
        iconTheme:  IconThemeData(color: Colors.grey.shade700),

      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              child: Column(
                children: [
                  Row(),
                  Container(
                    margin: const EdgeInsets.all(5),
                    alignment: Alignment.center,
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.green.shade900,
                        borderRadius: BorderRadius.circular(10)

                    ),
                    child: Consumer<HomeProvider>(
                      builder: (context,value,child) {
                        return Text(value.dishCount.toString()+" Dishes - "+value.itemCount.toString()+ " Items",
                          style:const TextStyle(
                              fontSize: 16,
                              color: myWhite,
                              fontWeight: FontWeight.bold
                          ) ,
                        );
                      }
                    ),
                  ),
                  const SizedBox(height: 10,),
                  cartItems(context),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Amount ",
                            style:const TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold
                            )),
                        Consumer<HomeProvider>(
                          builder: (context,value,child) {
                            return Text("INR: "+value.totalPrice.toString(),
                                style:const TextStyle(
                                    fontSize: 18,
                                    color: Colors.green,
                                ));
                          }
                        ),
                      ],
                    ),
                  )

                ],


              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextButton(
           child: const Text('Place Order'),
           style: TextButton.styleFrom(
             primary: Colors.white,
             backgroundColor: Colors.green.shade900,

             onSurface: Colors.grey,
               minimumSize: const Size(160, 50),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
           ),
           onPressed: () {
           },
         ),
      ),
    );
  }
  Widget cartItems(BuildContext context){
    HomeProvider homeProvider= Provider.of<HomeProvider>(context, listen: false);
    return Container(
      child: Consumer<HomeProvider>(
        builder: (context,value,child) {
          return ListView.builder(
            itemCount:value.myCartList.length,
            shrinkWrap: true,
            physics:const BouncingScrollPhysics(),
    itemBuilder:(BuildContext context,index){
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: 20,
                            width: 20,
                            child: Image.asset(value.myCartList[index].dishType==1?nonVegIcon:vegIcon)),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(value.myCartList[index].dishName,
                                style:const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold
                                )),
                            const SizedBox(height: 5,),
                            Text("INR: "+ value.myCartList[index].dishPrice.toString(),
                                style:const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold
                                )),
                            const SizedBox(height: 5,),

                            Text(value.myCartList[index].dishCalories.toString()+" calories",
                                style:const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold
                                )),
                            const SizedBox(height: 5,),



                          ],
                        ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: IconButton(
                                icon: Icon(Icons.remove),
                                alignment: Alignment.centerLeft,
                                color: myWhite,
                                iconSize: 25,
                                tooltip: 'Remove',
                                padding:const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),

                                onPressed: () {
                                  homeProvider.funDecrement(value.myCartList, index);
                                },
                              ),
                            ),
                            Text(
                              value.myCartList[index].quantity.toString(),
                              style: TextStyle(
                                fontSize: 20, color: myWhite,
                                // fontWeight: FontWeight.w100,
                              ),
                            ),
                            Flexible(
                              child: IconButton(
                                icon: Icon(Icons.add),
                                alignment: Alignment.centerRight,
                                color: myWhite,
                                iconSize: 25,
                                tooltip: 'Add',
                                padding:const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                                onPressed: () {
                                  homeProvider.funIncrement(value.myCartList, index);
                                  // homeProvider.funIncrement(dishList[index].quantity,dishList[index].dishName,dishList[index].dishPrice,dishList[index].dishCalories.toString());
                                },
                              ),
                            ),                              ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("INR: "+value.singleItemTotal( value.myCartList[index].quantity,value.myCartList[index].dishPrice),
                            style:const TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold
                            )),
                      )

                    ],
                  ),
                  const Divider(
                    thickness: 2,
                  ),


                ],

              );
    }
          );
        }
      ),
    );
  }
}
