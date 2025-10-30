
import 'package:expense_tracker/implement/CategoryAdapter.dart';
import 'package:expense_tracker/implement/ExpenseAdapter.dart';
import 'package:expense_tracker/model/Category.dart';
import 'package:expense_tracker/model/Expense.dart';
import 'package:expense_tracker/screen/ExpenseHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(CategoryAdapter());

  // Open boxes
  await Hive.openBox<Expense>('expenses');
  await Hive.openBox<String>('settings');

  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
      ),
      home: const ExpenseHomeScreen(),
    );
  }
}