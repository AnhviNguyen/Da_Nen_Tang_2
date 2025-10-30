import 'package:note_app/model/Note.dart';
import 'package:note_app/repository/INoteRepository.dart';

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