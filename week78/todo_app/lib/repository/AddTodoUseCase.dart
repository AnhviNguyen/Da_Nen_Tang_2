import 'package:week7/interface/ITodoRepository.dart';
import 'package:week7/model/Todo.dart';

class AddTodoUseCase {
  final ITodoRepository repository;

  AddTodoUseCase(this.repository);

  Future<void> execute(String title, String description) async {
    if (title.trim().isEmpty) {
      throw Exception('Title cannot be empty');
    }

    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      description: description.trim(),
      createdAt: DateTime.now(),
    );

    await repository.addTodo(todo);
  }
}