import 'package:photo_gallery_app/model/Photo.dart';
import 'package:photo_gallery_app/model/PhotoSource.dart';

abstract class PhotoRepository {
  Future<List<Photo>> getAllPhotos();
  Future<Photo> savePhoto(String filePath, PhotoSource source, {String? title});
  Future<void> deletePhoto(String id);
  Future<void> updatePhotoTitle(String id, String title);
  Stream<List<Photo>> watchPhotos();
}