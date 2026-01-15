import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager_app/core/exceptions/task_exceptions.dart';
import 'package:task_manager_app/domain/entities/task.dart';
import 'package:task_manager_app/domain/usecases/add_task_usecase.dart';
import 'package:task_manager_app/domain/usecases/complete_task_usecase.dart';
import 'package:task_manager_app/domain/usecases/get_tasks_usecase.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasksUseCase _getTasksUseCase;
  final AddTaskUseCase _addTaskUseCase;
  final CompleteTaskUseCase _completeTaskUseCase;

  TaskBloc({
    required GetTasksUseCase getTasksUseCase,
    required AddTaskUseCase addTaskUseCase,
    required CompleteTaskUseCase completeTaskUseCase,
  }) : _getTasksUseCase = getTasksUseCase,
       _addTaskUseCase = addTaskUseCase,
       _completeTaskUseCase = completeTaskUseCase,
       super(const TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<CompleteTaskEvent>(_onCompleteTask);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(const TaskLoadInProgress());
    try {
      final tasks = await _getTasksUseCase();
      emit(TaskLoadSuccess(tasks: tasks));
    } catch (e) {
      emit(TaskLoadFailure('Failed to load tasks: $e'));
    }
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    final previousState = state;
    try {
      final tasks = await _addTaskUseCase(event.task);
      emit(TaskLoadSuccess(tasks: tasks, message: 'Task added successfully'));
    } catch (e) {
      emit(TaskLoadFailure('Failed to add task: $e'));
      emit(previousState);
    }
  }

  Future<void> _onCompleteTask(
    CompleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final currentState = state;
    try {
      final tasks = await _completeTaskUseCase(event.taskId);
      emit(TaskLoadSuccess(tasks: tasks, message: 'Task completed'));
    } on TaskCompletionNotAllowedException catch (e) {
      if (currentState is TaskLoadSuccess) {
        emit(TaskLoadSuccess(tasks: currentState.tasks, error: e.message));
      } else {
        emit(TaskLoadFailure(e.message));
      }
    } catch (e) {
      emit(TaskLoadFailure('Failed to complete task: $e'));
    }
  }
}
