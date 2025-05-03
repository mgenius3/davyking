// core/errors/error_mapper.dart
import 'app_exception.dart';
import 'failure.dart';

class ErrorMapper {
  static Failure map(Exception exception) {
    if (exception is AppException) {
      return Failure(exception.message);
    }
    if (exception is NetworkException) {
      return Failure("Please check your internet connection.");
    } else if (exception is ValidationException) {
      return Failure(exception.message);
    } else if (exception is UnknownException) {
      return Failure("Something went wrong. Please try again.");
    } else {
      return Failure("An unexpected error occurred.");
    }
  }
}
