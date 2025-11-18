import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {
  // For physical Android devices, use your computer's IP address
  // For development, you can use either localhost (if backend is running on device)
  // or your computer's IP address if backend is running on your PC
  static const String baseUrl = 'http://192.168.1.100:5187/api/tasks'; // Replace with your PC's IP

  Future<List<Task>> getTasks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl)).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      // Return empty list instead of crashing
      return [];
    }
  }

  Future<Task> getTask(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load task');
    }
  }

  Future<Task> createTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': task.title,
          'description': task.description,
          'isCompleted': task.isCompleted,
        }),
      ).timeout(Duration(seconds: 10));
      if (response.statusCode == 201) {
        return Task.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create task: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error creating task: $e');
      // Return a temporary task for offline functionality
      return Task(
        id: DateTime.now().millisecondsSinceEpoch,
        title: task.title,
        description: task.description,
        isCompleted: task.isCompleted,
        createdAt: DateTime.now(),
      );
    }
  }

  Future<Task> updateTask(Task task) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${task.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      ).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        return Task.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error updating task: $e');
      // Return the task as-is for offline functionality
      return task;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id')).timeout(Duration(seconds: 10));
      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete task: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error deleting task: $e');
      // Don't throw error for offline functionality
    }
  }
}