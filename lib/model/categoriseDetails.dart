import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:wassalny/network/auth/dio.dart';

// To parse this JSON data, do
//
//     final detailsOfServices = detailsOfServicesFromJson(jsonString);

DetailsOfServices detailsOfServicesFromJson(String str) =>
    DetailsOfServices.fromJson(json.decode(str));

String detailsOfServicesToJson(DetailsOfServices data) =>
    json.encode(data.toJson());

class DetailsOfServices {
  DetailsOfServices({
    this.message,
    this.messageid,
    this.status,
    this.total,
    this.result,
  });

  String message;
  int messageid;
  bool status;
  int total;
  Result result;

  factory DetailsOfServices.fromJson(Map<String, dynamic> json) =>
      DetailsOfServices(
        message: json["Message"],
        messageid: json["Messageid"],
        status: json["status"],
        total: json["total"],
        result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Messageid": messageid,
        "status": status,
        "total": total,
        "result": result.toJson(),
      };
}

class Result {
  Result({
    this.categoryDetails,
    this.allProducts,
  });

  CategoryDetails categoryDetails;
  List<AllProduct> allProducts;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        categoryDetails: CategoryDetails.fromJson(json["category_details"]),
        allProducts: List<AllProduct>.from(
            json["all_products"].map((x) => AllProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category_details": categoryDetails.toJson(),
        "all_products": List<dynamic>.from(allProducts.map((x) => x.toJson())),
      };
}

class AllProduct {
  AllProduct({
    this.favExit,
    this.totalRate,
    this.productImage,
    this.productName,
    this.phone,
    this.prodId,
    this.delivery,
  });

  int favExit;
  String totalRate;
  String productImage;
  String productName;
  String phone;
  int prodId;
  int delivery;

  factory AllProduct.fromJson(Map<String, dynamic> json) => AllProduct(
        favExit: json["fav_exit"],
        totalRate: json["total_rate"],
        productImage: json["product_image"],
        productName: json["product_name"],
        phone: json["phone"],
        prodId: json["prod_id"],
        delivery: json["delivery"],
      );

  Map<String, dynamic> toJson() => {
        "fav_exit": favExit,
        "total_rate": totalRate,
        "product_image": productImage,
        "product_name": productName,
        "phone": phone,
        "prod_id": prodId,
        "delivery": delivery,
      };
}

class CategoryDetails {
  CategoryDetails({
    this.categoryManbanner,
    this.categoryImage,
    this.categoryName,
    this.catId,
  });

  String categoryManbanner;
  String categoryImage;
  String categoryName;
  int catId;

  factory CategoryDetails.fromJson(Map<String, dynamic> json) =>
      CategoryDetails(
        categoryManbanner: json["category_manbanner"],
        categoryImage: json["category_image"],
        categoryName: json["category_name"],
        catId: json["cat_id"],
      );

  Map<String, dynamic> toJson() => {
        "category_manbanner": categoryManbanner,
        "category_image": categoryImage,
        "category_name": categoryName,
        "cat_id": catId,
      };
}

class DetailsOfServicesProvider with ChangeNotifier {
  String token;

  DetailsOfServicesProvider({
    this.token,
  });

  CategoryDetails categoryDetail;
  List<AllProduct> allProduct = [];
  String name;
  String imag;
  int id;
  int total;
  Future<void> fetchAllCategories(
      String lang, int id, int limt, int pageNumber, int main) async {
    print("$id الاي");
    Map m = {
      'key': 1234567890,
      'lang': lang,
      'token_id': token,
      'cat_id': id,
      'limit': limt,
      'page_number': pageNumber,
      'main': main
    };
    print(m);
    try {
      Dio.Response response = await dio().post(
        'user_api/get_all_services',
        data: Dio.FormData.fromMap(
          {
            'key': 1234567890,
            'lang': lang,
            'token_id': token,
            'cat_id': id,
            'limit': limt,
            'page_number': pageNumber,
            'main': main
          },
        ),
      );
      print(response);
      allProduct =
          detailsOfServicesFromJson(response.toString()).result.allProducts;

      categoryDetail =
          detailsOfServicesFromJson(response.toString()).result.categoryDetails;
      total = response.data['total'];
    } catch (err) {
      throw (err);
    }
  }
}
