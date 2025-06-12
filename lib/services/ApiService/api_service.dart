import 'package:dio/dio.dart';
import 'package:devlite_flutter/utilities/utilities.dart';

export 'package:devlite_flutter/services/ApiService/endpoints/endpoints.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio _dio;
  Future<String?> Function()? _tokenProvider;
  List<String>? _anonymousPaths;

  ApiService._internal();

  void initialize({
    required String baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Future<String?> Function()? tokenProvider,
    List<String>? anonymousPaths,
  }) {
    _tokenProvider = tokenProvider;
    _anonymousPaths = anonymousPaths;

    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout ?? const Duration(seconds: 5),
      receiveTimeout: receiveTimeout ?? const Duration(seconds: 3),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (_tokenProvider != null &&
            (_anonymousPaths == null ||
                !_anonymousPaths!.contains(options.path))) {
          final token = await _tokenProvider!();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            mozPrint('Auth token added for ${options.path}', 'API', 'AUTH');
          } else {
            mozPrint('No auth token available for ${options.path}.', 'API',
                'AUTH', 'WARNING');
          }
        } else {
          mozPrint('Request to ${options.path} is anonymous.', 'API', 'AUTH');
        }
        handler.next(options);
      },
      onError: (DioException e, handler) {
        mozPrint(
            'API Error Intercepted: ${e.response?.statusCode} for ${e.requestOptions.path}',
            'API',
            'INTERCEPTOR',
            'ERROR');
        handler.next(e);
      },
    ));
    mozPrint('ApiService initialized with base URL: $baseUrl', 'API',
        'INITIALIZATION');
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      final response = await _dio.get(path,
          queryParameters: queryParameters, options: options);
      mozPrint('$path success.', 'API', 'GET');
      return response;
    } on DioException catch (e) {
      mozPrint('$path failed: ${e.message}', 'API', 'GET', 'ERROR');
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data, Options? options}) async {
    try {
      final response = await _dio.post(path, data: data, options: options);
      mozPrint('$path success.', 'API', 'POST');
      return response;
    } on DioException catch (e) {
      mozPrint('$path failed: ${e.message}', 'API', 'POST', 'ERROR');
      rethrow;
    }
  }

  Future<Response> put(String path, {dynamic data, Options? options}) async {
    try {
      final response = await _dio.put(path, data: data, options: options);
      mozPrint('$path success.', 'API', 'PUT');
      return response;
    } on DioException catch (e) {
      mozPrint('$path failed: ${e.message}', 'API', 'PUT', 'ERROR');
      rethrow;
    }
  }

  Future<Response> patch(String path, {dynamic data, Options? options}) async {
    try {
      final response = await _dio.patch(path, data: data, options: options);
      mozPrint('$path success.', 'API', 'PATCH');
      return response;
    } on DioException catch (e) {
      mozPrint('$path failed: ${e.message}', 'API', 'PATCH', 'ERROR');
      rethrow;
    }
  }

  Future<Response> delete(String path, {dynamic data, Options? options}) async {
    try {
      final response = await _dio.delete(path, data: data, options: options);
      mozPrint('$path success.', 'API', 'DELETE');
      return response;
    } on DioException catch (e) {
      mozPrint('$path failed: ${e.message}', 'API', 'DELETE', 'ERROR');
      rethrow;
    }
  }
}
