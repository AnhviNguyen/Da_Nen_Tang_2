import 'package:note_app/model/Note.dart';
import 'package:note_app/repository/INoteRepository.dart';

class UpdateNoteUseCase {
  final INoteRepository repository;

  UpdateNoteUseCase(this.repository);

  Note? execute(String id, String title, String content) {
    final existingNote = repository.getNoteById(id);
    if (existingNote == null) return null;

    final updatedNote = existingNote.copyWith(
      title: title,
      content: content,
      updatedAt: DateTime.now(),
    );
    return repository.updateNote(updatedNote);
  }
}