import 'package:dio/dio.dart';

Dio dio() {
  Dio dio = Dio();
  dio.options.baseUrl = "https://wasselni.ps/";
  dio.options.connectTimeout = 20000;
  return dio;
}
