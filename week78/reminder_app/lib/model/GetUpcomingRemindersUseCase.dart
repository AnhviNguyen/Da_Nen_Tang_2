import 'package:reminder_app/model/Reminder.dart';
import 'package:reminder_app/repository/IReminderRepository.dart';

class GetUpcomingRemindersUseCase {
  final IReminderRepository  repository;

  GetUpcomingRemindersUseCase(this.repository);

  Future<List<Reminder>> execute() async {
    return await repository.getUpcomingReminders();
  }
}