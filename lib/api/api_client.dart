import 'package:dio/dio.dart';
import 'package:davyking/core/constants/api_url.dart';
import 'package:davyking/core/services/secure_storage_service.dart';

class DioClient {
  late Dio _dio;

  DioClient({Map<String, dynamic>? headers}) {
    _dio = Dio(
      BaseOptions(
          baseUrl: ApiUrl.base_url,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: headers),
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Dynamically add authorization token from secure storage
        final storageService = SecureStorageService();
        final token = await storageService.getData('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (error, handler) {
        return handler.next(error);
      },
    ));
  }

  Future<void> updateToken() async {
    final storageService = SecureStorageService();
    final token = await storageService.getData('auth_token');
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<Response> get(String endpoint, {Map<String, dynamic>? query}) async {
    return await _dio.get(endpoint, queryParameters: query);
  }

  Future<Response> post(String endpoint, {dynamic data}) async {
    return await _dio.post(endpoint, data: data);
  }

  Future<Response> patch(String endpoint, {dynamic data}) async {
    return await _dio.patch(endpoint, data: data);
  }

  Future<Response> put(String endpoint, {dynamic data}) async {
    return await _dio.put(endpoint, data: data);
  }

  Future<Response> delete(String endpoint, {dynamic data}) async {
    return await _dio.delete(endpoint, data: data);
  }

  Future<Response> postMultipart(
    String endpoint, {
    required Map<String, dynamic> fields,
    required Map<String, MultipartFile> files,
  }) async {
    FormData formData = FormData();

    // Add fields to the form data
    fields.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });

    // Add files to the form data
    files.forEach((key, file) {
      formData.files.add(MapEntry(key, file));
    });

    return await _dio.post(endpoint, data: formData);
  }
}
