import 'package:flutter/cupertino.dart';
import 'package:week7/model/Todo.dart';
import 'package:week7/repository/AddTodoUseCase.dart';
import 'package:week7/repository/DeleteTodoUseCase.dart';
import 'package:week7/repository/GetTodosUseCase.dart';
import 'package:week7/repository/ToggleTodoUseCase.dart';

class TodoController extends ChangeNotifier {
  final GetTodosUseCase _getTodosUseCase;
  final AddTodoUseCase _addTodoUseCase;
  final ToggleTodoUseCase _toggleTodoUseCase;
  final DeleteTodoUseCase _deleteTodoUseCase;

  List<Todo> _todos = [];
  bool _showCompleted = true;
  bool _isLoading = false;

  TodoController({
    required GetTodosUseCase getTodosUseCase,
    required AddTodoUseCase addTodoUseCase,
    required ToggleTodoUseCase toggleTodoUseCase,
    required DeleteTodoUseCase deleteTodoUseCase,
  })  : _getTodosUseCase = getTodosUseCase,
        _addTodoUseCase = addTodoUseCase,
        _toggleTodoUseCase = toggleTodoUseCase,
        _deleteTodoUseCase = deleteTodoUseCase;

  // Getters
  List<Todo> get todos => _showCompleted
      ? _todos
      : _todos.where((todo) => !todo.isCompleted).toList();

  bool get showCompleted => _showCompleted;
  bool get isLoading => _isLoading;

  int get totalCount => _todos.length;
  int get completedCount => _todos.where((t) => t.isCompleted).length;
  int get pendingCount => totalCount - completedCount;

  // Actions
  Future<void> loadTodos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _todos = await _getTodosUseCase.execute();
    } catch (e) {
      // Handle error
      debugPrint('Error loading todos: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTodo(String title, String description) async {
    try {
      await _addTodoUseCase.execute(title, description);
      await loadTodos();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleTodo(Todo todo) async {
    try {
      await _toggleTodoUseCase.execute(todo);
      await loadTodos();
    } catch (e) {
      debugPrint('Error toggling todo: $e');
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await _deleteTodoUseCase.execute(id);
      await loadTodos();
    } catch (e) {
      debugPrint('Error deleting todo: $e');
    }
  }

  void toggleShowCompleted() {
    _showCompleted = !_showCompleted;
    notifyListeners();
  }
}