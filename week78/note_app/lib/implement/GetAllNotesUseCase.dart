import 'package:note_app/model/Note.dart';
import 'package:note_app/repository/INoteRepository.dart';

class GetAllNotesUseCase {
  final INoteRepository repository;

  GetAllNotesUseCase(this.repository);

  List<Note> execute() {
    return repository.getAllNotes();
  }
}