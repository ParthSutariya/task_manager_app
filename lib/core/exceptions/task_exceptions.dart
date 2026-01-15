class TaskCompletionNotAllowedException implements Exception {
  final String message;
  TaskCompletionNotAllowedException(this.message);

  @override
  String toString() => message;
}
