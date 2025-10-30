import 'package:expense_tracker/reposittory/ExpenseRepository.dart';
import 'package:expense_tracker/reposittory/ExpenseStatistics.dart';

class GetStatisticsUseCase {
  final ExpenseRepository repository;

  GetStatisticsUseCase(this.repository);

  Future<ExpenseStatistics> call(DateTime start, DateTime end) async {
    final expenses = await repository.getExpensesByDateRange(start, end);
    return ExpenseStatistics.fromExpenses(expenses);
  }
}