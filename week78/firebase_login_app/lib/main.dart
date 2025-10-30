import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/services/auth_service.dart';
import 'core/repositories/auth_repository.dart';
import 'presentation/widgets/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthRepository authRepository;
  late final AuthService authService;

  @override
  void initState() {
    super.initState();
    // Create instances once
    authRepository = AuthRepository();
    authService = AuthService(authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide AuthRepository
        Provider<AuthRepository>.value(value: authRepository),
        // Provide AuthService using ChangeNotifierProvider
        ChangeNotifierProvider<AuthService>.value(value: authService),
      ],
      child: MaterialApp(
        title: 'Firebase Login App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
          useMaterial3: true,
        ),
        home: Consumer2<AuthService, AuthRepository>(
          builder: (context, authService, authRepository, _) {
            return AuthWrapper(
              authService: authService,
              authRepository: authRepository,
            );
          },
        ),
      ),
    );
  }
}
