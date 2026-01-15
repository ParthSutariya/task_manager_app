import 'package:equatable/equatable.dart';
import 'task_status.dart';

abstract class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    this.status = TaskStatus.pending,
  });

  Task complete(DateTime now);

  bool get isCompleted => status == TaskStatus.completed;

  String get typeLabel;

  @override
  List<Object?> get props => [id, title, description, status];
}
