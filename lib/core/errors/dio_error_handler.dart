import 'package:dio/dio.dart';

class DioErrorHandler {
  static String handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timed out. Please try again.";
      case DioExceptionType.sendTimeout:
        return "Request took too long to send. Check your network.";
      case DioExceptionType.receiveTimeout:
        return "Server took too long to respond. Try again later.";
      case DioExceptionType.badResponse:
        return "Server error (${e.response?.statusCode}): ${e.response?.statusMessage}";
      case DioExceptionType.connectionError:
        return "Could not connect to the server. Check your internet.";
      case DioExceptionType.unknown:
        return "An unknown network error occurred: ${e.message}";
      default:
        return "An unexpected error occurred. Please try again.";
    }
  }
}
