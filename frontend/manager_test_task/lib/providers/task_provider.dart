import 'package:flutter/material.dart';
import 'package:manager_test_task/models/task.dart';
import 'package:manager_test_task/services/api_service.dart';

class TaskProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();
    try {
      _tasks = await _apiService.getTasks();
    } catch (e) {
      // Handle error
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title, String? description, String? dueDate) async {
    try {
      final newTask = await _apiService.createTask(title, description, dueDate);
      _tasks.insert(0, newTask);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateTask(Task task, String title, String? description, String? dueDate) async {
    try {
      final updatedTask = await _apiService.updateTask(task.id, title, description, dueDate);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _apiService.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    _tasks = [];
    notifyListeners();
  }
}