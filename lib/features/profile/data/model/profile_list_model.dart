import 'package:flutter/material.dart';

class ProfileListModel {
  final String profileListName;
  final IconData icon;
  final Color color; // Keep it final
  final String routes;

  ProfileListModel({
    required this.profileListName,
    required this.icon,
    required this.color, // Default value
    required this.routes,
  });
}
