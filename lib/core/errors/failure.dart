// core/errors/failure.dart
class Failure {
  final String message;
  final String? code; // Optional, for API error codes or similar

  Failure(this.message, {this.code});

  @override
  String toString() => message;
}
