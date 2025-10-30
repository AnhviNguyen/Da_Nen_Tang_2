import 'package:expense_tracker/model/Category.dart';
import 'package:expense_tracker/model/Expense.dart';
import 'package:expense_tracker/reposittory/ExpenseRepository.dart';
import 'package:expense_tracker/screen/EmptyExpenseView.dart';
import 'package:expense_tracker/screen/ExpenseCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class ExpenseListScreen extends StatelessWidget {
  final ExpenseRepository repository;

  const ExpenseListScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Expense>('expenses').listenable(),
        builder: (context, Box<Expense> box, _) {
          if (box.isEmpty) {
            return const EmptyExpenseView();
          }

          final expenses = box.values.toList()
            ..sort((a, b) => b.date.compareTo(a.date));

          // Group by date
          final groupedExpenses = <String, List<Expense>>{};
          for (var expense in expenses) {
            final dateKey = _formatDateKey(expense.date);
            groupedExpenses.putIfAbsent(dateKey, () => []).add(expense);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groupedExpenses.length,
            itemBuilder: (context, index) {
              final dateKey = groupedExpenses.keys.elementAt(index);
              final dayExpenses = groupedExpenses[dateKey]!;
              final dayTotal = dayExpenses.fold<double>(
                0,
                    (sum, expense) => sum + expense.amount,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dateKey,
                          style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${dayTotal.toStringAsFixed(2)}',
                          style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...dayExpenses.map(
                        (expense) => ExpenseCard(
                      expense: expense,
                      onDelete: () => _deleteExpense(context, expense),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              );
            },
          );
        },
      ),
    );
  }

  String _formatDateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final expenseDate = DateTime(date.year, date.month, date.day);

    if (expenseDate == today) {
      return 'Today';
    } else if (expenseDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Future<void> _deleteExpense(BuildContext context, Expense expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await repository.deleteExpense(expense.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense deleted')),
        );
      }
    }
  }
}