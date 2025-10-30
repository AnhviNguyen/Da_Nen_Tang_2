import 'package:expense_tracker/reposittory/ExpenseRepository.dart';

class DeleteExpenseUseCase {
  final ExpenseRepository repository;

  DeleteExpenseUseCase(this.repository);

  Future<void> call(String id) => repository.deleteExpense(id);
}