'use client';

import { useState, useEffect } from 'react';
import { Task } from '@/types/task';
import { api } from '@/services/api';
import EditTaskForm from './EditTaskForm';

interface TaskListProps {
  tasks: Task[];
  onTasksChange: (tasks: Task[]) => void;
}

export default function TaskList({ tasks, onTasksChange }: TaskListProps) {
  const [editingTask, setEditingTask] = useState<Task | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleDelete = async (id: number) => {
    if (!confirm('Are you sure you want to delete this task?')) return;

    try {
      setLoading(true);
      await api.deleteTask(id);
      const updatedTasks = tasks.filter(task => task.id !== id);
      onTasksChange(updatedTasks);
    } catch (err) {
      setError('Failed to delete task');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleTaskUpdated = (updatedTask: Task) => {
    const updatedTasks = tasks.map(task =>
      task.id === updatedTask.id ? updatedTask : task
    );
    onTasksChange(updatedTasks);
    setEditingTask(null);
  };

  if (error) {
    return (
      <div className="bg-red-50 border border-red-200 rounded-md p-4 mb-4">
        <p className="text-red-800">{error}</p>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      {tasks.length === 0 ? (
        <p className="text-gray-500 text-center py-8">No tasks found. Add your first task!</p>
      ) : (
        tasks.map((task) => (
          <div key={task.id}>
            {editingTask?.id === task.id ? (
              <EditTaskForm
                task={editingTask}
                onTaskUpdated={handleTaskUpdated}
                onCancel={() => setEditingTask(null)}
              />
            ) : (
              <div className="bg-white border border-gray-200 rounded-lg p-4 shadow-sm hover:shadow-md transition-shadow">
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <h3 className={`text-lg font-semibold ${task.isCompleted ? 'line-through text-gray-500' : 'text-gray-900'}`}>
                      {task.title}
                    </h3>
                    <p className={`mt-1 ${task.isCompleted ? 'text-gray-400' : 'text-gray-600'}`}>
                      {task.description}
                    </p>
                    <p className="text-sm text-gray-400 mt-2">
                      Created: {new Date(task.createdAt).toLocaleDateString()}
                    </p>
                  </div>
                  <div className="flex items-center space-x-2 ml-4">
                    <span className={`px-2 py-1 text-xs rounded-full ${
                      task.isCompleted
                        ? 'bg-green-100 text-green-800'
                        : 'bg-yellow-100 text-yellow-800'
                    }`}>
                      {task.isCompleted ? 'Completed' : 'Pending'}
                    </span>
                    <button
                      onClick={() => setEditingTask(task)}
                      className="px-3 py-1 text-sm bg-blue-600 text-white rounded-md hover:bg-blue-700"
                    >
                      Edit
                    </button>
                    <button
                      onClick={() => handleDelete(task.id)}
                      disabled={loading}
                      className="px-3 py-1 text-sm bg-red-600 text-white rounded-md hover:bg-red-700 disabled:opacity-50"
                    >
                      Delete
                    </button>
                  </div>
                </div>
              </div>
            )}
          </div>
        ))
      )}
    </div>
  );
}