import 'package:fcm_config/fcm_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wassalny/waslnyApp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await GetStorage.init();
  await FCMConfig().init();
  FCMConfig().getToken().then((token) {});
  runApp(
    WaslnyApp(),
  );
}
