import 'package:flutter/cupertino.dart';
import 'package:reminder_app/model/AddReminderUseCase.dart';
import 'package:reminder_app/model/CompleteReminderUseCase.dart';
import 'package:reminder_app/model/DeleteReminderUseCase.dart';
import 'package:reminder_app/model/GetAllRemindersUseCase.dart';
import 'package:reminder_app/model/GetUpcomingRemindersUseCase.dart';
import 'package:reminder_app/model/Reminder.dart';
import 'package:reminder_app/model/UpdateReminderUseCase.dart';

class ReminderProvider extends ChangeNotifier {
  final AddReminderUseCase addReminderUseCase;
  final UpdateReminderUseCase updateReminderUseCase;
  final DeleteReminderUseCase deleteReminderUseCase;
  final GetAllRemindersUseCase getAllRemindersUseCase;
  final GetUpcomingRemindersUseCase getUpcomingRemindersUseCase;
  final CompleteReminderUseCase completeReminderUseCase;

  List<Reminder> _reminders = [];
  bool _isLoading = false;

  ReminderProvider({
    required this.addReminderUseCase,
    required this.updateReminderUseCase,
    required this.deleteReminderUseCase,
    required this.getAllRemindersUseCase,
    required this.getUpcomingRemindersUseCase,
    required this.completeReminderUseCase,
  }) {
    loadReminders();
  }

  List<Reminder> get reminders => _reminders;
  bool get isLoading => _isLoading;

  List<Reminder> get upcomingReminders =>
      _reminders.where((r) => !r.isCompleted && !r.isPast).toList();

  List<Reminder> get completedReminders =>
      _reminders.where((r) => r.isCompleted).toList();

  List<Reminder> get todayReminders =>
      _reminders.where((r) => r.isToday && !r.isCompleted).toList();

  Future<void> loadReminders() async {
    _isLoading = true;
    notifyListeners();

    try {
      _reminders = await getAllRemindersUseCase.execute();
    } catch (e) {
      print('Error loading reminders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addReminder({
    required String title,
    String? description,
    required DateTime scheduledTime,
    String? category,
  }) async {
    await addReminderUseCase.execute(
      title: title,
      description: description,
      scheduledTime: scheduledTime,
      category: category,
    );
    await loadReminders();
  }

  Future<void> updateReminder(Reminder reminder) async {
    await updateReminderUseCase.execute(reminder);
    await loadReminders();
  }

  Future<void> deleteReminder(Reminder reminder) async {
    await deleteReminderUseCase.execute(reminder);
    await loadReminders();
  }

  Future<void> completeReminder(Reminder reminder) async {
    await completeReminderUseCase.execute(reminder);
    await loadReminders();
  }
}
