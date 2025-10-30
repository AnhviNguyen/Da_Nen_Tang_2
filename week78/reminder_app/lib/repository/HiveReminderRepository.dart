import 'package:hive_flutter/adapters.dart';
import 'package:reminder_app/impelment/ReminderAdapter.dart';
import 'package:reminder_app/model/Reminder.dart';
import 'package:reminder_app/repository/IReminderRepository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveReminderRepository implements IReminderRepository {
  static const String boxName = 'reminders';
  Box<Reminder>? _box;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ReminderAdapter());
    _box = await Hive.openBox<Reminder>(boxName);
  }

  Box<Reminder> get box {
    if (_box == null || !_box!.isOpen) {
      throw Exception('Hive box not initialized');
    }
    return _box!;
  }

  @override
  Future<List<Reminder>> getAllReminders() async {
    final reminders = box.values.toList();
    reminders.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    return reminders;
  }

  @override
  Future<Reminder> addReminder(Reminder reminder) async {
    await box.put(reminder.id, reminder);
    return reminder;
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    await box.put(reminder.id, reminder);
  }

  @override
  Future<void> deleteReminder(String id) async {
    await box.delete(id);
  }

  @override
  Future<List<Reminder>> getUpcomingReminders() async {
    final now = DateTime.now();
    final reminders = box.values
        .where((r) => !r.isCompleted && r.scheduledTime.isAfter(now))
        .toList();
    reminders.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    return reminders;
  }

  @override
  Future<List<Reminder>> getCompletedReminders() async {
    final reminders = box.values.where((r) => r.isCompleted).toList();
    reminders.sort((a, b) => b.scheduledTime.compareTo(a.scheduledTime));
    return reminders;
  }
}