import 'package:hive/hive.dart';
import 'package:photo_gallery_app/model/PhotoSource.dart';

@HiveType(typeId: 0)
class Photo extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String filePath;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  String? title;

  @HiveField(4)
  PhotoSource source;

  Photo({
    required this.id,
    required this.filePath,
    required this.createdAt,
    this.title,
    required this.source,
  });
}