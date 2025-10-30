import 'package:expense_tracker/model/Category.dart';
import 'package:expense_tracker/model/Expense.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getAllExpenses();
  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end);
  Future<void> addExpense(Expense expense);
  Future<void> updateExpense(Expense expense);
  Future<void> deleteExpense(String id);
  Stream<List<Expense>> watchExpenses();
}