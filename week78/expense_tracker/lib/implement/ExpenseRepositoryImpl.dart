import 'package:expense_tracker/model/Category.dart';
import 'package:expense_tracker/model/Expense.dart';
import 'package:expense_tracker/reposittory/ExpenseRepository.dart';
import 'package:hive/hive.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final Box<Expense> _expenseBox = Hive.box<Expense>('expenses');

  @override
  Future<List<Expense>> getAllExpenses() async {
    return _expenseBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<Expense>> getExpensesByDateRange(
      DateTime start, DateTime end) async {
    return _expenseBox.values
        .where((expense) =>
    expense.date.isAfter(start) && expense.date.isBefore(end))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<void> addExpense(Expense expense) async {
    await _expenseBox.put(expense.id, expense);
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    await _expenseBox.put(expense.id, expense);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _expenseBox.delete(id);
  }

  @override
  Stream<List<Expense>> watchExpenses() {
    return _expenseBox.watch().map((_) {
      return _expenseBox.values.toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    });
  }
}