import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


@HiveType(typeId: 1)
enum Category {
  @HiveField(0)
  food,
  @HiveField(1)
  transport,
  @HiveField(2)
  entertainment,
  @HiveField(3)
  shopping,
  @HiveField(4)
  bills,
  @HiveField(5)
  other,
}

extension CategoryExt on Category {
  String get displayName {
    switch (this) {
      case Category.food:
        return 'Food & Dining';
      case Category.transport:
        return 'Transport';
      case Category.shopping:
        return 'Shopping';
      case Category.entertainment:
        return 'Entertainment';
      case Category.bills:
        return 'Bills';
      case Category.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case Category.food:
        return Icons.restaurant;
      case Category.transport:
        return Icons.directions_car;
      case Category.shopping:
        return Icons.shopping_bag;
      case Category.entertainment:
        return Icons.movie;
      case Category.bills:
        return Icons.receipt_long;
      case Category.other:
        return Icons.more_horiz;
    }
  }

  Color get color {
    switch (this) {
      case Category.food:
        return Colors.orange;
      case Category.transport:
        return Colors.blue;
      case Category.shopping:
        return Colors.pink;
      case Category.entertainment:
        return Colors.purple;
      case Category.bills:
        return Colors.teal;
      case Category.other:
        return Colors.grey;
    }
  }
}
