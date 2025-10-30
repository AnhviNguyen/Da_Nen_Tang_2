import 'package:hive/hive.dart';
import 'package:photo_gallery_app/model/Photo.dart';
import 'package:photo_gallery_app/model/PhotoSource.dart';

class PhotoAdapter extends TypeAdapter<Photo> {
  @override
  final int typeId = 0;

  @override
  Photo read(BinaryReader reader) {
    return Photo(
      id: reader.readString(),
      filePath: reader.readString(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      title: reader.readString(),
      source: PhotoSource.values[reader.readInt()],
    );
  }

  @override
  void write(BinaryWriter writer, Photo obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.filePath);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
    writer.writeString(obj.title ?? '');
    writer.writeInt(obj.source.index);
  }
}