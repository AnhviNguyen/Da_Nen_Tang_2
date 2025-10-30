import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/model/Reminder.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/provider/ReminderProvider.dart';

class ReminderCard extends StatelessWidget {
  final Reminder reminder;

  const ReminderCard({Key? key, required this.reminder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOverdue = reminder.isPast && !reminder.isCompleted;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: isOverdue ? Colors.red.shade50 : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isOverdue ? Colors.red : Colors.indigo,
          child: Text(
            reminder.category?.split(' ')[0] ?? '📌',
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(
          reminder.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isOverdue ? Colors.red : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (reminder.description != null) ...[
              Text(
                reminder.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
            ],
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: isOverdue ? Colors.red : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDateTime(reminder.scheduledTime),
                  style: TextStyle(
                    fontSize: 12,
                    color: isOverdue ? Colors.red : Colors.grey,
                    fontWeight: isOverdue ? FontWeight.bold : null,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!reminder.isCompleted)
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: () {
                  context.read<ReminderProvider>().completeReminder(reminder);
                },
              ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteReminder(context),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteReminder(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Reminder'),
        content: const Text('Are you sure you want to delete this reminder?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ReminderProvider>().deleteReminder(reminder);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final reminderDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (reminderDate == today) {
      return 'Today at ${DateFormat('HH:mm').format(dateTime)}';
    } else if (reminderDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow at ${DateFormat('HH:mm').format(dateTime)}';
    } else {
      return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
    }
  }
}
