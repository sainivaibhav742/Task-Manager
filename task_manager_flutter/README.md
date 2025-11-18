# Task Manager Flutter App

A cross-platform Flutter application for task management that connects to the TaskManagerAPI backend.

## Features

- 📱 Cross-platform support (iOS, Android, Web)
- ✅ Task CRUD operations (Create, Read, Update, Delete)
- 📊 Task statistics and overview
- 🔄 Real-time task status updates
- 🌐 RESTful API integration
- 🌙 Dark/Light theme toggle

## App Overview

This Flutter app provides a complete task management solution with the following screens:

- **Task List Screen**: Main screen displaying all tasks with filtering and search capabilities
- **Add Task Screen**: Form to create new tasks with title, description, category, priority, and due date
- **Edit Task Screen**: Modify existing tasks
- **Statistics Screen**: Overview of task completion status and analytics

## Architecture

The app follows a clean architecture pattern:

- **Models**: Data structures (Task model)
- **Services**: API communication layer (ApiService)
- **Screens**: UI components for different app sections
- **Main**: App entry point with theme management

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.9.2 or higher)
- [Dart SDK](https://dart.dev/get-dart) (included with Flutter)

### Installation

1. Navigate to the Flutter app directory:
   ```bash
   cd task_manager_flutter
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Ensure the backend API is running (see root README.md)

### Running the App

#### For Android/iOS:
```bash
flutter run
```

#### For Web:
```bash
flutter run -d chrome
```

#### For specific device:
```bash
flutter devices  # List available devices
flutter run -d <device-id>
```

## Project Structure

```
lib/
├── main.dart              # App entry point
├── models/
│   └── task.dart          # Task data model
├── screens/
│   ├── task_list_screen.dart    # Main task list
│   ├── add_task_screen.dart     # Add new task
│   ├── edit_task_screen.dart    # Edit existing task
│   └── statistics_screen.dart   # Task statistics
└── services/
    └── api_service.dart   # API communication
```

## Dependencies

- **http**: ^1.5.0 - HTTP client for API calls
- **flutter/material.dart**: Built-in Material Design widgets

## API Integration

The app communicates with the TaskManagerAPI backend through the `ApiService` class. Make sure the API is running on the configured base URL (default: `http://localhost:5187/api/tasks`).

### API Endpoints Used:
- `GET /api/tasks` - Fetch all tasks
- `GET /api/tasks/{id}` - Fetch single task
- `POST /api/tasks` - Create new task
- `PUT /api/tasks/{id}` - Update existing task
- `DELETE /api/tasks/{id}` - Delete task

### Task Model Fields:
- `id`: Unique identifier
- `title`: Task title (required)
- `description`: Task description (required)
- `isCompleted`: Completion status
- `createdAt`: Creation timestamp
- `category`: Optional category
- `dueDate`: Optional due date
- `priority`: Optional priority level

## Deployment

### Prerequisites for Deployment

Before deploying the Flutter app, ensure you have:

1. **Flutter SDK**: Version 3.9.2 or higher
2. **Android Studio**: For Android builds (with Android SDK)
3. **Xcode**: For iOS builds (macOS only)
4. **Backend API**: TaskManagerAPI running and accessible
5. **Signing Keys**: For production Android builds

### Android Deployment

#### Build APK:
```bash
cd task_manager_flutter
flutter build apk --release
```
The APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

#### Build AAB (for Google Play):
```bash
flutter build appbundle --release
```
The AAB will be generated at: `build/app/outputs/bundle/release/app-release.aab`

#### Signing Configuration:
For production builds, configure signing in `android/app/build.gradle.kts`:
```kotlin
android {
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
    signingConfigs {
        create("release") {
            storeFile = file('path/to/keystore.jks')
            storePassword = 'store_password'
            keyAlias = 'key_alias'
            keyPassword = 'key_password'
        }
    }
}
```

### iOS Deployment (macOS only)

#### Build IPA:
```bash
flutter build ios --release
```
Then open Xcode and archive the project for App Store submission.

### Web Deployment

#### Build for Web:
```bash
flutter build web --release
```
Deploy the `build/web` folder to your web server.

### Environment Configuration

Update the API base URL in `lib/services/api_service.dart` for production:
```dart
static const String baseUrl = 'https://your-production-api.com/api/tasks';
```

## Testing

Run tests:
```bash
flutter test
```

## Contributing

1. Follow Flutter best practices
2. Test on multiple platforms
3. Ensure API compatibility

## Troubleshooting

### Common Issues

- **Build issues**: Run `flutter clean` and `flutter pub get`
- **Platform-specific issues**: Check Flutter documentation
- **API connection issues**: Verify backend is running and accessible
- **Android build fails**: Ensure Android SDK is properly configured
- **iOS build fails**: Ensure Xcode and iOS Simulator are set up
- **Web build issues**: Check browser compatibility

### Performance Tips

- Use `flutter build apk --split-per-abi` for smaller APK sizes
- Enable code splitting for web builds
- Optimize images and assets
- Use `flutter analyze` to check for performance issues

### Security Considerations

- Store API keys securely (use environment variables)
- Implement proper error handling for API calls
- Use HTTPS for production API endpoints
- Consider adding authentication if required

### Support

For issues or questions:
1. Check the Flutter documentation: https://flutter.dev/docs
2. Review the TaskManagerAPI documentation
3. Ensure all dependencies are up to date
