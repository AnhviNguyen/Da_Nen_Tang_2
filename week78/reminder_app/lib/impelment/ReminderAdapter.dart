

import 'package:hive/hive.dart';
import 'package:reminder_app/model/Reminder.dart';

class ReminderAdapter extends TypeAdapter<Reminder> {
  @override
  final int typeId = 0; // ID duy nhất

  @override
  Reminder read(BinaryReader reader) {
    final id = reader.readString();
    final title = reader.readString();
    final description = reader.readString();
    final scheduledTime = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final isCompleted = reader.readBool();
    final category = reader.readString();
    final notificationId = reader.readInt();

    return Reminder(
      id: id,
      title: title,
      description: description.isEmpty ? null : description,
      scheduledTime: scheduledTime,
      isCompleted: isCompleted,
      category: category.isEmpty ? null : category,
      notificationId: notificationId,
    );
  }

  @override
  void write(BinaryWriter writer, Reminder obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.description ?? '');
    writer.writeInt(obj.scheduledTime.millisecondsSinceEpoch);
    writer.writeBool(obj.isCompleted);
    writer.writeString(obj.category ?? '');
    writer.writeInt(obj.notificationId);
  }
}