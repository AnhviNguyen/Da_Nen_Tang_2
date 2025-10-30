import 'package:reminder_app/model/Reminder.dart';
import 'package:reminder_app/repository/INotificationService.dart';
import 'package:reminder_app/repository/IReminderRepository.dart';

class DeleteReminderUseCase {
  final IReminderRepository repository;
  final INotificationService notificationService;

  DeleteReminderUseCase(this.repository, this.notificationService);

  Future<void> execute(Reminder reminder) async {
    await notificationService.cancelNotification(reminder.notificationId);
    await repository.deleteReminder(reminder.id);
  }
}