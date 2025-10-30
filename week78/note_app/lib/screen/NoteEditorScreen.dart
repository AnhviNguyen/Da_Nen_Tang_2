import 'package:flutter/cupertino.dart';
import 'package:note_app/model/Note.dart';
import 'package:note_app/screen/NoteEditorScreenState.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({Key? key, this.note}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => NoteEditorScreenState();
}