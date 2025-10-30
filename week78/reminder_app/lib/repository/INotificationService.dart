import 'package:reminder_app/model/Reminder.dart';

abstract class INotificationService {
  Future<void> initialize();
  Future<void> scheduleNotification(Reminder reminder);
  Future<void> cancelNotification(int notificationId);
  Future<void> cancelAllNotifications();
}
