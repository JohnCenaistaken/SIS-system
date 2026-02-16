import 'package:flutter/material.dart';

/// Feature model for SIS system features
class Feature {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const Feature({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });
}
