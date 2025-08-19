import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:manager_test_task/models/task.dart';
import 'package:manager_test_task/providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  String? _description;
  DateTime? _dueDate;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      if (widget.task!.dueDate != null) {
        _dueDate = DateTime.parse(widget.task!.dueDate!);
        _dueDateController.text = DateFormat('yyyy-MM-dd').format(_dueDate!);
      }
    }
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(), // Нельзя выбрать прошедшую дату
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _dueDate) {
      setState(() {
        _dueDate = pickedDate;
        _dueDateController.text = DateFormat('yyyy-MM-dd').format(_dueDate!);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final dueDateString = _dueDate != null ? DateFormat('yyyy-MM-dd').format(_dueDate!) : null;

      if (widget.task == null) {
        taskProvider.addTask(_title, _description, dueDateString);
      } else {
        taskProvider.updateTask(widget.task!, _title, _description, dueDateString);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Create Task' : 'Edit Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    if(value.trim().length < 3) {
                      return 'Title must be at least 3 characters long';
                    }
                    return null;
                  },
                  onSaved: (value) => _title = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) {
                    if (value != null && value.length > 1000) {
                      return 'Description cannot be more than 1000 characters';
                    }
                    return null;
                  },
                  onSaved: (value) => _description = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dueDateController,
                  decoration: const InputDecoration(labelText: 'Due Date', hintText: 'Optional'),
                  readOnly: true,
                  onTap: _selectDate,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Save Task'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}