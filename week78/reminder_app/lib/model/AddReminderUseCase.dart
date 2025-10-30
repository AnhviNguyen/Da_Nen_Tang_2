import 'package:reminder_app/model/Reminder.dart';
import 'package:reminder_app/repository/INotificationService.dart';
import 'package:reminder_app/repository/IReminderRepository.dart';

class AddReminderUseCase {
  final IReminderRepository repository;
  final INotificationService notificationService;

  AddReminderUseCase(this.repository, this.notificationService);

  Future<Reminder> execute({
    required String title,
    String? description,
    required DateTime scheduledTime,
    String? category,
  }) async {
    final notificationId = DateTime.now().millisecondsSinceEpoch % 100000;

    final reminder = Reminder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      scheduledTime: scheduledTime,
      category: category,
      notificationId: notificationId,
    );

    await repository.addReminder(reminder);

    // Schedule notification if in future
    if (scheduledTime.isAfter(DateTime.now())) {
      await notificationService.scheduleNotification(reminder);
    }

    return reminder;
  }
}