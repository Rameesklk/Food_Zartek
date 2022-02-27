import 'dart:convert';

import 'package:food_zartek/constant/string.dart';
import 'package:food_zartek/models/category_model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  Future<Welcome> getCategories()async{
    var welcome=null;
  var client = http.Client();
try {
  var response = await client.get(Uri.parse(restaurantAPI));
  if (response.statusCode == 200) {
    var jsonString = response.body;
    var jsonMap = json.decode(jsonString);
    welcome = Welcome.fromJson(jsonMap[0]);
  }
}catch(e){
  return welcome;

}
  return welcome;
  }
}