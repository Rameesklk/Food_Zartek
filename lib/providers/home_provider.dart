import 'package:flutter/cupertino.dart';
import 'package:food_zartek/models/category_model.dart';
import 'package:food_zartek/models/my_cart_model.dart';
import 'package:food_zartek/services/api_services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeProvider extends ChangeNotifier {
  Future<Welcome>? categoriesT;
  List<CategoryDish> myCartList=[];
  int dishCount=0;
  int itemCount=0;
  double totalPrice=0;
  bool isGoogleLoggedIn=false;
  bool isPhoneLoggedIn=false;
  String? phoneNumber;

  GoogleSignInAccount? userObj;


  HomeProvider(){
    fetchCategories();
  }
  void fetchCategories()  {
    categoriesT = ApiServices().getCategories();
   notifyListeners();
  }

  void funIncrement(List<CategoryDish> dishList,int index){
    dishList[index].quantity=dishList[index].quantity+1;
    if(!myCartList.map((item) => item.dishName).contains(dishList[index].dishName)){
      myCartList.add(dishList[index]);
    }
    funCalculation();
    notifyListeners();
  }
  void funDecrement(List<CategoryDish> dishList,int index){
    if(dishList[index].quantity>0) {
      dishList[index].quantity = dishList[index].quantity - 1;
    }
    if(dishList[index].quantity==0){
      myCartList.remove(dishList[index]);
    }
    funCalculation();
    notifyListeners();
  }

  void funCalculation(){
    dishCount=0;
    itemCount=0;
    totalPrice=0;
    if(myCartList.isNotEmpty){
      dishCount=myCartList.length;
      myCartList.forEach((element) {
        itemCount=itemCount+element.quantity;
        totalPrice=totalPrice+(element.quantity*element.dishPrice);
      });
      notifyListeners();
    }
  }
  String singleItemTotal(int quantity,double price){
    String strSinglePrice="0";
    double singlePrice=0;
    singlePrice=quantity*price;
    strSinglePrice=singlePrice.toString();
    return strSinglePrice;
  }

}