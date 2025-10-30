import 'package:flutter/cupertino.dart';
import 'package:note_app/implement/CreateNoteUseCase.dart';
import 'package:note_app/implement/DeleteNoteUseCase.dart';
import 'package:note_app/implement/GetAllNotesUseCase.dart';
import 'package:note_app/implement/SearchNotesUseCase.dart';
import 'package:note_app/implement/UpdateNoteUseCase.dart';
import 'package:note_app/model/Note.dart';
import 'package:note_app/repository/INoteRepository.dart';

class NoteProvider extends ChangeNotifier {
  final INoteRepository _repository;
  late final CreateNoteUseCase _createNoteUseCase;
  late final UpdateNoteUseCase _updateNoteUseCase;
  late final DeleteNoteUseCase _deleteNoteUseCase;
  late final GetAllNotesUseCase _getAllNotesUseCase;
  late final SearchNotesUseCase _searchNotesUseCase;

  List<Note> _notes = [];
  String _searchQuery = '';

  NoteProvider(this._repository) {
    _createNoteUseCase = CreateNoteUseCase(_repository);
    _updateNoteUseCase = UpdateNoteUseCase(_repository);
    _deleteNoteUseCase = DeleteNoteUseCase(_repository);
    _getAllNotesUseCase = GetAllNotesUseCase(_repository);
    _searchNotesUseCase = SearchNotesUseCase(_repository);

    _loadNotes();
  }

  List<Note> get notes => _notes;
  String get searchQuery => _searchQuery;

  void _loadNotes() {
    _notes = _getAllNotesUseCase.execute();
    notifyListeners();
  }

  void createNote(String title, String content) {
    _createNoteUseCase.execute(title, content);
    _loadNotes();
  }

  void updateNote(String id, String title, String content) {
    _updateNoteUseCase.execute(id, title, content);
    _loadNotes();
  }

  void deleteNote(String id) {
    _deleteNoteUseCase.execute(id);
    _loadNotes();
  }

  void searchNotes(String query) {
    _searchQuery = query;
    _notes = _searchNotesUseCase.execute(query);
    notifyListeners();
  }
}