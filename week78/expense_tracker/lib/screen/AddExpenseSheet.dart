import 'package:expense_tracker/reposittory/ExpenseRepository.dart';
import 'package:expense_tracker/screen/AddExpenseSheetState.dart';
import 'package:flutter/cupertino.dart';

class AddExpenseSheet extends StatefulWidget {
  final ExpenseRepository repository;

  const AddExpenseSheet({super.key, required this.repository});

  @override
  State<AddExpenseSheet> createState() => AddExpenseSheetState();
}