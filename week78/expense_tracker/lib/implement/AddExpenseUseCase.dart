
import 'package:expense_tracker/model/Expense.dart';
import 'package:expense_tracker/reposittory/ExpenseRepository.dart';

class AddExpenseUseCase {
  final ExpenseRepository repository;

  AddExpenseUseCase(this.repository);

  Future<void> call(Expense expense) => repository.addExpense(expense);
}
