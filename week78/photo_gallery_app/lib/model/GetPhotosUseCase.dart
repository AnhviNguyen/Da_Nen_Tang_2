import 'package:flutter/cupertino.dart';
import 'package:photo_gallery_app/model/Photo.dart';
import 'package:photo_gallery_app/repository/PhotoRepository.dart';

class GetPhotosUseCase {
  final PhotoRepository photoRepository;

  GetPhotosUseCase(this.photoRepository);

  Future<List<Photo>> call() => photoRepository.getAllPhotos();
}
