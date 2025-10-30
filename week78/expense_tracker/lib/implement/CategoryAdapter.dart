
import 'package:expense_tracker/model/Category.dart';
import 'package:hive/hive.dart';

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 1;

  @override
  Category read(BinaryReader reader) {
    return Category.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer.writeInt(obj.index);
  }
}