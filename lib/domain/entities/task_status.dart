enum TaskStatus { pending, completed }

extension TaskStatusX on TaskStatus {
  String get label => this == TaskStatus.pending ? 'Pending' : 'Completed';
}
