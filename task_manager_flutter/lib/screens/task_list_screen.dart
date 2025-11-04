import 'package:flutter/material.dart';
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
  late Future<List<Task>> futureTasks;
  List<Task> allTasks = [];
  List<Task> filteredTasks = [];
  String searchQuery = '';
  SortOption sortOption = SortOption.date;

  @override
  void initState() {
    super.initState();
    futureTasks = apiService.getTasks();
  }

  void _refreshTasks() {
    setState(() {
      futureTasks = apiService.getTasks();
    });
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
        child: FutureBuilder<List<Task>>(
          future: futureTasks,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              allTasks = snapshot.data!;
              List<Task> tasksToDisplay = searchQuery.isEmpty ? allTasks : filteredTasks;
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
                        await apiService.updateTask(updatedTask);
                        _refreshTasks();
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
                        await apiService.deleteTask(task.id);
                        _refreshTasks();
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
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text('Failed to load tasks', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 8),
                    Text('${snapshot.error}', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshTasks,
                      child: Text('Retry'),
                    ),
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          ).then((_) => _refreshTasks());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}