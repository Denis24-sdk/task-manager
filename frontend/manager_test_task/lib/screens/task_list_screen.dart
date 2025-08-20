import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:manager_test_task/main.dart';
import 'package:manager_test_task/models/task.dart';
import 'package:manager_test_task/providers/task_provider.dart';
import 'package:manager_test_task/screens/login_screen.dart';
import 'package:manager_test_task/screens/task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    });
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, TaskProvider taskProvider, Task task) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text(
            'Confirm Deletion',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryText),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to delete this task?',
                  style: TextStyle(color: AppColors.secondaryText),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: AppColors.secondaryText)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onPressed: () {
                taskProvider.deleteTask(task.id);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0, bottom: 60.0),
      decoration: const BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: AppColors.primaryBlue),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const TaskFormScreen()),
                      ).then((_) {
                        Provider.of<TaskProvider>(context, listen: false).fetchTasks();
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () {
                      Provider.of<TaskProvider>(context, listen: false).logout();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          const Text('My Task', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const Text('Today', style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 10),
          Center(
            child: Text(
              DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task, TaskProvider taskProvider, BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      elevation: 5.0,
      shadowColor: AppColors.primaryBlue.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
                  const SizedBox(height: 8.0),
                  Text(
                    task.description ?? 'No description',
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      task.dueDate != null ? DateFormat('d MMM yyyy').format(DateTime.parse(task.dueDate!)) : 'No due date',
                      style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppColors.secondaryText),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TaskFormScreen(task: task)),
                    ).then((_){
                      taskProvider.fetchTasks();
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, taskProvider, task);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildHeader(context),
          Container(
            margin: const EdgeInsets.only(top: 220.0),
            decoration: const BoxDecoration(
              color: AppColors.lightBlueBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  if (taskProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (taskProvider.tasks.isEmpty) {
                    return const Center(
                      child: Text(
                        'No tasks yet. Create one!',
                        style: TextStyle(fontSize: 18, color: AppColors.secondaryText),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    itemCount: taskProvider.tasks.length,
                    itemBuilder: (context, index) {
                      final task = taskProvider.tasks[index];
                      return _buildTaskCard(task, taskProvider, context);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}