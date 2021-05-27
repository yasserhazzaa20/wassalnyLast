import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:wassalny/network/auth/dio.dart';

// To parse this JSON data, do
//
//     final home = homeFromJson(jsonString);

Home homeFromJson(String str) => Home.fromJson(json.decode(str));

String homeToJson(Home data) => json.encode(data.toJson());

class Home {
  Home({
    this.message,
    this.codenum,
    this.status,
    this.result,
  });

  String message;
  int codenum;
  bool status;
  Result result;

  factory Home.fromJson(Map<String, dynamic> json) => Home(
        message: json["message"],
        codenum: json["codenum"],
        status: json["status"],
        result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "codenum": codenum,
        "status": status,
        "result": result.toJson(),
      };
}

class Result {
  Result({
    this.mainOffers,
    this.allRecommended,
    this.allCategories,
    this.allFeatures,
  });

  List<MainOffer> mainOffers;
  List<AllRecommended> allRecommended;
  List<AllCategory> allCategories;
  List<AllFeature> allFeatures;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        mainOffers: List<MainOffer>.from(
            json["main_offers"].map((x) => MainOffer.fromJson(x))),
        allRecommended: List<AllRecommended>.from(
            json["all_recommended"].map((x) => AllRecommended.fromJson(x))),
        allCategories: List<AllCategory>.from(
            json["all_categories"].map((x) => AllCategory.fromJson(x))),
        allFeatures: List<AllFeature>.from(
            json["all_features"].map((x) => AllFeature.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "main_offers": List<dynamic>.from(mainOffers.map((x) => x.toJson())),
        "all_recommended":
            List<dynamic>.from(allRecommended.map((x) => x.toJson())),
        "all_categories":
            List<dynamic>.from(allCategories.map((x) => x.toJson())),
        "all_features": List<dynamic>.from(allFeatures.map((x) => x.toJson())),
      };
}

class AllCategory {
  AllCategory({
    this.allDepartment,
    this.totalDepartment,
    this.categoryImage,
    this.categoryName,
    this.catId,
  });

  List<AllDepartment> allDepartment;
  int totalDepartment;
  String categoryImage;
  String categoryName;
  int catId;

  factory AllCategory.fromJson(Map<String, dynamic> json) => AllCategory(
        allDepartment: List<AllDepartment>.from(
            json["all_department"].map((x) => AllDepartment.fromJson(x))),
        totalDepartment: json["total_department"],
        categoryImage: json["category_image"],
        categoryName: json["category_name"],
        catId: json["cat_id"],
      );

  Map<String, dynamic> toJson() => {
        "all_department":
            List<dynamic>.from(allDepartment.map((x) => x.toJson())),
        "total_department": totalDepartment,
        "category_image": categoryImage,
        "category_name": categoryName,
        "cat_id": catId,
      };
}

class AllDepartment {
  AllDepartment({
    this.departmentName,
    this.departmentId,
    this.departmentImage,
  });

  String departmentName;
  String departmentId;
  String departmentImage;

  factory AllDepartment.fromJson(Map<String, dynamic> json) => AllDepartment(
        departmentName: json["department_name"],
        departmentId: json["department_id"],
        departmentImage: json["department_image"],
      );

  Map<String, dynamic> toJson() => {
        "department_name": departmentName,
        "department_id": departmentId,
        "department_image": departmentImage,
      };
}

class AllFeature {
  AllFeature({
    this.categoryImage,
    this.categoryName,
    this.catId,
    this.imgBanner,
    this.allProducts,
  });

  String categoryImage;
  String categoryName;
  int catId;
  String imgBanner;
  List<AllProduct> allProducts;

  factory AllFeature.fromJson(Map<String, dynamic> json) => AllFeature(
        categoryImage: json["category_image"],
        categoryName: json["category_name"],
        catId: json["cat_id"],
        imgBanner: json["img_banner"],
        allProducts: List<AllProduct>.from(
            json["all_products"].map((x) => AllProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category_image": categoryImage,
        "category_name": categoryName,
        "cat_id": catId,
        "img_banner": imgBanner,
        "all_products": List<dynamic>.from(allProducts.map((x) => x.toJson())),
      };
}

class AllProduct {
  AllProduct({
    this.productImage,
    this.productName,
    this.phone,
    this.prodId,
  });

  String productImage;
  String productName;
  String phone;
  int prodId;

  factory AllProduct.fromJson(Map<String, dynamic> json) => AllProduct(
        productImage: json["product_image"],
        productName: json["product_name"],
        phone: json["phone"],
        prodId: json["prod_id"],
      );

  Map<String, dynamic> toJson() => {
        "product_image": productImage,
        "product_name": productName,
        "phone": phone,
        "prod_id": prodId,
      };
}

class AllRecommended {
  AllRecommended({
    this.recommendedImage,
    this.recommendedPosition,
    this.serviceId,
    this.id,
  });

  String recommendedImage;
  int recommendedPosition;
  int serviceId;
  int id;

  factory AllRecommended.fromJson(Map<String, dynamic> json) => AllRecommended(
        recommendedImage: json["recommended_image"],
        recommendedPosition: json["recommended_position"],
        serviceId: json["service_id"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "recommended_image": recommendedImage,
        "recommended_position": recommendedPosition,
        "service_id": serviceId,
        "id": id,
      };
}

class MainOffer {
  MainOffer({
    this.image,
    this.link,
    this.serviceId,
  });

  String image;
  String link;
  String serviceId;

  factory MainOffer.fromJson(Map<String, dynamic> json) => MainOffer(
        image: json["image"],
        link: json["link"],
        serviceId: json["service_id"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "link": link,
        "service_id": serviceId,
      };
}

//{========================Get From server=======================}

class HomeLists with ChangeNotifier {
  String token;
  String lang;
  int id;
  HomeLists({
    this.id,
    this.token,
    this.lang,
  });

  List<MainOffer> sliderImageInMain = [];
  List<AllCategory> allCategories = [];
  List<AllFeature> allfeature = [];
  List<AllRecommended> recomended = [];
  String recommendedImage = '';
  int recommendedId = 0;
  int recomendedBosition;
  Future<void> fetchHome(String lang) async {
    print('$token ===============================');
    try {
      Dio.Response response = await dio().post(
        'user_api/get_home',
        data: Dio.FormData.fromMap(
          {'key': 1234567890, 'lang': lang, 'token_id': token},
        ),
      );
      print(response);
      sliderImageInMain = homeFromJson(response.toString()).result.mainOffers;
      allCategories = homeFromJson(response.toString()).result.allCategories;
      allfeature =
          homeFromJson(response.toString()).result.allFeatures.where((element) {
        return element.allProducts.isNotEmpty;
      }).toList();
      recomended = homeFromJson(response.toString()).result.allRecommended;
      for (var i = 0; i < recomended.length; i++) {
        recommendedImage = recomended[i].recommendedImage;
        recommendedId = recomended[i].id;
        recomendedBosition = recomended[i].recommendedPosition;
      }
    } catch (err) {
      // ignore: unnecessary_brace_in_string_interps
      print('${err} error from offersssssssssssss list');
    }
  }
}
