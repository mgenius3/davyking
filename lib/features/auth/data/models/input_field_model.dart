import 'package:flutter/material.dart';

class AuthInputFieldModel {
  final TextEditingController inputcontroller;
  final String name;
  final String? hintText;
  final Widget? suffixIcon;
  final bool obscureText;

  const AuthInputFieldModel(
      {required this.inputcontroller,
      required this.name,
      this.hintText,
      this.suffixIcon,
      this.obscureText = false});
}
