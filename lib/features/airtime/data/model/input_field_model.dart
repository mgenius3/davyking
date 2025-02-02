import 'package:flutter/material.dart';

class AirtimeInputFieldModel {
  final TextEditingController? inputcontroller;
  final Function(String)? onChanged;
  final String name;
  final String? hintText;
  final Widget? prefixIcon;
  final bool obscureText;

  const AirtimeInputFieldModel(
      {this.inputcontroller,
      this.onChanged,
      required this.name,
      this.hintText,
      this.prefixIcon,
      this.obscureText = false});
}
