import 'package:note_app/repository/INoteRepository.dart';

class DeleteNoteUseCase {
  final INoteRepository repository;

  DeleteNoteUseCase(this.repository);

  bool execute(String id) {
    return repository.deleteNote(id);
  }
}