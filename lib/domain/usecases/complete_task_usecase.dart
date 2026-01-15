import '../entities/task.dart';
import '../repositories/task_repository.dart';

class CompleteTaskUseCase {
  final TaskRepository repository;

  CompleteTaskUseCase(this.repository);

  Future<List<Task>> call(String id) async {
    final tasks = await repository.getTasks();
    final index = tasks.indexWhere((t) => t.id == id);

    if (index == -1) {
      throw Exception('Task not found');
    }

    final task = tasks[index];

    // This may throw TaskCompletionNotAllowedException for TimedTask.
    final updatedTask = task.complete(DateTime.now());

    await repository.updateTask(updatedTask);
    return repository.getTasks();
  }
}
