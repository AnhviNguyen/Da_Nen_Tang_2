import 'package:photo_gallery_app/model/Photo.dart';
import 'package:photo_gallery_app/repository/FileStorageService.dart';
import 'package:photo_gallery_app/repository/PhotoRepository.dart';

class DeletePhotoUseCase {
  final PhotoRepository photoRepository;
  final FileStorageService fileStorageService;

  DeletePhotoUseCase({
    required this.photoRepository,
    required this.fileStorageService,
  });

  Future<void> call(Photo photo) async {
    await fileStorageService.deleteImageFile(photo.filePath);
    await photoRepository.deletePhoto(photo.id);
  }
}