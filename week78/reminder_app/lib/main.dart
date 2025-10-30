import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/impelment/NotificationService.dart';
import 'package:reminder_app/model/AddReminderUseCase.dart';
import 'package:reminder_app/model/CompleteReminderUseCase.dart';
import 'package:reminder_app/model/DeleteReminderUseCase.dart';
import 'package:reminder_app/model/GetAllRemindersUseCase.dart';
import 'package:reminder_app/model/GetUpcomingRemindersUseCase.dart';
import 'package:reminder_app/model/UpdateReminderUseCase.dart';
import 'package:reminder_app/provider/ReminderProvider.dart';
import 'package:reminder_app/repository/HiveReminderRepository.dart';
import 'package:reminder_app/screen/HomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final repository = HiveReminderRepository();
  await repository.init();

  final notificationService = NotificationService();
  await notificationService.initialize();

  // Dependency Injection
  final addReminderUseCase = AddReminderUseCase(repository, notificationService);
  final updateReminderUseCase = UpdateReminderUseCase(repository, notificationService);
  final deleteReminderUseCase = DeleteReminderUseCase(repository, notificationService);
  final getAllRemindersUseCase = GetAllRemindersUseCase(repository);
  final getUpcomingRemindersUseCase = GetUpcomingRemindersUseCase(repository);
  final completeReminderUseCase = CompleteReminderUseCase(repository, notificationService);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ReminderProvider(
        addReminderUseCase: addReminderUseCase,
        updateReminderUseCase: updateReminderUseCase,
        deleteReminderUseCase: deleteReminderUseCase,
        getAllRemindersUseCase: getAllRemindersUseCase,
        getUpcomingRemindersUseCase: getUpcomingRemindersUseCase,
        completeReminderUseCase: completeReminderUseCase,
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

