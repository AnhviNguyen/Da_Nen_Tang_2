import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../core/repositories/auth_repository_interface.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';

/// Auth Wrapper that handles navigation based on auth state
/// Uses StreamBuilder to reactively respond to auth changes
class AuthWrapper extends StatelessWidget {
  final AuthService authService;
  final AuthRepositoryInterface authRepository;

  const AuthWrapper({
    super.key,
    required this.authService,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authRepository.authStateChanges,
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // Show home if user is authenticated
        if (snapshot.hasData && snapshot.data != null) {
          return HomeScreen(authService: authService);
        }
        
        // Show login if user is not authenticated
        return LoginScreen(authService: authService);
      },
    );
  }
}

