# 🔐 Firebase Login App

A Flutter application implementing Firebase Authentication with email and password login/registration. Built following SOLID principles with clean architecture.

## ✨ Features

- 📧 Email/Password Authentication
- 🔑 User Registration & Login
- 👤 Display User Information
- 🔄 Real-time Auth State Management using StreamBuilder
- 🎨 Modern Material Design 3 UI
- 🏗️ Clean Architecture with SOLID Principles

## 🏗️ Architecture

This project follows **SOLID principles** with a clean architecture:

### Project Structure

```
lib/
├── core/
│   ├── models/
│   │   └── user_model.dart           # User data model
│   ├── repositories/
│   │   ├── auth_repository_interface.dart  # Interface (ISP)
│   │   └── auth_repository.dart            # Implementation (SRP)
│   ├── services/
│   │   └── auth_service.dart         # Business logic (SRP, DIP)
│   └── utils/
│       └── validators.dart           # Form validation
└── presentation/
    ├── screens/
    │   ├── login_screen.dart         # Login UI
    │   ├── register_screen.dart      # Registration UI
    │   └── home_screen.dart          # Home UI with user info
    └── widgets/
        └── auth_wrapper.dart         # StreamBuilder auth wrapper
```

### SOLID Principles Applied

1. **Single Responsibility Principle (SRP)**
   - Each class has one reason to change
   - `AuthRepository`: Handles Firebase auth operations
   - `AuthService`: Manages business logic and state
   - Each screen handles its own UI logic

2. **Open/Closed Principle (OCP)**
   - `AuthRepositoryInterface` can be extended with new implementations
   - New auth methods can be added without modifying existing code

3. **Liskov Substitution Principle (LSP)**
   - Any implementation of `AuthRepositoryInterface` can replace the base implementation

4. **Interface Segregation Principle (ISP)**
   - `AuthRepositoryInterface` contains only auth-related methods
   - No unnecessary dependencies

5. **Dependency Inversion Principle (DIP)**
   - High-level modules depend on abstractions (`AuthRepositoryInterface`)
   - Dependency injection using Provider pattern

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.5.4)
- Firebase account
- Android Studio / VS Code

### Installation

1. **Clone the repository**

```bash
git clone <repository-url>
cd firebase_login_app
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Firebase Setup**

#### For Android:

Create a Firebase project and download `google-services.json`:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or use existing
3. Add Android app with package name: `com.example.firebase_login_app`
4. Download `google-services.json`
5. Place it in `android/app/`

#### For iOS:

1. Add iOS app in Firebase Console
2. Download `GoogleService-Info.plist`
3. Place it in `ios/Runner/`

#### Enable Authentication:

1. Go to Firebase Console > Authentication
2. Enable "Email/Password" sign-in method

4. **Run the app**

```bash
flutter run
```

## 📱 Usage

1. **Register a New Account**
   - Tap "Đăng ký ngay" on login screen
   - Enter email and password
   - Tap "Đăng Ký"

2. **Login**
   - Enter email and password
   - Tap "Đăng Nhập"

3. **View User Info**
   - After login, see your user details on home screen
   - UID, Email, and Display Name are shown

4. **Sign Out**
   - Tap logout button to sign out

## 🔧 Technologies Used

- **Flutter** - UI Framework
- **Firebase Core** - Firebase initialization
- **Firebase Auth** - Authentication services
- **Provider** - State management & dependency injection

## 📝 Key Features Implementation

### StreamBuilder for Auth State

The app uses `StreamBuilder` to reactively respond to authentication state changes:

```dart
StreamBuilder(
  stream: authRepository.authStateChanges,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return HomeScreen();
    }
    return LoginScreen();
  },
)
```

### Clean Architecture Benefits

- **Testability**: Easy to mock repositories for testing
- **Maintainability**: Clear separation of concerns
- **Scalability**: Easy to add new features
- **Flexibility**: Can swap Firebase with other auth providers

## 🎯 Future Enhancements

- [ ] Password reset functionality
- [ ] Social login (Google, Facebook)
- [ ] User profile editing
- [ ] Remember me option
- [ ] Biometric authentication
- [ ] Email verification

## 📄 License

This project is part of a Flutter learning series.

## 👨‍💻 Author

Built following SOLID principles for clean, maintainable code.

---

**Happy Coding! 🚀**
