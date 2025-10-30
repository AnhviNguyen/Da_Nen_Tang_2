import 'package:hive/hive.dart';
import 'package:expense_tracker/model/Expense.dart';
import 'package:expense_tracker/reposittory/ExpenseRepository.dart';

class HiveExpenseRepository implements ExpenseRepository {
  final Box<Expense> _box = Hive.box<Expense>('expenses');

  @override
  Future<List<Expense>> getAllExpenses() async {
    return _box.values.toList();
  }

  @override
  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end) async {
    return _box.values.where((expense) => expense.date.isAfter(start.subtract(const Duration(days: 1))) && expense.date.isBefore(end.add(const Duration(days: 1)))).toList();
  }

  @override
  Future<void> addExpense(Expense expense) async {
    await _box.put(expense.id, expense);
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    await _box.put(expense.id, expense);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _box.delete(id);
  }

  @override
  Stream<List<Expense>> watchExpenses() {
    return _box.watch().map((event) => _box.values.toList());
  }
}
