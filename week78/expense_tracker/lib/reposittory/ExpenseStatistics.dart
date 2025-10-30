
import 'package:expense_tracker/model/Category.dart';
import 'package:expense_tracker/model/DailyExpense.dart';
import 'package:expense_tracker/model/Expense.dart';

class ExpenseStatistics {
  final double totalAmount;
  final Map<Category, double> categoryTotals;
  final List<DailyExpense> dailyExpenses;

  ExpenseStatistics({
    required this.totalAmount,
    required this.categoryTotals,
    required this.dailyExpenses,
  });

  factory ExpenseStatistics.fromExpenses(List<Expense> expenses) {
    double total = 0;
    final Map<Category, double> categoryMap = {};
    final Map<DateTime, double> dailyMap = {};

    for (final expense in expenses) {
      total += expense.amount;
      categoryMap[expense.category] =
          (categoryMap[expense.category] ?? 0) + expense.amount;

      final dayKey = DateTime(expense.date.year, expense.date.month, expense.date.day);
      dailyMap[dayKey] = (dailyMap[dayKey] ?? 0) + expense.amount;
    }

    final dailyExpenses = dailyMap.entries
        .map((e) => DailyExpense(date: e.key, amount: e.value))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return ExpenseStatistics(
      totalAmount: total,
      categoryTotals: categoryMap,
      dailyExpenses: dailyExpenses,
    );
  }
}