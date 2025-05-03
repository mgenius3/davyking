// core/errors/app_exception.dart
class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});
}

class NetworkException extends AppException {
  NetworkException(String message, {String? code}) : super(message, code: code);
}

class ValidationException extends AppException {
  ValidationException(String message, {String? code}) : super(message, code: code);
}

class UnknownException extends AppException {
  UnknownException(String message, {String? code}) : super(message, code: code);
}
