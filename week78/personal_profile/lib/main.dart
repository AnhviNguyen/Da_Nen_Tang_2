import 'package:flutter/material.dart';
import 'package:personal_profile/screen/ProfileScreen.dart';

void main() {
  runApp(const PersonalProfileApp());
}

class PersonalProfileApp extends StatelessWidget {
  const PersonalProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: const ProfileScreen(),
    );
  }
}