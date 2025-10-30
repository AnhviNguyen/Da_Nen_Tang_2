import 'package:week7/interface/ITodoRepository.dart';
import 'package:week7/model/Todo.dart';

class ToggleTodoUseCase {
  final ITodoRepository repository;

  ToggleTodoUseCase(this.repository);

  Future<void> execute(Todo todo) async {
    final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
    await repository.updateTodo(updatedTodo);
  }
}