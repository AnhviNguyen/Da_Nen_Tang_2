import 'package:week7/interface/ITodoRepository.dart';
import 'package:week7/model/Todo.dart';

class GetTodosUseCase {
  final ITodoRepository repository;

  GetTodosUseCase(this.repository);

  Future<List<Todo>> execute() async {
    return await repository.getAllTodos();
  }
}