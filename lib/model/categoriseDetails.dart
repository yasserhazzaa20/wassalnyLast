import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:wassalny/network/auth/dio.dart';

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

  List<CategoryDetail> categoryDetails;
  List<AllProduct> allProducts;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        categoryDetails: List<CategoryDetail>.from(
            json["category_details"].map((x) => CategoryDetail.fromJson(x))),
        allProducts: List<AllProduct>.from(
            json["all_products"].map((x) => AllProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category_details":
            List<dynamic>.from(categoryDetails.map((x) => x.toJson())),
        "all_products": List<dynamic>.from(allProducts.map((x) => x.toJson())),
      };
}

class AllProduct {
  AllProduct({
    this.productImage,
    this.productName,
    this.phone,
    this.prodId,
    this.delivery,
  });

  String productImage;
  String productName;
  String phone;
  int prodId;
  int delivery;

  factory AllProduct.fromJson(Map<String, dynamic> json) => AllProduct(
        productImage: json["product_image"],
        productName: json["product_name"],
        phone: json["phone"],
        prodId: json["prod_id"],
        delivery: json["delivery"],
      );

  Map<String, dynamic> toJson() => {
        "product_image": productImage,
        "product_name": productName,
        "phone": phone,
        "prod_id": prodId,
        "delivery": delivery,
      };
}

class CategoryDetail {
  CategoryDetail({
    this.categoryImage,
    this.categoryName,
    this.catId,
  });

  String categoryImage;
  String categoryName;
  int catId;

  factory CategoryDetail.fromJson(Map<String, dynamic> json) => CategoryDetail(
        categoryImage: json["category_image"],
        categoryName: json["category_name"],
        catId: json["cat_id"],
      );

  Map<String, dynamic> toJson() => {
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

  List<CategoryDetail> categoryDetail = [];
  List<AllProduct> allProduct = [];
  String name;
  String imag;
  int id;
  int total;
  Future<void> fetchAllCategories(
      String lang, int id, int limt, int pageNumber, int main) async {
    print(main.toString());
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
      categoryDetail.addAll(detailsOfServicesFromJson(response.toString())
          .result
          .categoryDetails);
      allProduct.addAll(
          detailsOfServicesFromJson(response.toString()).result.allProducts);

      for (var i = 0; i < categoryDetail.length; i++) {
        name = categoryDetail[i].categoryName;
        imag = categoryDetail[i].categoryImage;
        id = categoryDetail[i].catId;
      }
      total = response.data['total'];
    } catch (err) {
      throw (err);
    }
  }
}
