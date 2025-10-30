import 'package:week7/model/Todo.dart';

abstract class ITodoRepository {
  Future<List<Todo>> getAllTodos();
  Future<void> saveTodos(List<Todo> todos);
  Future<void> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
}