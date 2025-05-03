class SignUpRequest {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String password_confirmation;

  SignUpRequest({
    required this.name,
    required this.password,
    required this.phone,
    required this.email,
    required this.password_confirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'password': password,
      'email': email,
      'phone': phone,
      'password_confirmation': password_confirmation
    };
  }
}
