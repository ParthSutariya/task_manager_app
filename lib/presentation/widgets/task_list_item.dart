import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/domain/entities/task.dart';
import 'package:task_manager_app/domain/entities/timed_task.dart';
import 'package:task_manager_app/presentation/bloc/task_bloc.dart';

class TaskListItem extends StatelessWidget {
  final Task task;

  const TaskListItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isTimed = task is TimedTask;
    DateTime? dueTime;
    bool isDue = true;

    if (task is TimedTask) {
      final timed = task as TimedTask;
      dueTime = timed.dueTime;
      isDue =
          DateTime.now().isAfter(dueTime) ||
          DateTime.now().isAtSameMomentAs(dueTime);
    }

    return ListTile(
      leading: Icon(
        task.isCompleted
            ? Icons.check_circle
            : isTimed
            ? (isDue ? Icons.alarm_on : Icons.lock_clock)
            : Icons.radio_button_unchecked,
        color: task.isCompleted ? Colors.green : null,
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (task.description.isNotEmpty) Text(task.description),
          Text(
            isTimed && dueTime != null
                ? 'Type: Timed • Due: ${_formatDateTime(dueTime)}'
                : 'Type: ${task.typeLabel}',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
      trailing: Checkbox(
        value: task.isCompleted,
        onChanged: task.isCompleted
            ? null
            : (_) {
                context.read<TaskBloc>().add(CompleteTaskEvent(task.id));
              },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    final time =
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
    return '$date $time';
  }
}
