import 'package:hive/hive.dart';
import 'Category.dart';


@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double amount;

  @HiveField(3)
  Category category;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  String? note;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });
}
