
import 'package:expense_tracker/model/Expense.dart';
import 'package:expense_tracker/reposittory/ExpenseRepository.dart';

class GetExpensesUseCase {
  final ExpenseRepository repository;

  GetExpensesUseCase(this.repository);

  Future<List<Expense>> call() => repository.getAllExpenses();
}