import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final ApiService apiService = ApiService();
  DateTime? _selectedDueDate;
  String? _selectedPriority;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'What needs to be done?',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Add more details...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category (optional)',
                  hintText: 'Work, Personal, Shopping...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDueDate = picked;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Due Date', style: TextStyle(fontWeight: FontWeight.w500)),
                            Text(
                              _selectedDueDate == null
                                  ? 'Tap to select due date'
                                  : '${_selectedDueDate!.toLocal()}'.split(' ')[0],
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      if (_selectedDueDate != null)
                        IconButton(
                          icon: Icon(Icons.clear, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _selectedDueDate = null;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.priority_high),
                ),
                items: ['Low', 'Medium', 'High']
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Row(
                            children: [
                              Icon(
                                priority == 'High' ? Icons.arrow_upward :
                                priority == 'Medium' ? Icons.remove : Icons.arrow_downward,
                                color: priority == 'High' ? Colors.red :
                                       priority == 'Medium' ? Colors.orange : Colors.green,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(priority),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value;
                  });
                },
              ),
              SizedBox(height: 24),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Task newTask = Task(
                        id: DateTime.now().millisecondsSinceEpoch, // Use timestamp as temporary ID
                        title: _titleController.text.trim(),
                        description: _descriptionController.text.trim(),
                        isCompleted: false,
                        createdAt: DateTime.now(),
                        category: _categoryController.text.trim().isEmpty ? null : _categoryController.text.trim(),
                        dueDate: _selectedDueDate,
                        priority: _selectedPriority,
                      );

                      // Immediately return the task for instant UI update
                      Navigator.pop(context, newTask);

                      // Try to sync with backend in background (won't affect UI)
                      try {
                        await apiService.createTask(newTask);
                      } catch (e) {
                        // Silent fail - task is already in UI
                        print('Background sync failed: $e');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Add Task',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}