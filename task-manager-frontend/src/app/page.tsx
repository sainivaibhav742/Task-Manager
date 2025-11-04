'use client';

import { useState, useEffect } from 'react';
import { Task } from '@/types/task';
import { api } from '@/services/api';
import TaskList from '@/components/TaskList';
import AddTaskForm from '@/components/AddTaskForm';

export default function Home() {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    loadTasks();
  }, []);

  const loadTasks = async () => {
    try {
      setLoading(true);
      const fetchedTasks = await api.getTasks();
      setTasks(fetchedTasks);
      setError(null);
    } catch (err) {
      setError('Failed to load tasks');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleTaskAdded = (newTask: Task) => {
    setTasks(prevTasks => [...prevTasks, newTask]);
  };

  const handleTasksChange = (updatedTasks: Task[]) => {
    setTasks(updatedTasks);
  };

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-2">Task Manager</h1>
          <p className="text-lg text-gray-600">Manage your tasks efficiently</p>
        </div>

        {error && (
          <div className="bg-red-50 border border-red-200 rounded-md p-4 mb-6">
            <p className="text-red-800">{error}</p>
            <button
              onClick={loadTasks}
              className="mt-2 px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700"
            >
              Retry
            </button>
          </div>
        )}

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          <div>
            <AddTaskForm onTaskAdded={handleTaskAdded} />
          </div>

          <div>
            <div className="bg-white border border-gray-200 rounded-lg p-6 shadow-sm">
              <h2 className="text-xl font-semibold text-gray-900 mb-4">Your Tasks</h2>
              {loading ? (
                <div className="flex justify-center items-center py-8">
                  <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
                </div>
              ) : (
                <TaskList tasks={tasks} onTasksChange={handleTasksChange} />
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
