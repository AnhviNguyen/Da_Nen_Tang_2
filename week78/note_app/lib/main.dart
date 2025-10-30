import 'package:flutter/material.dart';
import 'package:note_app/provider/NoteProvider.dart';
import 'package:note_app/repository/LocalNoteRepository.dart';
import 'package:note_app/screen/NotesScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NoteProvider(LocalNoteRepository()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const NotesScreen(),
    );
  }
}