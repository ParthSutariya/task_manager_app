import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/presentation/bloc/task_bloc.dart';
import 'package:task_manager_app/presentation/widgets/add_task_bottom_sheet.dart';
import 'package:task_manager_app/presentation/widgets/task_list_item.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskLoadSuccess) {
            if (state.message != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message!)));
            }
            if (state.error != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error!)));
            }
          } else if (state is TaskLoadFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is TaskInitial || state is TaskLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoadSuccess) {
            if (state.tasks.isEmpty) {
              return const Center(child: Text('No tasks yet. Add one!'));
            }

            return ListView.separated(
              itemCount: state.tasks.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return TaskListItem(task: task);
              },
            );
          } else if (state is TaskLoadFailure) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddTaskSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openAddTaskSheet(BuildContext context) {
    final taskBloc = context
        .read<TaskBloc>(); // get existing bloc from the page

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return BlocProvider.value(
          value: taskBloc, // reuse the same instance
          child: const AddTaskBottomSheet(),
        );
      },
    );
  }
}
