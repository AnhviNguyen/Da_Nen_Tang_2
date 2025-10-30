import 'package:expense_tracker/reposittory/ExpenseRepository.dart';
import 'package:expense_tracker/screen/StatisticsScreenState.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  final ExpenseRepository repository;

  const StatisticsScreen({super.key, required this.repository});

  @override
  State<StatisticsScreen> createState() => StatisticsScreenState();
}