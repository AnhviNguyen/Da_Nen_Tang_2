import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week7/Controller/TodoController.dart';
import 'package:week7/model/Todo.dart';
import 'package:week7/repository/AddTodoUseCase.dart';
import 'package:week7/repository/DeleteTodoUseCase.dart';
import 'package:week7/repository/GetTodosUseCase.dart';
import 'package:week7/repository/LocalTodoRepository.dart';
import 'package:week7/repository/ToggleTodoUseCase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dependency Injection
  final prefs = await SharedPreferences.getInstance();
  final repository = LocalTodoRepository(prefs);

  final getTodosUseCase = GetTodosUseCase(repository);
  final addTodoUseCase = AddTodoUseCase(repository);
  final toggleTodoUseCase = ToggleTodoUseCase(repository);
  final deleteTodoUseCase = DeleteTodoUseCase(repository);

  final controller = TodoController(
    getTodosUseCase: getTodosUseCase,
    addTodoUseCase: addTodoUseCase,
    toggleTodoUseCase: toggleTodoUseCase,
    deleteTodoUseCase: deleteTodoUseCase,
  );

  runApp(MyApp(controller: controller));
}

class MyApp extends StatelessWidget {
  final TodoController controller;

  const MyApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App - SOLID',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: TodoScreen(controller: controller),
    );
  }
}

// Main Screen
class TodoScreen extends StatefulWidget {
  final TodoController controller;

  const TodoScreen({super.key, required this.controller});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.loadTodos();
    widget.controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  void _onControllerUpdate() {
    setState(() {});
  }

  void _showAddTodoDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddTodoDialog(
        onAdd: (title, description) async {
          try {
            await widget.controller.addTodo(title, description);
            if (mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task added successfully!')),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.toString())),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: Icon(
              widget.controller.showCompleted
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
            onPressed: widget.controller.toggleShowCompleted,
            tooltip: widget.controller.showCompleted
                ? 'Hide completed'
                : 'Show completed',
          ),
        ],
      ),
      body: widget.controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          StatisticsCard(
            totalCount: widget.controller.totalCount,
            completedCount: widget.controller.completedCount,
            pendingCount: widget.controller.pendingCount,
          ),
          Expanded(
            child: TodoList(
              todos: widget.controller.todos,
              onToggle: widget.controller.toggleTodo,
              onDelete: (todo) async {
                await widget.controller.deleteTodo(todo.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Task deleted'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () async {
                          final repo = (widget.controller as dynamic)
                              ._addTodoUseCase
                              .repository;
                          await repo.addTodo(todo);
                          widget.controller.loadTodos();
                        },
                      ),
                    ),
                  );
                }
              },
              showCompleted: widget.controller.showCompleted,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTodoDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }
}

// Statistics Card Widget (Single Responsibility)
class StatisticsCard extends StatelessWidget {
  final int totalCount;
  final int completedCount;
  final int pendingCount;

  const StatisticsCard({
    super.key,
    required this.totalCount,
    required this.completedCount,
    required this.pendingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black87, Colors.black87],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(icon: Icons.list_alt, label: 'Total', value: totalCount.toString()),
          Container(width: 1, height: 40, color: Colors.white30),
          _StatItem(icon: Icons.check_circle, label: 'Completed', value: completedCount.toString()),
          Container(width: 1, height: 40, color: Colors.white30),
          _StatItem(icon: Icons.pending_actions, label: 'Pending', value: pendingCount.toString()),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

// Todo List Widget
class TodoList extends StatelessWidget {
  final List<Todo> todos;
  final Function(Todo) onToggle;
  final Function(Todo) onDelete;
  final bool showCompleted;

  const TodoList({
    super.key,
    required this.todos,
    required this.onToggle,
    required this.onDelete,
    required this.showCompleted,
  });

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              showCompleted ? Icons.task_alt : Icons.check_circle_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              showCompleted ? 'No tasks yet!\nTap + to add one' : 'All tasks completed!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return TodoItem(
          todo: todos[index],
          onToggle: () => onToggle(todos[index]),
          onDelete: () => onDelete(todos[index]),
        );
      },
    );
  }
}

// Todo Item Widget
class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Checkbox(
            value: todo.isCompleted,
            onChanged: (_) => onToggle(),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
              color: todo.isCompleted ? Colors.grey : null,
            ),
          ),
          subtitle: todo.description.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              todo.description,
              style: TextStyle(
                fontSize: 14,
                color: todo.isCompleted ? Colors.grey : Colors.grey[600],
                decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
              : null,
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            color: Colors.red[400],
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}

// Add Todo Dialog
class AddTodoDialog extends StatefulWidget {
  final Function(String title, String description) onAdd;

  const AddTodoDialog({super.key, required this.onAdd});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Add New Task', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Task Title',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.task_alt),
            ),
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
            ),
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => widget.onAdd(_titleController.text, _descriptionController.text),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Add Task', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}