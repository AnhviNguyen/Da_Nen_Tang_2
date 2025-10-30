import 'package:reminder_app/model/Reminder.dart';
import 'package:reminder_app/repository/INotificationService.dart';
import 'package:reminder_app/repository/IReminderRepository.dart';

class CompleteReminderUseCase {
  final IReminderRepository repository;
  final INotificationService notificationService;

  CompleteReminderUseCase(this.repository, this.notificationService);

  Future<void> execute(Reminder reminder) async {
    final completed = reminder.copyWith(isCompleted: true);
    await notificationService.cancelNotification(reminder.notificationId);
    await repository.updateReminder(completed);
  }
}