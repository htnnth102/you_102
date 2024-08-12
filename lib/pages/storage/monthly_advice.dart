import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:async';

import 'package:intl/intl.dart';

class EmotionEntry {
  final DateTime date;
  final String emotion;

  EmotionEntry(this.date, this.emotion);

  factory EmotionEntry.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EmotionEntry(
      (data['date'] as Timestamp).toDate(),
      data['mood'] as String? ?? '', // Handle null mood
    );
  }
}

class MonthlyAdvice extends StatefulWidget {
  const MonthlyAdvice({super.key});

  @override
  _MonthlyAdviceState createState() => _MonthlyAdviceState();
}

class _MonthlyAdviceState extends State<MonthlyAdvice> {
  late GenerativeModel model;
  late Future<void> _initializeModel;
  List<String> _insights = [];

  @override
  void initState() {
    super.initState();
    _initializeModel = _initializeGenerativeModel();
  }

  Future<void> _initializeGenerativeModel() async {
    final apiKey = "AIzaSyCV_2hVsFUo7d-9IMguWhp3uXK0svbA7pg";
    if (apiKey.isEmpty) {
      print('No API_KEY environment variable');
      return;
    }

    model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    await _generateInsightsFromAI(); // Fetch insights from Gemini AI
  }

  Future<List<Map<String, dynamic>>> _fetchDiaryRecords() async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth =
          DateTime(now.year, now.month + 1, 1).subtract(Duration(seconds: 1));

      final querySnapshot = await FirebaseFirestore.instance
          .collection('diary')
          .where('date', isGreaterThanOrEqualTo: startOfMonth)
          .where('date', isLessThanOrEqualTo: endOfMonth)
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching diary records: $e');
      return [];
    }
  }

  String _formatDiaryRecords(List<Map<String, dynamic>> records) {
    final buffer = StringBuffer();

    for (var record in records) {
      final date = record['date']?.toDate();
      final content = record['content'] ?? '';
      buffer.writeln(
          'On ${DateFormat('d MMM').format(date ?? DateTime.now())}: $content');
    }

    return buffer.toString();
  }

  Future<void> _generateInsightsFromAI() async {
    try {
      // Fetch diary records from Firebase
      final diaryRecords = await _fetchDiaryRecords();
      if (diaryRecords.isEmpty) {
        throw Exception('No diary records found for this month');
      }

      // Format diary records into a prompt
      final formattedDiary = _formatDiaryRecords(diaryRecords);
      final prompt = [
        Content.text(
            'Based on the following diary entries, can you give me some advice and provide supportive advice: $formattedDiary')
      ];

      // Ensure 'model' is properly initialized and 'generateContent' method exists
      if (model == null) {
        throw Exception('Model is not initialized');
      }

      final response = await model.generateContent(prompt);

      if (response == null) {
        throw Exception('No response received from the model');
      }

      setState(() {
        _insights = response.text!.split('\n');
      });
    } catch (e) {
      // Print the error with more details
      print('Error generating insights: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff66923b),
        title: SingleChildScrollView(
          child: Text(
            'Monthly Mood Insights',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: FutureBuilder<void>(
        future: _initializeModel,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error initializing model'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('moods')
                      .where('date',
                          isGreaterThanOrEqualTo: _getFirstDayOfMonth())
                      .where('date', isLessThanOrEqualTo: _getLastDayOfMonth())
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No mood data available.'));
                    }

                    // Generate a list of all dates in the current month
                    final allDates = _generateAllDatesInMonth();
                    // Map fetched data to EmotionEntry objects
                    final fetchedEntries = snapshot.data!.docs.map((doc) {
                      return EmotionEntry.fromDocument(doc);
                    }).toList();
                    // Create a map of dates to their corresponding mood entries
                    final fetchedEntriesMap = {
                      for (var entry in fetchedEntries)
                        _formatDate(entry.date): entry,
                    };
                    // Create a list of all dates with mood entries
                    final entries = allDates.map((date) {
                      final formattedDate = _formatDate(date);
                      return fetchedEntriesMap[formattedDate] ??
                          EmotionEntry(date, ''); // Default to empty mood
                    }).toList();

                    return Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(
                                bottom: 16.0, left: 10.0, right: 10.0),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 8.0, // Space between items horizontally
                              runSpacing: 8.0, // Space between rows vertically
                              children: List.generate(
                                (entries.length / 7)
                                    .ceil(), // Calculate number of rows
                                (index) {
                                  final start = index * 7;
                                  final end = (start + 7 < entries.length)
                                      ? start + 7
                                      : entries.length;
                                  return Row(
                                    children: entries
                                        .sublist(start, end)
                                        .map((entry) {
                                      return Wrap(
                                        children: [
                                          _buildEmotionEntry(entry),
                                        ],
                                      );
                                    }).toList(),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                          _buildMonthlyAdvice(entries),
                          _buildAIInsights(), // Display AI-generated insights
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  DateTime _getFirstDayOfMonth() {
    final today = DateTime.now();
    return DateTime(today.year, today.month, 1);
  }

  DateTime _getLastDayOfMonth() {
    final today = DateTime.now();
    return DateTime(today.year, today.month + 1, 0);
  }

  List<DateTime> _generateAllDatesInMonth() {
    final firstDay = _getFirstDayOfMonth();
    final lastDay = _getLastDayOfMonth();
    final allDates = <DateTime>[];

    for (var date = firstDay;
        date.isBefore(lastDay.add(Duration(days: 1)));
        date = date.add(Duration(days: 1))) {
      allDates.add(date);
    }

    return allDates;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
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
        icon = Icons.remove_circle_outline; // Default icon for missing mood
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      width: 45,
      margin: const EdgeInsets.symmetric(
          horizontal: 8.0), // Add margin to separate items
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${entry.date.day}/${entry.date.month}', // Display day and month only
            textAlign: TextAlign.center,
            style:
                TextStyle(fontWeight: FontWeight.bold), // Make date text bold
          ),
          if (icon != Icons.remove_circle_outline) Icon(icon, size: 25),
          if (icon == Icons.remove_circle_outline) Text('--'),
        ],
      ),
    );
  }

  Widget _buildMonthlyAdvice(List<EmotionEntry> entries) {
    final insights = _generateInsights(entries);

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 16.0),
      width: double.infinity,
      alignment: Alignment.centerLeft, // Align content to the left
      decoration: BoxDecoration(
        color: const Color(0xffa5cc85),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
        children: [
          ...insights
              .map((insight) => Text(
                    '$insight',
                    textAlign:
                        TextAlign.left, // Align text within each text widget
                  ))
              .toList(),
        ],
      ),
    );
  }

  List<String> _generateInsights(List<EmotionEntry> entries) {
    final moodCount = <String, int>{
      '1': 0, // Dissatisfied
      '2': 0, // Sad
      '3': 0, // Neutral
      '4': 0, // Happy
      '5': 0, // Excited
    };

    for (var entry in entries) {
      if (entry.emotion.isNotEmpty) {
        moodCount[entry.emotion] = (moodCount[entry.emotion] ?? 0) + 1;
      }
    }

    final totalDays = entries.length;
    final moodEntries = moodCount.entries.where((e) => e.value > 0).toList();
    final mostFrequentMood = moodEntries.isNotEmpty
        ? moodEntries.reduce((a, b) => a.value > b.value ? a : b).key
        : '3'; // Default to neutral if no mood data

    final List<String> insights = [
      "Most frequent mood: ${_getMoodLabel(mostFrequentMood)} (${moodCount[mostFrequentMood]} days)",
      "Mood distribution:",
      for (var mood in moodCount.entries)
        "- ${_getMoodLabel(mood.key)}: ${mood.value} days (${(mood.value / totalDays * 100).toStringAsFixed(1)}%)",
    ];

    return insights;
  }

  String _getMoodLabel(String mood) {
    switch (mood) {
      case '1':
        return 'Dissatisfied';
      case '2':
        return 'Sad';
      case '3':
        return 'Neutral';
      case '4':
        return 'Happy';
      case '5':
        return 'Excited';
      default:
        return 'Unknown';
    }
  }

  Widget _buildAIInsights() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 16.0),
      width: double.infinity,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: const Color(0xffa5cc85).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _insights.isEmpty
            ? [Text('No AI insights available.')]
            : _insights.map((insight) => Text(insight)).toList(),
      ),
    );
  }
}
