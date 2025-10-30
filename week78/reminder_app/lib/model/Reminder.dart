import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Reminder extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final DateTime scheduledTime;

  @HiveField(4)
  final bool isCompleted;

  @HiveField(5)
  final String? category;

  @HiveField(6)
  final int notificationId;

  Reminder({
    required this.id,
    required this.title,
    this.description,
    required this.scheduledTime,
    this.isCompleted = false,
    this.category,
    required this.notificationId,
  });

  Reminder copyWith({
    String? title,
    String? description,
    DateTime? scheduledTime,
    bool? isCompleted,
    String? category,
  }) {
    return Reminder(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      notificationId: notificationId,
    );
  }

  bool get isPast => scheduledTime.isBefore(DateTime.now());
  bool get isToday {
    final now = DateTime.now();
    return scheduledTime.year == now.year &&
        scheduledTime.month == now.month &&
        scheduledTime.day == now.day;
  }
}
