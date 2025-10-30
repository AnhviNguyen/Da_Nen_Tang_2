import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/provider/ReminderProvider.dart';

class CompletedRemindersScreen extends StatelessWidget {
  const CompletedRemindersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('✅ Completed'),
        elevation: 0,
      ),
      body: Consumer<ReminderProvider>(
        builder: (context, provider, child) {
          final completed = provider.completedReminders;

          if (completed.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('✅', style: TextStyle(fontSize: 64)),
                  SizedBox(height: 16),
                  Text('No completed reminders'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: completed.length,
            itemBuilder: (context, index) {
              final reminder = completed[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                  title: Text(
                    reminder.title,
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat('dd MMM yyyy, HH:mm').format(reminder.scheduledTime),
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<ReminderProvider>().deleteReminder(reminder);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
