# Flutter Chat App

A real-time chat application built with Flutter and Firebase, featuring user authentication, real-time messaging, and offline caching capabilities using **BLoC pattern** and **Clean Architecture**.

## Features

### Core Features
- ✅ **User Authentication** - Email/Password registration and login
- ✅ **Real-time Messaging** - Send and receive messages instantly
- ✅ **User Management** - View all registered users
- ✅ **Message CRUD Operations** - Create, Read, Update, Delete messages
- ✅ **Offline Caching** - Messages and user data cached locally with Hive
- ✅ **Clean UI/UX** - Modern, responsive chat interface

### Technical Features
- ✅ **BLoC State Management** - Efficient state handling with flutter_bloc
- ✅ **Clean Architecture** - Domain, Data, Presentation layers
- ✅ **Dependency Injection** - GetIt for dependency management
- ✅ **Error Handling** - Graceful error management
- ✅ **Connectivity Monitoring** - Internet connection status
- ✅ **Pull-to-Refresh** - Refresh data functionality
- ✅ **Local Caching** - Hive database for offline support

## Architecture

The app follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/
│   ├── constants/       # App constants (colors, strings)
│   ├── connectivity/    # Connectivity BLoC and service
│   ├── di/              # Dependency injection setup
│   └── routes/          # App routing configuration
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasource/ # Local and remote data sources
│   │   │   ├── models/     # Data models
│   │   │   └── repository/ # Repository implementation
│   │   ├── domain/
│   │   │   ├── entities/   # Business entities
│   │   │   ├── repository/ # Repository contracts
│   │   │   └── usecase/    # Business use cases
│   │   └── presentation/
│   │       ├── bloc/       # BLoC state management
│   │       ├── screens/    # UI screens
│   │       └── widgets/    # Reusable widgets
│   ├── chat/
│   │   └── [same structure as auth]
│   └── users/
│       └── [same structure as auth]
├── widgets/             # Global widgets
└── main.dart
```

## State Management

The app uses **BLoC pattern** for state management with the following BLoCs:

- **AuthBloc** - Manages authentication state (login, register, logout)
- **ChatBloc** - Handles real-time messaging operations
- **UsersBloc** - Manages users list and last messages
- **ConnectivityBloc** - Monitors network connectivity

## Setup Instructions

### Prerequisites
- Flutter SDK (>=3.0.0)
- Firebase project with the following services enabled:
    - Authentication (Email/Password)
    - Cloud Firestore
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repositories-url>
   cd flutter_chat_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
    - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com)
    - Enable Authentication with Email/Password provider
    - Enable Cloud Firestore database
    - Download and add configuration files:
        - Android: `google-services.json` → `android/app/`
        - iOS: `GoogleService-Info.plist` → `ios/Runner/`

4. **Generate Hive Adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

5. **Firestore Security Rules**
   Add the following rules to your Firestore:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       // Users collection
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
         allow read: if request.auth != null;
       }
       
       // Chats collection
       match /chats/{chatId}/messages/{messageId} {
         allow read, write: if request.auth != null && 
           (request.auth.uid == resource.data.senderId || 
            request.auth.uid == resource.data.receiverId);
       }
     }
   }
   ```

6. **Run the app**
   ```bash
   flutter run
   ```

## BLoC Implementation Details

### AuthBloc Events & States
```dart
// Events
- LoginSubmitted
- RegisterSubmitted  
- LogoutSubmitted
- CheckAuthStatus

// States
- AuthInitial
- AuthLoading
- Authenticated
- Unauthenticated
- AuthFailure
```

### ChatBloc Events & States
```dart
// Events
- LoadMessages
- SendMessage
- UpdateMessage
- DeleteMessage
- RefreshMessages

// States
- ChatInitial
- ChatLoading
- ChatLoaded
- MessageSending
- ChatError
```

### UsersBloc Events & States
```dart
// Events
- LoadUsers
- RefreshUsers
- LoadLastMessages

// States
- UsersInitial
- UsersLoading
- UsersLoaded
- UsersError
```

## Caching Strategy

**Hive** is used for local data persistence with different boxes:

- **Users Box** - Stores user list for offline access
- **Messages Box** - Caches messages per chat conversation
- **Cache Box** - Stores metadata like timestamps for cache validity

### Cache Features
- **Data Freshness** - 5-minute expiry for cached data
- **Offline Support** - App works without internet using cached data
- **Smart Caching** - Automatic cache updates when online

## Error Handling

Comprehensive error handling throughout the app:

- **Network Errors** - Graceful fallback to cached data
- **Firebase Errors** - User-friendly error messages
- **Validation Errors** - Form field validation with helpful hints
- **BLoC Error States** - Proper error state management
- **Connectivity Issues** - Visual indicators and retry mechanisms

## Dependency Injection

Using **GetIt** for dependency management:

```dart
// Example registration
sl.registerFactory(() => AuthBloc(
  loginUserUseCase: sl(),
  registerUserUseCase: sl(),
));

sl.registerLazySingleton(() => LoginUserUseCase(sl()));
sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
  remoteDataSource: sl(),
));
```

## Testing

### Running Tests
```bash
# Unit tests
flutter test

# BLoC tests
flutter test test/features/*/presentation/bloc/

# Integration tests  
flutter test integration_test/
```

### Test Coverage
- **Unit Tests** - Repository, UseCase, and BLoC testing
- **Widget Tests** - UI component testing
- **BLoC Tests** - State management testing with bloc_test
- **Integration Tests** - End-to-end flow testing

## Performance Optimizations

- **Efficient Rendering** - ListView.builder for large datasets
- **Stream Management** - Proper subscription cancellation
- **Memory Management** - Disposing controllers and BLoCs
- **Lazy Loading** - On-demand data loading
- **Optimized Rebuilds** - BlocBuilder and BlocConsumer usage

## Key Technologies

- **Flutter** - UI framework
- **Firebase** - Backend services (Auth, Firestore)
- **BLoC** - State management pattern
- **Hive** - Local database for caching
- **GetIt** - Dependency injection
- **Clean Architecture** - Code organization pattern

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Follow Clean Architecture principles
4. Write tests for new features
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## Project Structure Benefits

### Clean Architecture Advantages
- **Testability** - Easy to unit test business logic
- **Maintainability** - Clear separation of concerns
- **Scalability** - Easy to add new features
- **Independence** - UI, business logic, and data are decoupled

### BLoC Pattern Benefits
- **Predictable State** - Unidirectional data flow
- **Testable** - Easy to test state changes
- **Reusable** - BLoCs can be shared across widgets
- **Reactive** - Responds to events and emits states

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue in the GitHub repository.

---

**Built with ❤️ using Flutter, Firebase & BLoC Pattern**