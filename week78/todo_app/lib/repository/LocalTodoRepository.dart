import 'package:shared_preferences/shared_preferences.dart';
import 'package:week7/interface/ITodoRepository.dart';
import 'package:week7/model/Todo.dart';
import 'dart:convert';

class LocalTodoRepository implements ITodoRepository {
  static const String _storageKey = 'todos';
  final SharedPreferences _prefs;

  LocalTodoRepository(this._prefs);

  @override
  Future<List<Todo>> getAllTodos() async {
    final String? todosJson = _prefs.getString(_storageKey);
    if (todosJson == null) return [];

    final List<dynamic> decoded = json.decode(todosJson);
    return decoded.map((item) => Todo.fromJson(item)).toList();
  }

  @override
  Future<void> saveTodos(List<Todo> todos) async {
    final String encoded = json.encode(
      todos.map((todo) => todo.toJson()).toList(),
    );
    await _prefs.setString(_storageKey, encoded);
  }

  @override
  Future<void> addTodo(Todo todo) async {
    final todos = await getAllTodos();
    todos.insert(0, todo);
    await saveTodos(todos);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final todos = await getAllTodos();
    final index = todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      todos[index] = todo;
      await saveTodos(todos);
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    final todos = await getAllTodos();
    todos.removeWhere((todo) => todo.id == id);
    await saveTodos(todos);
  }
}