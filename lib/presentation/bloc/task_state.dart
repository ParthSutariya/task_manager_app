part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {
  const TaskInitial();
}

class TaskLoadInProgress extends TaskState {
  const TaskLoadInProgress();
}

class TaskLoadSuccess extends TaskState {
  final List<Task> tasks;
  final String? message;
  final String? error;

  const TaskLoadSuccess({required this.tasks, this.message, this.error});

  TaskLoadSuccess copyWith({
    List<Task>? tasks,
    String? message,
    String? error,
  }) {
    return TaskLoadSuccess(
      tasks: tasks ?? this.tasks,
      message: message,
      error: error,
    );
  }

  @override
  List<Object?> get props => [tasks, message, error];
}

class TaskLoadFailure extends TaskState {
  final String message;

  const TaskLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}
