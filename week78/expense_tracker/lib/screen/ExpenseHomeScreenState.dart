import 'package:expense_tracker/implement/ExpenseRepositoryImpl.dart';
import 'package:expense_tracker/reposittory/ExpenseRepository.dart';
import 'package:expense_tracker/screen/AddExpenseSheet.dart';
import 'package:expense_tracker/screen/ExpenseHomeScreen.dart';
import 'package:expense_tracker/screen/ExpenseListScreen.dart';
import 'package:expense_tracker/screen/StatisticsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpenseHomeScreenState extends State<ExpenseHomeScreen> {
  late final ExpenseRepository _repository;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _repository = ExpenseRepositoryImpl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          ExpenseListScreen(repository: _repository),
          StatisticsScreen(repository: _repository),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Expenses',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
        onPressed: () {
          _showAddExpenseDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      )
          : null,
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddExpenseSheet(repository: _repository),
    );
  }
}