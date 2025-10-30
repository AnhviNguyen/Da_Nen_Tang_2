import 'package:hive_flutter/adapters.dart';
import 'package:photo_gallery_app/model/Photo.dart';
import 'package:photo_gallery_app/model/PhotoSource.dart';
import 'package:photo_gallery_app/repository/PhotoRepository.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  final Box<Photo> _photoBox = Hive.box<Photo>('photos');

  @override
  Future<List<Photo>> getAllPhotos() async {
    return _photoBox.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<Photo> savePhoto(
      String filePath,
      PhotoSource source, {
        String? title,
      }) async {
    final photo = Photo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      filePath: filePath,
      createdAt: DateTime.now(),
      title: title,
      source: source,
    );

    await _photoBox.put(photo.id, photo);
    return photo;
  }

  @override
  Future<void> deletePhoto(String id) async {
    await _photoBox.delete(id);
  }

  @override
  Future<void> updatePhotoTitle(String id, String title) async {
    final photo = _photoBox.get(id);
    if (photo != null) {
      photo.title = title;
      await photo.save();
    }
  }

  @override
  Stream<List<Photo>> watchPhotos() {
    return _photoBox.watch().map((_) {
      return _photoBox.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }
}