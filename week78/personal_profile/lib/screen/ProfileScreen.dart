import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_profile/implement/ProfileRepositoryImpl.dart';
import 'package:personal_profile/model/UserProfile.dart';
import 'package:personal_profile/repository/ProfileRepository.dart';
import 'package:personal_profile/screen/ProfileContent.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileRepository _repository;
  late final UserProfile _profile;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _repository = ProfileRepositoryImpl();
    _profile = _repository.getUserProfile();
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: _toggleTheme,
              tooltip: 'Toggle Theme',
            ),
          ],
        ),
        body: ProfileContent(profile: _profile),
      ),
    );
  }
}