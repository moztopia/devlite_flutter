import 'package:dio/dio.dart';
import 'package:devlite_flutter/services/ApiService/api_service.dart';

Future<Response> postWelcome({required Map<String, dynamic> data}) {
  return ApiService().post('/welcome', data: data);
}
