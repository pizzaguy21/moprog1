import 'package:flutter/material.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final IconData? icon; // Tambahkan icon
  final String? link;   // Tambahkan link
  bool isFavourite;

  Course({
    required this.id,
    required this.title,
    required this.description,
    this.icon,
    this.link,
    this.isFavourite = false,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Course && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
