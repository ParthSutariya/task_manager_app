import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/domain/entities/simple_task.dart';
import 'package:task_manager_app/domain/entities/task.dart';
import 'package:task_manager_app/domain/entities/timed_task.dart';
import 'package:task_manager_app/presentation/bloc/task_bloc.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

enum TaskType { simple, timed }

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  TaskType _selectedType = TaskType.simple;
  DateTime? _dueDateTime;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: bottomInset + 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Task',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Task type:'),
                  const SizedBox(width: 16),
                  DropdownButton<TaskType>(
                    value: _selectedType,
                    items: const [
                      DropdownMenuItem(
                        value: TaskType.simple,
                        child: Text('Simple'),
                      ),
                      DropdownMenuItem(
                        value: TaskType.timed,
                        child: Text('Timed'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedType = value;
                      });
                    },
                  ),
                ],
              ),
              if (_selectedType == TaskType.timed) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _pickDueDateTime,
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      _dueDateTime == null
                          ? 'Pick due date & time'
                          : 'Due: ${_formatDateTime(_dueDateTime!)}',
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDueDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now.add(const Duration(minutes: 5))),
    );
    if (time == null) return;

    setState(() {
      _dueDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedType == TaskType.timed && _dueDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select due date & time')),
      );
      return;
    }

    final bloc = context.read<TaskBloc>(); // from flutter_bloc now

    final id = DateTime.now().millisecondsSinceEpoch.toString();

    Task task;
    if (_selectedType == TaskType.simple) {
      task = SimpleTask(
        id: id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );
    } else {
      task = TimedTask(
        id: id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueTime: _dueDateTime!,
      );
    }

    bloc.add(AddTaskEvent(task));
    Navigator.of(context).pop();
  }

  String _formatDateTime(DateTime dateTime) {
    final date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    final time =
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
    return '$date $time';
  }
}
