import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:manager_test_task/models/task.dart';

class ApiService {
  final String _baseUrl = "http://172.31.210.177:8000/api";
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<Map<String, String>> _getHeaders() async {
    String? token = await _getToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    final body = jsonEncode({'email': email, 'password': password});

    print('Sending POST request to: $url');
    print('Request body: $body');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: body,
      ).timeout(const Duration(seconds: 10));

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _storage.write(key: 'auth_token', value: data['token']);
        return true;
      }
      return false;
    } catch (e) {
      print('An error occurred: $e');
      return false;
    }
  }

  Future<bool> register(String name, String email, String password, String passwordConfirmation) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await http.post(
      Uri.parse('$_baseUrl/logout'),
      headers: await _getHeaders(),
    );
    await _storage.delete(key: 'auth_token');
  }

  Future<List<Task>> getTasks() async {
    final response = await http.get(Uri.parse('$_baseUrl/tasks'), headers: await _getHeaders());
    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((model) => Task.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<Task> createTask(String title, String? description, String? dueDate) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/tasks'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'title': title,
        'description': description,
        'due_date': dueDate,
      }),
    );

    if (response.statusCode == 201) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create task');
    }
  }

  Future<Task> updateTask(int id, String title, String? description, String? dueDate) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/tasks/$id'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'title': title,
        'description': description,
        'due_date': dueDate,
      }),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/tasks/$id'), headers: await _getHeaders());
    if (response.statusCode != 204) {
      throw Exception('Failed to delete task');
    }
  }
}