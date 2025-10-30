import 'package:photo_gallery_app/model/Photo.dart';
import 'package:photo_gallery_app/model/PhotoSource.dart';
import 'package:photo_gallery_app/repository/FileStorageService.dart';
import 'package:photo_gallery_app/repository/ImageService.dart';
import 'package:photo_gallery_app/repository/PhotoRepository.dart';

class TakePhotoUseCase {
  final ImageService imageService;
  final FileStorageService fileStorageService;
  final PhotoRepository photoRepository;

  TakePhotoUseCase({
    required this.imageService,
    required this.fileStorageService,
    required this.photoRepository,
  });

  Future<Photo?> call() async {
    final hasPermission = await imageService.requestCameraPermission();
    if (!hasPermission) return null;

    final imagePath = await imageService.pickImageFromCamera();
    if (imagePath == null) return null;

    final savedPath = await fileStorageService.saveImageToLocal(imagePath);
    return await photoRepository.savePhoto(savedPath, PhotoSource.camera);
  }
}