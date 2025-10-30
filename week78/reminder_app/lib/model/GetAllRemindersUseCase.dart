import 'package:reminder_app/model/Reminder.dart';
import 'package:reminder_app/repository/IReminderRepository.dart';

class GetAllRemindersUseCase {
  final IReminderRepository repository;

  GetAllRemindersUseCase(this.repository);

  Future<List<Reminder>> execute() async {
    return await repository.getAllReminders();
  }
}