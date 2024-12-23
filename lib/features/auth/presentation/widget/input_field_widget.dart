import 'package:davyking/features/auth/data/models/input_field_model.dart';
import 'package:flutter/material.dart';

Widget authInputField(AuthInputFieldModel params) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        params.name,
        style: const TextStyle(
            color: Colors.black,
            fontSize: 13.39,
            fontWeight: FontWeight.w500,
            height: 1.43),
      ),
      const SizedBox(height: 5),
      TextFormField(
        controller: params.inputcontroller,
        obscureText: params.obscureText,
        decoration: InputDecoration(
            hintText: params.hintText,
            suffixIcon: params.suffixIcon,
            suffixIconConstraints:
                const BoxConstraints(minWidth: 40, minHeight: 50),
            border: OutlineInputBorder(
                borderSide: const BorderSide(width: 1),
                borderRadius: BorderRadius.circular(11.48))),
      )
    ],
  );
}
