part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {
  const LoadTasks();
}

class AddTaskEvent extends TaskEvent {
  final Task task;

  const AddTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class CompleteTaskEvent extends TaskEvent {
  final String taskId;

  const CompleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}
