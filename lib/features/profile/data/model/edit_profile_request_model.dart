class EditProfileRequest {
  final String id;
  final String name;
  final String email;
  final String phone;

  EditProfileRequest({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'phone': phone};
  }
}
