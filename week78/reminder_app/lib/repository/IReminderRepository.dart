import 'package:reminder_app/model/Reminder.dart';

abstract class IReminderRepository {
  Future<List<Reminder>> getAllReminders();
  Future<Reminder> addReminder(Reminder reminder);
  Future<void> updateReminder(Reminder reminder);
  Future<void> deleteReminder(String id);
  Future<List<Reminder>> getUpcomingReminders();
  Future<List<Reminder>> getCompletedReminders();
}