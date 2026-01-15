import 'package:task_manager_app/domain/entities/simple_task.dart';
import 'package:task_manager_app/domain/entities/task.dart';
import 'package:task_manager_app/domain/entities/timed_task.dart';
import 'package:task_manager_app/domain/repositories/task_repository.dart';

class InMemoryTaskRepository implements TaskRepository {
  final List<Task> _tasks = [];

  InMemoryTaskRepository() {
    _tasks.addAll([
      SimpleTask(
        id: '1',
        title: 'Read Flutter docs',
        description: 'Review Flutter documentation.',
      ),
      TimedTask(
        id: '2',
        title: 'Submit take-home assignment',
        description: 'Send GitHub repo to Syed.',
        dueTime: DateTime.now().add(const Duration(minutes: 1)),
      ),
    ]);
  }

  @override
  Future<void> addTask(Task task) async {
    _tasks.add(task);
  }

  @override
  Future<List<Task>> getTasks() async {
    return List.unmodifiable(_tasks);
  }

  @override
  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }
}
