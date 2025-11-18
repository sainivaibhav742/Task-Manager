import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Task>> futureTasks;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    setState(() {
      futureTasks = apiService.getTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Statistics'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadTasks,
            tooltip: 'Refresh Statistics',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadTasks();
        },
        child: FutureBuilder<List<Task>>(
          future: futureTasks,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Task> tasks = snapshot.data!;
              int totalTasks = tasks.length;
              int completedTasks = tasks.where((task) => task.isCompleted).length;
              int pendingTasks = totalTasks - completedTasks;
              int highPriorityTasks = tasks.where((task) => task.priority == 'High').length;
              int mediumPriorityTasks = tasks.where((task) => task.priority == 'Medium').length;
              int lowPriorityTasks = tasks.where((task) => task.priority == 'Low').length;

              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with total count
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.blueAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.analytics, size: 48, color: Colors.white),
                          SizedBox(height: 8),
                          Text(
                            '$totalTasks',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Total Tasks',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Overview Cards
                    Text('Overview', style: Theme.of(context).textTheme.headlineSmall),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Completed',
                            '$completedTasks',
                            Icons.check_circle,
                            Colors.green,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Pending',
                            '$pendingTasks',
                            Icons.pending,
                            Colors.orange,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    // Priority Breakdown
                    Text('Priority Breakdown', style: Theme.of(context).textTheme.headlineSmall),
                    SizedBox(height: 16),
                    _buildPriorityChart(highPriorityTasks, mediumPriorityTasks, lowPriorityTasks),

                    SizedBox(height: 24),

                    // Completion Rate
                    Text('Completion Rate', style: Theme.of(context).textTheme.headlineSmall),
                    SizedBox(height: 16),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Container(
                              height: 20,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: totalTasks > 0 ? completedTasks / totalTasks : 0,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '${totalTasks > 0 ? ((completedTasks / totalTasks) * 100).round() : 0}% completed',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Empty state
                    if (totalTasks == 0) ...[
                      SizedBox(height: 40),
                      Center(
                        child: Column(
                          children: [
                            Icon(Icons.bar_chart, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No tasks yet',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Add some tasks to see statistics',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text('Failed to load statistics', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 8),
                    Text('${snapshot.error}', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadTasks,
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
                  Text('Loading statistics...'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChart(int high, int medium, int low) {
    int total = high + medium + low;
    if (total == 0) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              'No priority data available',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildPriorityBar('High', high, total, Colors.red),
            SizedBox(height: 12),
            _buildPriorityBar('Medium', medium, total, Colors.orange),
            SizedBox(height: 12),
            _buildPriorityBar('Low', low, total, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityBar(String label, int count, int total, Color color) {
    double percentage = total > 0 ? count / total : 0;
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
                  Text('$count', style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
              SizedBox(height: 4),
              Container(
                height: 8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}