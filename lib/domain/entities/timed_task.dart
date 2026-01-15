import 'package:task_manager_app/core/exceptions/task_exceptions.dart';
import 'task.dart';
import 'task_status.dart';

class TimedTask extends Task {
  final DateTime dueTime;

  const TimedTask({
    required this.dueTime,
    required super.id,
    required super.title,
    required super.description,
    super.status = TaskStatus.pending,
  });

  bool get isDue =>
      DateTime.now().isAfter(dueTime) ||
      DateTime.now().isAtSameMomentAs(dueTime);

  @override
  Task complete(DateTime now) {
    if (now.isBefore(dueTime)) {
      throw TaskCompletionNotAllowedException(
        'Timed task can only be completed after its due time.',
      );
    }

    if (isCompleted) return this;

    return TimedTask(
      id: id,
      title: title,
      description: description,
      dueTime: dueTime,
      status: TaskStatus.completed,
    );
  }

  @override
  String get typeLabel => 'Timed';

  @override
  List<Object?> get props => [...super.props, dueTime];
}
