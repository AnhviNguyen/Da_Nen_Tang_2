import 'package:note_app/model/Note.dart';

abstract class INoteRepository {
  List<Note> getAllNotes();
  Note? getNoteById(String id);
  Note createNote(Note note);
  Note? updateNote(Note note);
  bool deleteNote(String id);
  List<Note> searchNotes(String query);
}