import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/in_memory_task_repository.dart';
import 'domain/usecases/add_task_usecase.dart';
import 'domain/usecases/complete_task_usecase.dart';
import 'domain/usecases/get_tasks_usecase.dart';
import 'presentation/bloc/task_bloc.dart';
import 'presentation/pages/task_list_page.dart';

void main() {
  final taskRepository = InMemoryTaskRepository();

  final getTasksUseCase = GetTasksUseCase(taskRepository);
  final addTaskUseCase = AddTaskUseCase(taskRepository);
  final completeTaskUseCase = CompleteTaskUseCase(taskRepository);

  runApp(
    MyApp(
      getTasksUseCase: getTasksUseCase,
      addTaskUseCase: addTaskUseCase,
      completeTaskUseCase: completeTaskUseCase,
    ),
  );
}

class MyApp extends StatelessWidget {
  final GetTasksUseCase getTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final CompleteTaskUseCase completeTaskUseCase;

  const MyApp({
    super.key,
    required this.getTasksUseCase,
    required this.addTaskUseCase,
    required this.completeTaskUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: BlocProvider(
        create: (_) => TaskBloc(
          getTasksUseCase: getTasksUseCase,
          addTaskUseCase: addTaskUseCase,
          completeTaskUseCase: completeTaskUseCase,
        )..add(const LoadTasks()),
        child: const TaskListPage(),
      ),
    );
  }
}
