# Task Manager Flutter App

A cross-platform Flutter application for task management that connects to the TaskManagerAPI backend.

## Features

- 📱 Cross-platform support (iOS, Android, Web)
- ✅ Task CRUD operations (Create, Read, Update, Delete)
- 📊 Task statistics and overview
- 🔄 Real-time task status updates
- 🌐 RESTful API integration

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

The app communicates with the TaskManagerAPI backend through the `ApiService` class. Make sure the API is running on the configured base URL (default: `http://localhost:5000`).

## Building for Production

### Android APK:
```bash
flutter build apk --release
```

### iOS (on macOS):
```bash
flutter build ios --release
```

### Web:
```bash
flutter build web --release
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

- **Build issues**: Run `flutter clean` and `flutter pub get`
- **Platform-specific issues**: Check Flutter documentation
- **API connection issues**: Verify backend is running and accessible
