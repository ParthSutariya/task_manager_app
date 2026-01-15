import '../entities/task.dart';

/// Repository abstraction (Clean architecture: domain layer).
abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
}
