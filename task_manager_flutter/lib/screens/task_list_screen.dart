import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task.dart';
import '../services/api_service.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';
import 'statistics_screen.dart';

class TaskListScreen extends StatefulWidget {
  final VoidCallback? onThemeToggle;
  final bool? isDarkMode;

  TaskListScreen({this.onThemeToggle, this.isDarkMode});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

enum SortOption { date, completion }

class _TaskListScreenState extends State<TaskListScreen> {
  final ApiService apiService = ApiService();
  Future<List<Task>>? futureTasks;
  List<Task> allTasks = [];
  List<Task> filteredTasks = [];
  String searchQuery = '';
  SortOption sortOption = SortOption.date;

  // Add local storage for tasks
  static const String _tasksKey = 'local_tasks';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      // Try to load from API first
      final apiTasks = await apiService.getTasks();
      setState(() {
        allTasks = apiTasks;
        _applyFiltersAndSort();
      });
      // Save to local storage
      await _saveTasksToLocal(apiTasks);
    } catch (e) {
      // If API fails, load from local storage
      final localTasks = await _loadTasksFromLocal();
      setState(() {
        allTasks = localTasks;
        _applyFiltersAndSort();
      });
    }
  }

  void _refreshTasks() {
    _loadTasks();
  }

  Future<List<Task>> _loadTasksFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getStringList(_tasksKey) ?? [];
      return tasksJson.map((jsonStr) {
        final Map<String, dynamic> json = jsonDecode(jsonStr);
        return Task.fromJson(json);
      }).toList();
    } catch (e) {
      print('Error loading tasks from local storage: $e');
      return [];
    }
  }

  Future<void> _saveTasksToLocal(List<Task> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
      await prefs.setStringList(_tasksKey, tasksJson);
    } catch (e) {
      print('Error saving tasks to local storage: $e');
    }
  }

  Future<void> _addTaskToLocal(Task task) async {
    setState(() {
      allTasks.insert(0, task);
      _applyFiltersAndSort();
    });
    await _saveTasksToLocal(allTasks);
  }

  Future<void> _updateTaskInLocal(Task updatedTask) async {
    setState(() {
      final index = allTasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        allTasks[index] = updatedTask;
        _applyFiltersAndSort();
      }
    });
    await _saveTasksToLocal(allTasks);
  }

  Future<void> _deleteTaskFromLocal(int id) async {
    setState(() {
      allTasks.removeWhere((task) => task.id == id);
      _applyFiltersAndSort();
    });
    await _saveTasksToLocal(allTasks);
  }

  void _filterTasks(String query) {
    setState(() {
      searchQuery = query;
      _applyFiltersAndSort();
    });
  }

  void _sortTasks(SortOption option) {
    setState(() {
      sortOption = option;
      _applyFiltersAndSort();
    });
  }

  void _applyFiltersAndSort() {
    List<Task> tasks = searchQuery.isEmpty ? allTasks : allTasks.where((task) =>
      task.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
      task.description.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();

    switch (sortOption) {
      case SortOption.date:
        tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.completion:
        tasks.sort((a, b) {
          if (a.isCompleted == b.isCompleted) {
            return b.createdAt.compareTo(a.createdAt);
          }
          return a.isCompleted ? 1 : -1;
        });
        break;
    }

    filteredTasks = tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StatisticsScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(widget.isDarkMode ?? false ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onThemeToggle,
          ),
          PopupMenuButton<SortOption>(
            onSelected: _sortTasks,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
              const PopupMenuItem<SortOption>(
                value: SortOption.date,
                child: Text('Sort by Date'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.completion,
                child: Text('Sort by Completion'),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterTasks,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshTasks();
        },
        child: futureTasks != null ? FutureBuilder<List<Task>>(
          future: futureTasks,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              allTasks = snapshot.data!;
              _applyFiltersAndSort(); // Apply filters and sorting
              List<Task> tasksToDisplay = searchQuery.isEmpty ? allTasks : filteredTasks;
              if (tasksToDisplay.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.task_alt, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No tasks yet', style: TextStyle(fontSize: 20, color: Colors.grey)),
                      SizedBox(height: 8),
                      Text('Tap the + button to add your first task', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: tasksToDisplay.length,
                itemBuilder: (context, index) {
                  Task task = tasksToDisplay[index];
                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(child: Text(task.title)),
                        if (task.priority != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: task.priority == 'High'
                                  ? Colors.red
                                  : task.priority == 'Medium'
                                      ? Colors.orange
                                      : Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              task.priority!,
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.description),
                        if (task.category != null)
                          Text('Category: ${task.category}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        if (task.dueDate != null)
                          Text('Due: ${task.dueDate!.toLocal()}'.split(' ')[0], style: TextStyle(fontSize: 12, color: Colors.blue)),
                      ],
                    ),
                    trailing: Checkbox(
                      value: task.isCompleted,
                      onChanged: (bool? value) async {
                          Task updatedTask = Task(
                            id: task.id,
                            title: task.title,
                            description: task.description,
                            isCompleted: value ?? false,
                            createdAt: task.createdAt,
                            category: task.category,
                            dueDate: task.dueDate,
                            priority: task.priority,
                          );
                          await _updateTaskInLocal(updatedTask);
                          // Try to sync with API in background
                          try {
                            await apiService.updateTask(updatedTask);
                          } catch (e) {
                            print('Background sync failed: $e');
                          }
                        },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTaskScreen(task: task),
                        ),
                      ).then((_) => _refreshTasks());
                    },
                    onLongPress: () async {
                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete Task'),
                            content: Text('Are you sure you want to delete "${task.title}"?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () => Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: Text('Delete'),
                                onPressed: () => Navigator.of(context).pop(true),
                              ),
                            ],
                          );
                        },
                      );
                      if (confirm == true) {
                        await _deleteTaskFromLocal(task.id);
                        // Try to sync with API in background
                        try {
                          await apiService.deleteTask(task.id);
                        } catch (e) {
                          print('Background sync failed: $e');
                        }
                      }
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, size: 64, color: Colors.orange),
                    SizedBox(height: 16),
                    Text('Backend Not Connected', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 8),
                    Text('Start your TaskManagerAPI backend to sync tasks', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshTasks,
                      child: Text('Retry Connection'),
                    ),
                    SizedBox(height: 8),
                    Text('App works offline - you can still add tasks locally', style: TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
                  ],
                ),
              );
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading tasks...'),
                ],
              ),
            );
          },
        ) : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.task_alt, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text('Welcome to Task Manager', style: TextStyle(fontSize: 20, color: Colors.grey)),
              SizedBox(height: 8),
              Text('Tap the + button to add your first task', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
          if (result != null && result is Task) {
            // Add the new task to the local list immediately
            await _addTaskToLocal(result);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}