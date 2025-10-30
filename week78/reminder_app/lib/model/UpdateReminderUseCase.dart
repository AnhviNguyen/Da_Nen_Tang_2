import 'package:reminder_app/model/Reminder.dart';
import 'package:reminder_app/repository/INotificationService.dart';
import 'package:reminder_app/repository/IReminderRepository.dart';

class UpdateReminderUseCase {
  final IReminderRepository repository;
  final INotificationService notificationService;

  UpdateReminderUseCase(this.repository, this.notificationService);

  Future<void> execute(Reminder reminder) async {
    await repository.updateReminder(reminder);

    // Cancel old notification
    await notificationService.cancelNotification(reminder.notificationId);

    // Reschedule if not completed and in future
    if (!reminder.isCompleted && reminder.scheduledTime.isAfter(DateTime.now())) {
      await notificationService.scheduleNotification(reminder);
    }
  }
}