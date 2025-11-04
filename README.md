# Task Manager

A comprehensive task management system with multiple frontend implementations and a unified backend API.

## Project Structure

This repository contains a full-stack task management application with the following components:

- **TaskManagerAPI** - ASP.NET Core Web API backend
- **task-manager-frontend** - Next.js React frontend
- **task_manager_flutter** - Flutter mobile app

## Features

- ✅ Create, read, update, and delete tasks
- ✅ Task status management (pending, in progress, completed)
- ✅ Cross-platform support (Web, Mobile)
- ✅ RESTful API with Swagger documentation
- ✅ CORS enabled for frontend integration
- ✅ In-memory database for development

## Technology Stack

### Backend (TaskManagerAPI)
- **Framework**: ASP.NET Core 8.0
- **Language**: C#
- **Database**: Entity Framework Core (In-Memory)
- **API**: RESTful with Controllers
- **Documentation**: Swagger/OpenAPI
- **CORS**: Enabled for frontend integration

### Frontend (task-manager-frontend)
- **Framework**: Next.js 16.0
- **Language**: TypeScript
- **UI**: React 19
- **Styling**: Tailwind CSS
- **State Management**: React Hooks

### Mobile App (task_manager_flutter)
- **Framework**: Flutter
- **Language**: Dart
- **Platform**: Cross-platform (iOS, Android, Web)
- **HTTP Client**: http package

## Getting Started

### Prerequisites

- [.NET 8.0 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- [Node.js](https://nodejs.org/) (for Next.js frontend)
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (for Flutter app)

### Backend Setup

1. Navigate to the TaskManagerAPI directory:
   ```bash
   cd TaskManagerAPI
   ```

2. Restore dependencies:
   ```bash
   dotnet restore
   ```

3. Run the API:
   ```bash
   dotnet run
   ```

The API will be available at `https://localhost:5001` with Swagger UI at `https://localhost:5001/swagger`.

### Frontend Setup (Next.js)

1. Navigate to the frontend directory:
   ```bash
   cd task-manager-frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Run the development server:
   ```bash
   npm run dev
   ```

Open [http://localhost:3000](http://localhost:3000) in your browser.

### Mobile App Setup (Flutter)

1. Navigate to the Flutter app directory:
   ```bash
   cd task_manager_flutter
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

For web deployment:
```bash
flutter run -d chrome
```

## API Endpoints

The API provides the following endpoints:

- `GET /api/tasks` - Get all tasks
- `GET /api/tasks/{id}` - Get task by ID
- `POST /api/tasks` - Create new task
- `PUT /api/tasks/{id}` - Update task
- `DELETE /api/tasks/{id}` - Delete task

### Task Model

```json
{
  "id": "int",
  "title": "string",
  "description": "string",
  "isCompleted": "boolean",
  "createdAt": "datetime",
  "updatedAt": "datetime"
}
```

## Development

### Running All Services

You can run all components simultaneously:

1. **Terminal 1** - Backend API:
   ```bash
   cd TaskManagerAPI && dotnet run
   ```

2. **Terminal 2** - Next.js Frontend:
   ```bash
   cd task-manager-frontend && npm run dev
   ```

3. **Terminal 3** - Flutter App:
   ```bash
   cd task_manager_flutter && flutter run -d chrome
   ```

### Building for Production

#### Backend
```bash
cd TaskManagerAPI
dotnet publish -c Release
```

#### Frontend
```bash
cd task-manager-frontend
npm run build
npm start
```

#### Flutter
```bash
cd task_manager_flutter
flutter build apk  # For Android
flutter build ios  # For iOS
flutter build web  # For Web
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions or issues, please open an issue on GitHub.