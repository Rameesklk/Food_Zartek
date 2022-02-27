// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Welcome {
  Welcome({
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantImage,
    required this.tableId,
    required this.tableName,
    required this.branchName,
    required this.nexturl,
    required this.tableMenuList,
  });

  String restaurantId;
  String restaurantName;
  String restaurantImage;
  String tableId;
  String tableName;
  String branchName;
  String nexturl;
  List<TableMenuList> tableMenuList;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    restaurantId: json["restaurant_id"],
    restaurantName: json["restaurant_name"],
    restaurantImage: json["restaurant_image"],
    tableId: json["table_id"],
    tableName: json["table_name"],
    branchName: json["branch_name"],
    nexturl: json["nexturl"],
    tableMenuList: List<TableMenuList>.from(json["table_menu_list"].map((x) => TableMenuList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "restaurant_id": restaurantId,
    "restaurant_name": restaurantName,
    "restaurant_image": restaurantImage,
    "table_id": tableId,
    "table_name": tableName,
    "branch_name": branchName,
    "nexturl": nexturl,
    "table_menu_list": List<dynamic>.from(tableMenuList.map((x) => x.toJson())),
  };
}

class TableMenuList {
  TableMenuList({
    required this.menuCategory,
    required this.menuCategoryId,
    required this.menuCategoryImage,
    required this.nexturl,
    required this.categoryDishes,
  });

  String menuCategory;
  String menuCategoryId;
  String menuCategoryImage;
  String nexturl;
  List<CategoryDish> categoryDishes;

  factory TableMenuList.fromJson(Map<String, dynamic> json) => TableMenuList(
    menuCategory: json["menu_category"],
    menuCategoryId: json["menu_category_id"],
    menuCategoryImage: json["menu_category_image"],
    nexturl: json["nexturl"],
    categoryDishes: List<CategoryDish>.from(json["category_dishes"].map((x) => CategoryDish.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "menu_category": menuCategory,
    "menu_category_id": menuCategoryId,
    "menu_category_image": menuCategoryImage,
    "nexturl": nexturl,
    "category_dishes": List<dynamic>.from(categoryDishes.map((x) => x.toJson())),
  };
}

class AddonCat {
  AddonCat({
    required this.addonCategory,
    required this.addonCategoryId,
    required this.addonSelection,
    required this.nexturl,
    required this.addons,
  });

  String addonCategory;
  String addonCategoryId;
  int addonSelection;
  String nexturl;
  List<CategoryDish> addons;

  factory AddonCat.fromJson(Map<String, dynamic> json) => AddonCat(
    addonCategory: json["addon_category"],
    addonCategoryId: json["addon_category_id"],
    addonSelection: json["addon_selection"],
    nexturl: json["nexturl"],
    addons: List<CategoryDish>.from(json["addons"].map((x) => CategoryDish.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "addon_category": addonCategory,
    "addon_category_id": addonCategoryId,
    "addon_selection": addonSelection,
    "nexturl": nexturl,
    "addons": List<dynamic>.from(addons.map((x) => x.toJson())),
  };
}

class CategoryDish {
  CategoryDish({
    required this.dishId,
    required this.dishName,
    required this.dishPrice,
    required this.dishImage,
    required this.dishCurrency,
    required this.dishCalories,
    required this.dishDescription,
    required this.dishAvailability,
    required this.dishType,
    required this.nexturl,
    required this.addonCat,
    required this.quantity,
  });

  String dishId;
  String dishName;
  double dishPrice;
  String dishImage;
  DishCurrency dishCurrency;
  double dishCalories;
  String dishDescription;
  bool dishAvailability;
  int dishType;
  String nexturl;
  List<AddonCat> addonCat;
  int quantity;

  factory CategoryDish.fromJson(Map<String, dynamic> json) => CategoryDish(
    dishId: json["dish_id"],
    dishName: json["dish_name"],
    dishPrice: json["dish_price"].toDouble(),
    dishImage: json["dish_image"],
    dishCurrency: dishCurrencyValues.map[json["dish_currency"]]!,
    dishCalories: json["dish_calories"],
    dishDescription: json["dish_description"],
    dishAvailability: json["dish_Availability"],
    dishType: json["dish_Type"],
    nexturl: json["nexturl"] == null ? "" : json["nexturl"],
    addonCat: json["addonCat"] == null ? [] : List<AddonCat>.from(json["addonCat"].map((x) => AddonCat.fromJson(x))),
    quantity:json["quantity"] == null ? 0:0,

  );

  Map<String, dynamic> toJson() => {
    "dish_id": dishId,
    "dish_name": dishName,
    "dish_price": dishPrice,
    "dish_image": dishImage,
    "dish_currency": dishCurrencyValues.reverse![dishCurrency],
    "dish_calories": dishCalories,
    "dish_description": dishDescription,
    "dish_Availability": dishAvailability,
    "dish_Type": dishType,
    "nexturl": nexturl == null ? null : nexturl,
    "addonCat": addonCat == null ? null : List<dynamic>.from(addonCat.map((x) => x.toJson())),
  };
}

enum DishCurrency { SAR }

final dishCurrencyValues = EnumValues({
  "SAR": DishCurrency.SAR
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
