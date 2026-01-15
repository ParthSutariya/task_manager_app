import 'task.dart';
import 'task_status.dart';

class SimpleTask extends Task {
  const SimpleTask({
    required super.id,
    required super.title,
    required super.description,
    super.status = TaskStatus.pending,
  });

  @override
  Task complete(DateTime now) {
    if (isCompleted) return this;

    return SimpleTask(
      id: id,
      title: title,
      description: description,
      status: TaskStatus.completed,
    );
  }

  @override
  String get typeLabel => 'Simple';
}
