import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:wassalny/network/auth/dio.dart';

// To parse this JSON data, do
//
//     final itemSirv = itemSirvFromJson(jsonString);

ItemSirv itemSirvFromJson(String str) => ItemSirv.fromJson(json.decode(str));

String itemSirvToJson(ItemSirv data) => json.encode(data.toJson());

class ItemSirv {
  ItemSirv({
    this.message,
    this.codenum,
    this.status,
    this.result,
  });

  String message;
  int codenum;
  bool status;
  Result result;

  factory ItemSirv.fromJson(Map<String, dynamic> json) => ItemSirv(
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
    this.allSlider,
    this.allRate,
    this.serviceDetails,
  });

  List<AllSlider> allSlider;
  List<AllRate> allRate;
  List<ServiceDetail> serviceDetails;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        allSlider: List<AllSlider>.from(
            json["all_slider"].map((x) => AllSlider.fromJson(x))),
        allRate: List<AllRate>.from(
            json["all_rate"].map((x) => AllRate.fromJson(x))),
        serviceDetails: List<ServiceDetail>.from(
            json["service_details"].map((x) => ServiceDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "all_slider": List<dynamic>.from(allSlider.map((x) => x.toJson())),
        "all_rate": List<dynamic>.from(allRate.map((x) => x.toJson())),
        "service_details":
            List<dynamic>.from(serviceDetails.map((x) => x.toJson())),
      };
}

class AllRate {
  AllRate({
    this.username,
    this.userrate,
    this.usercomment,
    this.rateId,
  });

  String username;
  String userrate;
  String usercomment;
  int rateId;

  factory AllRate.fromJson(Map<String, dynamic> json) => AllRate(
        username: json["username"],
        userrate: json["userrate"],
        usercomment: json["usercomment"],
        rateId: json["rate_id"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "userrate": userrate,
        "usercomment": usercomment,
        "rate_id": rateId,
      };
}

class AllSlider {
  AllSlider({
    this.img,
    this.depId,
  });

  String img;
  int depId;

  factory AllSlider.fromJson(Map<String, dynamic> json) => AllSlider(
        img: json["img"],
        depId: json["dep_id"],
      );

  Map<String, dynamic> toJson() => {
        "img": img,
        "dep_id": depId,
      };
}

class ServiceDetail {
  ServiceDetail({
    this.favExit,
    this.totalRate,
    this.offersImage,
    this.serviceName,
    this.scanDisplay,
    this.pointsDisplay,
    this.copounDisplay,
    this.offersDisplay,
    this.branchesDisplay,
    this.sliderType,
    this.deliveryOn,
    this.totalPoints,
    this.videoLink,
    this.facebook,
    this.phone,
    this.location,
    this.phoneSecond,
    this.phoneThird,
    this.menuTitle,
    this.whatsapp,
    this.twitter,
    this.instagram,
    this.email,
    this.website,
    this.lat,
    this.lag,
    this.address,
    this.description,
    this.id,
    this.locationDisplay,
    this.viewMin,
  });

  int favExit;
  String totalRate;
  String offersImage;
  String serviceName;
  String scanDisplay;
  String pointsDisplay;
  String copounDisplay;
  String locationDisplay;
  String offersDisplay;
  String branchesDisplay;
  String sliderType;
  String deliveryOn;
  String totalPoints;
  String videoLink;
  String facebook;
  String phone;
  String location;
  String phoneSecond;
  String phoneThird;
  String menuTitle;
  String whatsapp;
  String twitter;
  String instagram;
  String email;
  String website;
  String lat;
  String lag;
  String address;
  String description;
  int id;
  String viewMin;
  factory ServiceDetail.fromJson(Map<String, dynamic> json) => ServiceDetail(
        favExit: json["fav_exit"],
        totalRate: json["total_rate"],
        offersImage: json["offers_image"],
        serviceName: json["service_name"],
        scanDisplay: json["scan_display"],
        pointsDisplay: json["points_display"],
        copounDisplay: json["copoun_display"],
        offersDisplay: json["offers_display"],
        branchesDisplay: json["branches_display"],
        locationDisplay: json["location_display"],
        sliderType: json["slider_type"],
        deliveryOn: json["delivery_on"],
        totalPoints: json["total_points"],
        videoLink: json["video_link"],
        facebook: json["facebook"],
        phone: json["phone"],
        location: json["location"],
        phoneSecond: json["phone_second"],
        phoneThird: json["phone_third"],
        menuTitle: json["menu_title"],
        whatsapp: json["whatsapp"],
        twitter: json["twitter"],
        instagram: json["instagram"],
        email: json["email"],
        website: json["website"],
        lat: json["lat"],
        lag: json["lag"],
        address: json["address"],
        description: json["description"],
        id: json["id"],
        viewMin: json["menu_display"],
      );

  Map<String, dynamic> toJson() => {
        "menu_display": viewMin,
        "fav_exit": favExit,
        "total_rate": totalRate,
        "offers_image": offersImage,
        "service_name": serviceName,
        "scan_display": scanDisplay,
        "points_display": pointsDisplay,
        "copoun_display": copounDisplay,
        "offers_display": offersDisplay,
        "branches_display": branchesDisplay,
        "location_display": locationDisplay,
        "slider_type": sliderType,
        "delivery_on": deliveryOn,
        "total_points": totalPoints,
        "video_link": videoLink,
        "facebook": facebook,
        "phone": phone,
        "location": location,
        "phone_second": phoneSecond,
        "phone_third": phoneThird,
        "menu_title": menuTitle,
        "whatsapp": whatsapp,
        "twitter": twitter,
        "instagram": instagram,
        "email": email,
        "website": website,
        "lat": lat,
        "lag": lag,
        "address": address,
        "description": description,
        "id": id,
      };
}

class ItemServicesDetail with ChangeNotifier {
  String token;
  ItemServicesDetail(this.token);

  String offersImage = '';
  String facebook = '';
  String phone = '';
  String phoneSecond = '';
  String phoneThird = '';
  String whatsapp = '';
  String twitter = '';
  String instagram = '';
  String email = '';
  String lat = '';
  String lag = '';
  String address = '';
  String description = '';
  String serviceName = '';
  String mainImg = '';
  String viewOffer = '';
  String viewCobon = '';
  String viewPoints = '';
  String viewMin = '';
  String viewBranches = '';
  String viewScan = '';
  String viewLocation = '';
  String img1 = '';
  String img2 = '';
  String img3 = '';
  String sliderType;
  String web;
  String delivary;
  String videoLink;
  String totalRate;
  int isFav;
  List<ServiceDetail> serviceDetail = [];
  List<AllRate> allRate = [];
  String points = '';
  // List<ResultRelated> result = [];
  List<AllSlider> allslider = [];
  String loctaation = '';
  int idd;
  String menuTilte = '';
  Future<void> fetchAllDetails(int id, String lang) async {
    try {
      Dio.Response response = await dio().post(
        'user_api/get_service_details',
        data: Dio.FormData.fromMap(
          {
            'key': 1234567890,
            'token_id': token,
            'service_id': id,
            'lang': lang
          },
        ),
      );
      print(response);
      serviceDetail =
          itemSirvFromJson(response.toString()).result.serviceDetails;
      for (var i = 0; i < serviceDetail.length; i++) {
        viewBranches = serviceDetail[i].branchesDisplay;
        viewOffer = serviceDetail[i].offersDisplay;
        viewPoints = serviceDetail[i].pointsDisplay;
        viewScan = serviceDetail[i].scanDisplay;
        viewCobon = serviceDetail[i].copounDisplay;
        viewLocation = serviceDetail[i].locationDisplay;
        isFav = serviceDetail[i].favExit;
        totalRate = serviceDetail[i].totalRate;
        offersImage = serviceDetail[i].offersImage;
        facebook = serviceDetail[i].facebook;
        phone = serviceDetail[i].phone;
        phoneSecond = serviceDetail[i].phoneSecond;
        phoneThird = serviceDetail[i].phoneThird;
        whatsapp = serviceDetail[i].whatsapp;
        twitter = serviceDetail[i].twitter;
        instagram = serviceDetail[i].instagram;
        email = serviceDetail[i].email;
        lat = serviceDetail[i].lat;
        lag = serviceDetail[i].lag;
        address = serviceDetail[i].address;
        web = serviceDetail[i].website;
        description = serviceDetail[i].description;
        serviceName = serviceDetail[i].serviceName;
        mainImg = serviceDetail[i].offersImage;
        sliderType = serviceDetail[i].sliderType;
        delivary = serviceDetail[i].deliveryOn;
        videoLink = serviceDetail[i].videoLink;
        loctaation = serviceDetail[i].location;
        points = serviceDetail[i].totalPoints;
        idd = serviceDetail[i].id;
        menuTilte = serviceDetail[i].menuTitle;
        viewMin = serviceDetail[i].viewMin;
      }

      // result = itemSirvFromJson(response.toString()).result.resultRelated;
      // for (var i = 0; i < result.length; i++) {
      //   idd = result[i].id;
      // }
      allslider = itemSirvFromJson(response.toString()).result.allSlider;
      allRate = itemSirvFromJson(response.toString()).result.allRate;
    } catch (err) {
      // ignore: unnecessary_brace_in_string_interps
      print('${err} error from offers list');
      throw (err);
    }
  }

  int cobon;
  Future<void> getCobon(int id) async {
    try {
      Dio.Response response = await dio().post(
        'services/generate_coupon',
        data: Dio.FormData.fromMap(
          {
            'key': 1234567890,
            'token_id': token,
            'service_id': id,
          },
        ),
      );
      cobon = response.data['result']['service_coupon'];
      print(response);
      print(cobon.toString());
    } catch (err) {
      // ignore: unnecessary_brace_in_string_interps
      print('${err}');
    }
  }

  String message = '';
  int number = 0;
  Future<void> qr(String id, String lang) async {
    try {
      Dio.Response response = await dio().post(
        'user_api/scan_qr',
        data: Dio.FormData.fromMap(
          {
            'key': 1234567890,
            'token_id': token,
            'service_id': id,
            'lang': lang
          },
        ),
      );
      number = response.data['result']['your_coupon'];
      message = response.data['message'];
      print(response);
      print(cobon.toString());
    } catch (err) {
      // ignore: unnecessary_brace_in_string_interps
      print('${err}');
    }
  }
}
