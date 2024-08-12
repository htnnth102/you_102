import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmotionEntry {
  final DateTime date;
  String emotion;

  EmotionEntry(this.date, this.emotion);

  factory EmotionEntry.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EmotionEntry(
      (data['date'] as Timestamp).toDate(),
      data['mood'] as String,
    );
  }
}

class EmotionTableScreen extends StatelessWidget {
  List<EmotionEntry> _generateAllDates(
      DateTime firstDayOfMonth, DateTime lastDayOfMonth) {
    List<EmotionEntry> entries = [];

    for (DateTime date = firstDayOfMonth;
        date.isBefore(lastDayOfMonth.add(Duration(days: 1)));
        date = date.add(Duration(days: 1))) {
      entries.add(EmotionEntry(date, '')); // Default emotion to empty string
    }

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final firstDayOfMonth = DateTime(today.year, today.month, 1);
    final lastDayOfMonth =
        DateTime(today.year, today.month + 1, 0); // Last day of the month

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('moods').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<EmotionEntry> allDates =
              _generateAllDates(firstDayOfMonth, lastDayOfMonth);

          if (snapshot.hasData) {
            final documents = snapshot.data!.docs;
            final entriesFromDb =
                documents.map((doc) => EmotionEntry.fromDocument(doc)).toList();

            for (var entry in allDates) {
              // Find matching entry from Firestore
              final matchingEntry = entriesFromDb.firstWhere(
                (dbEntry) =>
                    dbEntry.date.year == entry.date.year &&
                    dbEntry.date.month == entry.date.month &&
                    dbEntry.date.day == entry.date.day,
                orElse: () =>
                    EmotionEntry(entry.date, ''), // Default if not found
              );
              entry.emotion = matchingEntry.emotion;

              // Debug print statements
              print('Entry Date: ${entry.date}, Emotion: ${entry.emotion}');
            }
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0, // Horizontal space between items
              runSpacing: 8.0, // Vertical space between rows
              children: allDates.map((entry) {
                return Container(
                  width: (MediaQuery.of(context).size.width - 5.5 * 6) /
                      7, // Adjust width to fit screen
                  child: _buildEmotionEntry(entry),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmotionEntry(EmotionEntry entry) {
    IconData icon;
    switch (entry.emotion) {
      case '1':
        icon = Icons.sentiment_dissatisfied; // Dissatisfied
        break;
      case '2':
        icon = Icons.sentiment_dissatisfied; // Sad
        break;
      case '3':
        icon = Icons.sentiment_neutral; // Neutral
        break;
      case '4':
        icon = Icons.sentiment_satisfied; // Happy
        break;
      case '5':
        icon = Icons.sentiment_very_satisfied; // Excited
        break;
      default:
        icon = Icons.help; // Default icon if mood is not recognized
    }

    return Container(
      height: 53,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${entry.date.day}/${entry.date.month}', // Display day and month only
            textAlign: TextAlign.center,
          ),
          if (icon != Icons.help) Icon(icon, size: 25),
          if (icon == Icons.help) Text('--'),
        ],
      ),
    );
  }
}
