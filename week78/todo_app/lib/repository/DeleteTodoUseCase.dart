import 'package:week7/interface/ITodoRepository.dart';

class DeleteTodoUseCase {
  final ITodoRepository repository;

  DeleteTodoUseCase(this.repository);

  Future<void> execute(String id) async {
    await repository.deleteTodo(id);
  }
}