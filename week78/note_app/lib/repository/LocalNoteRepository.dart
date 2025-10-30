import 'package:note_app/model/Note.dart';
import 'package:note_app/repository/INoteRepository.dart';

class LocalNoteRepository implements INoteRepository {
  final List<Note> _notes = [];

  @override
  List<Note> getAllNotes() {
    final sorted = List<Note>.from(_notes);
    sorted.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sorted;
  }

  @override
  Note? getNoteById(String id) {
    try {
      return _notes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Note createNote(Note note) {
    _notes.add(note);
    return note;
  }

  @override
  Note? updateNote(Note note) {
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      return note;
    }
    return null;
  }

  @override
  bool deleteNote(String id) {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes.removeAt(index);
      return true;
    }
    return false;
  }

  @override
  List<Note> searchNotes(String query) {
    if (query.isEmpty) return getAllNotes();

    final lowerQuery = query.toLowerCase();
    return _notes.where((note) =>
    note.title.toLowerCase().contains(lowerQuery) ||
        note.content.toLowerCase().contains(lowerQuery)
    ).toList();
  }
}

// ===== DOMAIN LAYER - USE CASES =====
// SOLID - Single Responsibility Principle
class CreateNoteUseCase {
  final INoteRepository repository;

  CreateNoteUseCase(this.repository);

  Note execute(String title, String content) {
    final now = DateTime.now();
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
    );
    return repository.createNote(note);
  }
}