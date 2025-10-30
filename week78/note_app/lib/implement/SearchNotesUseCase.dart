import 'package:note_app/model/Note.dart';
import 'package:note_app/repository/INoteRepository.dart';

class SearchNotesUseCase {
  final INoteRepository repository;

  SearchNotesUseCase(this.repository);

  List<Note> execute(String query) {
    return repository.searchNotes(query);
  }
}