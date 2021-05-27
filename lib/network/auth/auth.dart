import 'package:dio/dio.dart' as Dio;
import 'package:fcm_config/fcm_config.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:get_storage/get_storage.dart';
import 'package:wassalny/Components/networkExeption.dart';
import 'package:wassalny/model/registerModel.dart';
import 'package:wassalny/model/user.dart';
import 'package:wassalny/model/userdata.dart';

import './dio.dart';

class Auth with ChangeNotifier {
  bool loggedIn = false;
  int id;
  String token;
  String lang;
  String phoneNumber = '';
  String name = '';
  String adress = '';
  List<ClientDatum> x;
  List<ClientDatumR> registerList;
  String fireBaseToken;
  String city;
  String cityId;
  Future<String> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('bool');
    return token;
  }

  Future<bool> signIn(User user) async {
    try {
      Dio.Response response = await dio().post(
        'pages/set_login',
        data: Dio.FormData.fromMap(user.sentPhoneToLogin(
          await FCMConfig().getToken(),
        )),
      );
      print(response);
      if (response.data['status'] == false) {
        throw HttpExeption('error');
      }
      if (response.data['status'] == true) {
        loggedIn = true;
        x = userDataFromJson(response.toString()).result.clientData;
        for (var i = 0; i < x.length; i++) {
          token = x[i].token;
          lang = x[i].lang;
          id = x[i].id;
        }
        final preferences = await SharedPreferences.getInstance();
        await preferences.setString('bool', token);

        token = preferences.getString('bool');
        // fireBaseToken = preferences.getString('fireToken');
      }
      notifyListeners();
      return loggedIn;
    } catch (error) {
      throw (error);
    }
  }

  Future<void> getUserInfo(String language) async {
    try {
      Dio.Response response = await dio().post(
        'pages/preparation_profile',
        data: Dio.FormData.fromMap(
          {'key': 1234567890, 'token_id': token, 'lang': language},
        ),
      );
      print(response);
      adress = response.data['result']['customer_info']['address'];
      name = response.data['result']['customer_info']['name'];
      phoneNumber = response.data['result']['customer_info']['phone'];
      city = response.data['result']['customer_info']['country_name'];
      cityId = response.data['result']['customer_info']['country_id'];
    } catch (error) {
      throw (error);
    }
  }

  Future<void> getUserInfoForSpalsh(String tokenForm, String language) async {
    try {
      Dio.Response response = await dio().post(
        'pages/preparation_profile',
        data: Dio.FormData.fromMap(
          {'key': 1234567890, 'token_id': tokenForm, 'lang': language},
        ),
      );
      print(response);
      adress = response.data['result']['customer_info']['address'];
      token = response.data['result']['customer_info']['token'];
      print('$token isis');
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  bool doneEdaite = false;
  Future<bool> edaitProfile(
      User user, String language, String city, String cityID) async {
    try {
      print('object');
      Dio.Response response = await dio().post(
        'pages/edit_profile',
        data: Dio.FormData.fromMap(
          user.sentEdaitProfile(token, language, city, cityID),
        ),
      );

      if (response.statusCode == 200) {
        doneEdaite = true;
      }
      notifyListeners();
      return doneEdaite;
    } catch (error) {
      throw (error);
    }
  }

  bool doneSub = false;
  Future<bool> subscribtion(User user, String language) async {
    try {
      Dio.Response response = await dio().post(
        'pages/set_subscribe',
        data: Dio.FormData.fromMap(
          user.sentSub(token, language),
        ),
      );
      print(response);
      if (response.data['status'] == false) {
        throw HttpExeption(response.data['message']);
      } else if (response.data['status'] == true) {
        doneSub = true;
      }
      return doneSub;
    } catch (e) {
      throw (e);
    }
  }

  bool doneSent = false;
  Future<bool> sentTickets(User user, String language) async {
    try {
      Dio.Response response = await dio().post(
        'pages/new_ticket',
        data: Dio.FormData.fromMap(
          user.sentTickets(token, language),
        ),
      );
      print(response.statusCode);
      if (response.data['status'] == true) {
        doneSent = true;
      }
      return doneSent;
    } catch (error) {
      throw (error);
    }
  }

  bool doneSentRegister = false;

  Future<bool> register(User user, String language, String country) async {
    try {
      Dio.Response response = await dio().post(
        'user_api/set_registration',
        data: Dio.FormData.fromMap(
          user.sentRegister(
            token,
            language,
            country,
            await FCMConfig().getToken(),
          ),
        ),
      );
      print(response);
      if (response.data['status'] == false) {
        throw HttpExeption(response.data['message']);
      }

      if (response.data['status'] == true) {
        doneSentRegister = true;
        registerList =
            registerModelFromJson(response.toString()).result.clientData;
        for (var i = 0; i < registerList.length; i++) {
          token = registerList[i].token;
          lang = registerList[i].lang;
          id = registerList[i].id;
          phoneNumber = registerList[i].phone;
          name = registerList[i].fullname;
        }
        final preferences = await SharedPreferences.getInstance();
        await preferences.setString('bool', token);

        token = preferences.getString('bool');
      }
      notifyListeners();
      return doneSentRegister;
    } catch (error) {
      throw (error);
    }
  }

  final savedLang = GetStorage();
  bool doneLogOut = false;
  Future<bool> logout(String lang) async {
    try {
      Dio.Response response = await dio().post(
        'user_api/logout',
        data: Dio.FormData.fromMap(
          {'lang': lang, 'token_id': token, 'key': 1234567890},
        ),
      );
      print(response);
      if (response.data['status'] == true) {
        final preferences = await SharedPreferences.getInstance();
        preferences.remove('bool');
        savedLang.remove('lang');
        doneLogOut = true;
      }
      notifyListeners();
      return doneLogOut;
    } catch (e) {
      throw (e);
    }
  }
}
