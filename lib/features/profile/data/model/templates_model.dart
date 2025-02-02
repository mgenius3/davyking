import 'package:flutter/material.dart';

class ProfileTemplatesModel {
  final String title;
  final Widget child;
  final bool? showProfileDetails;

  const ProfileTemplatesModel(
      {required this.child,
      this.showProfileDetails = true,
      required this.title});
}
