import { Task } from '@/types/task';

const API_BASE_URL = 'http://localhost:5187/api/tasks';

export const api = {
  async getTasks(): Promise<Task[]> {
    const response = await fetch(API_BASE_URL);
    if (!response.ok) {
      throw new Error('Failed to fetch tasks');
    }
    return response.json();
  },

  async createTask(task: Omit<Task, 'id' | 'createdAt'>): Promise<Task> {
    const response = await fetch(API_BASE_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(task),
    });
    if (!response.ok) {
      throw new Error('Failed to create task');
    }
    return response.json();
  },

  async updateTask(id: number, task: Omit<Task, 'id' | 'createdAt'>): Promise<Task> {
    const response = await fetch(`${API_BASE_URL}/${id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ id, ...task }),
    });
    if (!response.ok) {
      throw new Error('Failed to update task');
    }
    return response.json();
  },

  async deleteTask(id: number): Promise<void> {
    const response = await fetch(`${API_BASE_URL}/${id}`, {
      method: 'DELETE',
    });
    if (!response.ok) {
      throw new Error('Failed to delete task');
    }
  },
};