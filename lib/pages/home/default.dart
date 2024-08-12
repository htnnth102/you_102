import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Added for location services
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wheel_chooser/wheel_chooser.dart';
import 'package:your/pages/components/this_month_report.dart';

class DefaultPage extends StatefulWidget {
  const DefaultPage({super.key});

  @override
  _DefaultPageState createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {
  late GenerativeModel model;
  bool _hasSubmittedToday = false;
  final TextEditingController _textController = TextEditingController();

  late DateTime time = DateTime.now();

  @override
  void initState() {
    super.initState();
    _checkIfSubmittedToday();
    _initializeGenerativeModel();
  }

  Future<void> _initializeGenerativeModel() async {
    final apiKey = "AIzaSyCV_2hVsFUo7d-9IMguWhp3uXK0svbA7pg";
    if (apiKey.isEmpty) {
      print('No API_KEY environment variable');
      return;
    }
    model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    // await _generateInsightsFromAI(); // Fetch insights from Gemini AI
  }

  Future<void> _checkIfSubmittedToday() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    final query = FirebaseFirestore.instance
        .collection('moods')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay));

    final snapshot = await query.get();
    setState(() {
      _hasSubmittedToday = snapshot.docs.isNotEmpty;
    });
  }

  Future<void> _saveDiary() async {
    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please enter some text')));
      return;
    }
    try {
      final today = DateTime.now();
      final diaryEntry = {
        'date': Timestamp.fromDate(today),
        'content': _textController.text,
        'image': '',
        'geopoint': GeoPoint(21.024435, 105.793818),
      };

      await FirebaseFirestore.instance.collection('diary').add(diaryEntry);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Diary entry saved!')));
      _textController.clear();
      FocusScope.of(context).unfocus();
      final todayDiary = _textController.text;
      print('Today diary: $todayDiary');
      final prompt = [
        Content.text(
            'Hey, today my crush wore a black T-shirt. I wish I had the gut to tell him my feelings. Please say something to cheer me up and make me feel better or give me some advice if needed.')
      ];

      if (model == null) {
        throw Exception('Model is not initialized');
      }

      final response = await model.generateContent(prompt);

      if (response == null) {
        throw Exception('No response received from the model');
      } else {
        String? message = response.text;
        showDialog<void>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Thanks for sharing!'),
            content: Text(message!),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save diary entry: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff66923b),
        title: const Text('Hi, How are you?',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _statusForm(context),
              _buildRateEmotion(context),
              _buildEmotionCalendar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: TextField(
              controller: _textController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff66923b), // Border color
                  ),
                  borderRadius: BorderRadius.circular(8.0), // Border radius
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff66923b), // Border color for enabled state
                  ),
                  borderRadius: BorderRadius.circular(8.0), // Border radius
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff66923b), // Border color for focused state
                  ),
                  borderRadius: BorderRadius.circular(8.0), // Border radius
                ),
                hintText: 'What is in your head now?',
              ),
            ),
          ),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildAlertDatetimePicker(context, true),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFF9FBB83), // Button background color

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Border radius
                      ),
                    ),
                    child: Text('Set Reminder',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildAlertDatetimePicker(context, false),
                      );
                    },
                    child: Text('For rainy day',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFF9FBB83), // Button background color

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Border radius
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _saveDiary, // Save diary entry when button is pressed
                    child: Text('Save diary',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFF9FBB83), // Button background color

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Border radius
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRateEmotion(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Text(
              'Rate your emotion',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.sentiment_very_dissatisfied,
                  size: 40,
                ),
                onPressed: _hasSubmittedToday
                    ? () => _showYouHaveSubmittedDialog(context)
                    : () => _saveMood("1", context),
              ),
              IconButton(
                icon: Icon(
                  Icons.sentiment_dissatisfied,
                  size: 40,
                ),
                onPressed: _hasSubmittedToday
                    ? () => _showYouHaveSubmittedDialog(context)
                    : () => _saveMood("2", context),
              ),
              IconButton(
                icon: Icon(
                  Icons.sentiment_neutral,
                  size: 40,
                ),
                onPressed: _hasSubmittedToday
                    ? () => _showYouHaveSubmittedDialog(context)
                    : () => _saveMood("3", context),
              ),
              IconButton(
                icon: Icon(
                  Icons.sentiment_satisfied,
                  size: 40,
                ),
                onPressed: _hasSubmittedToday
                    ? () => _showYouHaveSubmittedDialog(context)
                    : () => _saveMood("4", context),
              ),
              IconButton(
                icon: Icon(
                  Icons.sentiment_very_satisfied,
                  size: 40,
                ),
                onPressed: _hasSubmittedToday
                    ? () => _showYouHaveSubmittedDialog(context)
                    : () => _saveMood("5", context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionCalendar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Container(
              width: double.infinity,
              color: const Color(0xff66923b).withOpacity(0.3),
              child: Column(
                children: [
                  Container(
                      width: double.infinity,
                      height: 50,
                      color: const Color(0xff66923b),
                      child: Center(
                        child: Text(
                          'Your mood this month',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xff66923b), // Border color
                        width: 1, // Border width
                      ),
                    ),
                    height: 380,
                    child:
                        EmotionTableScreen(), // Replace with your actual widget
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildAlertDatetimePicker(
      BuildContext context, bool showTimePickerOnly) {
    final List<String> options = <String>[
      'Select Repeat',
      'Daily',
      'Every Monday',
      'Every Tuesday',
      'Every Wednesday',
      'Every Thursday',
      'Every Friday',
      'Every Saturday',
      'Every Sunday'
    ];

    return AlertDialog(
      title: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width, // Set maximum width
        ),
        padding: EdgeInsets.symmetric(vertical: 10), // Add vertical padding
        color: const Color(0xff66923b),
        child: Center(
          child: Text(
            'Select Date and Time',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center, // Center the text
          ),
        ),
      ),
      contentPadding: EdgeInsets.zero, // Remove default padding
      content: Container(
        width: MediaQuery.of(context).size.width, // Full width minus margins
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 16),
            if (showTimePickerOnly)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xff66923b), // Border color
                    width: 1, // Border width
                  ),
                  borderRadius:
                      BorderRadius.circular(8), // Optional: rounded corners
                ),
                child: SizedBox(
                  height: 50, // Height for the wheel picker
                  child: WheelChooser(
                    onValueChanged: (value) {
                      print(value);
                    },
                    datas: options,
                    itemSize: 50,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              child: showTimePickerOnly
                  ? CupertinoDatePicker(
                      initialDateTime: DateTime.now(),
                      onDateTimeChanged: (DateTime newDateTime) {
                        setState(() {
                          time = newDateTime;
                        });
                      },
                      use24hFormat: true,
                      minuteInterval: 1,
                      mode: CupertinoDatePickerMode.time,
                    )
                  : CupertinoDatePicker(
                      initialDateTime: DateTime.now(),
                      onDateTimeChanged: (DateTime newDateTime) {
                        setState(() {
                          time = newDateTime;
                        });
                      },
                      use24hFormat: true,
                      minimumYear: 2010,
                      maximumYear: 2030,
                      mode:
                          CupertinoDatePickerMode.date, // Show year, month, day
                    ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            if (showTimePickerOnly) {
              _saveReminder(time);
            } else {
              _saveLetter(time);
            }
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  Future<void> _checkAndRequestLocation(BuildContext context) async {
    bool permissionGranted = await Permission.location.isGranted;
    if (!permissionGranted) {
      // Request permission
      PermissionStatus status = await Permission.location.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        // Show a dialog or snack bar informing the user about the importance of the permission
        return;
      }
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Show dialog to prompt user to enable location services
      _showEnableLocationDialog(context);
    } else {
      // Access the location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print('Location: ${position.latitude}, ${position.longitude}');
    }
  }
  //
  // Future<String> _getGeminiResponse(String mood, String responseType) async {
  //   try {
  //     // Replace with your Gemini AI implementation
  //     String prompt = "Generate a $responseType for a mood rated as $mood.";
  //     String response = await _callGeminiAI(prompt); // Your Gemini AI call
  //     return response;
  //   } catch (e) {
  //     // Handle Gemini AI errors gracefully
  //     print("Error getting Gemini response: $e");
  //     return "Oops! Something went wrong."; // Fallback response
  //   }
  // }

  Future<void> _saveMood(String mood, BuildContext context) async {
    try {
      final today = DateTime.now();
      final moodEntry = {
        'date': Timestamp.fromDate(today),
        'mood': mood,
      };

      String title = '';
      String? content = '';

      String prompt = "Generate a response for a mood rated as $mood.";

      switch (mood) {
        case '1':
          prompt =
              "Today I feel terrible. Say something to cheer me up within 50 words.";
        case '2':
          title = 'I am sorry to hear that';
          prompt =
              "Today is not a good day. Say something to cheer me up within 50 words.";
          break;
        case '3':
          prompt =
              "Today is just an average day. Say something to cheer me up within 50 words.";
          break;
        case '4':
          title = 'Things are looking up!';
          prompt =
              "Today is a good day. Say something to cheer me up within 50 words.";
          break;
        case '5':
          title = 'Great!';
          prompt =
              "Today is a great day. Say something to congratulate me within 50 words.";
          break;
      }

      if (model == null) {
        content = "Oops! Something went wrong.";
      } else {
        // If 'prompt' needs to be a list of strings
        final response = await model.generateContent([Content.text(prompt)]);
        content = response.text;
      }
      await FirebaseFirestore.instance.collection('moods').add(moodEntry);

      showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(title),
          content: Text(content!),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      // Update the UI after saving
      setState(() {
        _hasSubmittedToday = true;
      });
    } catch (e) {
      // Show an error dialog
      showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to record mood: $e'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _saveLetter(DateTime dateTime) async {
    try {
      final letterEntry = {
        'sentDate': Timestamp.fromDate(dateTime),
        'content': _textController.text,
      };

      await FirebaseFirestore.instance.collection('letters').add(letterEntry);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Letter saved!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to save letter: $e')));
    } finally {
      _textController.clear();
    }
  }

  Future<void> _saveReminder(DateTime dateTime) async {
    try {
      final reminderEntry = {
        'datetime': Timestamp.fromDate(dateTime),
        'content': _textController.text,
        'repeat': Random().nextInt(7),
      };

      await FirebaseFirestore.instance
          .collection('reminders')
          .add(reminderEntry);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Reminder saved!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to save reminder: $e')));
    } finally {
      _textController.clear();
    }
  }

  void _showYouHaveSubmittedDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('You have submitted.'),
        content: const Text(
            'Keep calm and take a deep breath at the end of the day. This is the moment to look deep inside to your true feeling. Daily mood rate can not be changed.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showEnableLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Services Disabled'),
          content: Text(
            'Please enable location services to use this feature. You can do this in your device settings.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Open device location settings
                Geolocator.openLocationSettings();
              },
              child: Text('Open Settings'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
