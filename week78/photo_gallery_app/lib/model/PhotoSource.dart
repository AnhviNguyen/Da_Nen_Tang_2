import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
enum PhotoSource {
  @HiveField(0)
  camera,
  @HiveField(1)
  gallery;

  String get displayName {
    switch (this) {
      case PhotoSource.camera:
        return 'Camera';
      case PhotoSource.gallery:
        return 'Gallery';
    }
  }

  IconData get icon {
    switch (this) {
      case PhotoSource.camera:
        return Icons.camera_alt;
      case PhotoSource.gallery:
        return Icons.photo_library;
    }
  }
}