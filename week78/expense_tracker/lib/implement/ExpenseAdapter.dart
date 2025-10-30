import 'package:expense_tracker/model/Category.dart';
import 'package:expense_tracker/model/Expense.dart';
import 'package:hive/hive.dart';

class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final int typeId = 0;

  @override
  Expense read(BinaryReader reader) {
    return Expense(
      id: reader.readString(),
      title: reader.readString(),
      amount: reader.readDouble(),
      category: Category.values[reader.readInt()],
      date: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      note: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeDouble(obj.amount);
    writer.writeInt(obj.category.index);
    writer.writeInt(obj.date.millisecondsSinceEpoch);
    writer.writeString(obj.note ?? '');
  }
}
