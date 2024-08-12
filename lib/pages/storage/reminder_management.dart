import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:your/pages/components/confirmation.dart';

class ReminderManagement extends StatefulWidget {
  const ReminderManagement({super.key});

  @override
  State<ReminderManagement> createState() => _ReminderManagementState();
}

class _ReminderManagementState extends State<ReminderManagement> {
  int? _selectedOption = 1;
  DateTime? _selectedDate;
  String _searchQuery = '';
  Future<List<Map<String, dynamic>>>? _dataFuture;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    String collectionName;
    switch (_selectedOption) {
      case 1:
        collectionName = 'diary';
        break;
      case 2:
        collectionName = 'reminders';
        break;
      case 3:
        collectionName = 'letters';
        break;
      default:
        collectionName = '';
        break;
    }

    if (collectionName.isNotEmpty) {
      _dataFuture = _fetchFromCollection(collectionName);
    } else {
      _dataFuture = Future.value([]);
    }
  }

  Future<List<Map<String, dynamic>>> _fetchFromCollection(
      String collectionName) async {
    Query query = FirebaseFirestore.instance.collection(collectionName);

    if (_selectedDate != null) {
      query = query.where('date', isEqualTo: _selectedDate);
    }

    if (_searchQuery.isNotEmpty) {
      print('Search query: $_searchQuery');
      query = query
          .where('content', isGreaterThanOrEqualTo: _searchQuery)
          .where('content', isLessThanOrEqualTo: '$_searchQuery\uf8ff');
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id, // Include document ID
        ...data,
      };
    }).toList();
  }

  Future<void> _showConfirmation(Map<String, dynamic> item) async {
    bool? confirmed = await ConfirmationDialog.showConfirmationDialog(
      context,
      title: 'Confirm Action',
      message:
          'I am aware that at the moment you write down this letter, it means something important to you. Do you sure you want to delete it?',
    );

    if (confirmed == true) {
      String collectionName;
      switch (_selectedOption) {
        case 1:
          collectionName = 'diary';
          break;
        case 2:
          collectionName = 'reminders';
          break;
        case 3:
          collectionName = 'letters';
          break;
        default:
          collectionName = '';
          break;
      }

      if (collectionName.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(item['id'])
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item deleted')),
        );
        await _fetchData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Collection is empty')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Action canceled')),
      );
    }
  }

  // Method to show detailed content in a modal popup
  void _showDetailDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime? dateTime = item['datetime']?.toDate();
        String dateTimeString =
            dateTime != null ? DateFormat('HH:mm').format(dateTime) : 'No date';

        return AlertDialog(
          title: Text(
            _selectedOption == 1
                ? 'Diary Detail'
                : _selectedOption == 2
                    ? 'Reminder Detail'
                    : _selectedOption == 3
                        ? 'DEAR FUTURE ME'
                        : 'Detail',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${item['content'] ?? 'No details'}'),
              SizedBox(height: 10),
              if (_selectedOption == 1)
                Text(
                    'Date: ${DateFormat('yyyy-MM-dd').format(item['date'].toDate())}'),
              if (_selectedOption == 2) Text('Time: $dateTimeString'),
              if (_selectedOption == 3)
                Text(
                    'Sent Date: ${DateFormat('yyyy-MM-dd').format(item['sentDate'].toDate())}'),
              SizedBox(height: 10),
              if (_selectedOption == 2)
                Text('Repeat: ${_getRepeatText(item['repeat'])}'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _getRepeatText(int? repeat) {
    if (repeat == null) return 'No repeat';
    switch (repeat) {
      case 0:
        return 'No repeat';
      case 1:
        return 'Daily';
      case 2:
        return 'Every Monday';
      case 3:
        return 'Every Tuesday';
      case 4:
        return 'Every Wednesday';
      case 5:
        return 'Every Thursday';
      case 6:
        return 'Every Friday';
      case 7:
        return 'Every Saturday';
      case 8:
        return 'Every Sunday';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder Management',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: const Color(0xff66923b),
      ),
      body: Column(
        children: [
          // Fixed Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  color: const Color(0xff66923b),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 8,
                      bottom: 8,
                    ),
                    child: Text(
                      "You are searching for",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<int>(
                    value: _selectedOption,
                    items: const [
                      DropdownMenuItem(
                        value: 1,
                        child: Text("My daily diary"),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Text("Just my daily reminders"),
                      ),
                      DropdownMenuItem(
                        value: 3,
                        child: Text("Just my future letters"),
                      ),
                    ],
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedOption = newValue;
                        _fetchData();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // Search Bar
          _buildSearchBar(),
          // Fixed Calendar
          _buildCalendar(),
          // Scrollable Reminder List
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  return _buildReminderList(snapshot.data!);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _fetchData();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff66923b),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff4a773b),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      width: double.infinity,
      height: 350,
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: const Color(0xff66923b).withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: const Color(0xff66923b),
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(color: Colors.white, fontSize: 12),
          todayTextStyle: TextStyle(fontSize: 12),
          weekendTextStyle: TextStyle(fontSize: 12),
        ),
        headerStyle: HeaderStyle(
          titleTextStyle: TextStyle(fontSize: 14),
          formatButtonVisible: false,
          leftChevronIcon: Icon(Icons.chevron_left, size: 20),
          rightChevronIcon: Icon(Icons.chevron_right, size: 20),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(fontSize: 12),
          weekendStyle: TextStyle(fontSize: 12),
        ),
        selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDate = selectedDay;
            _fetchData();
          });
        },
      ),
    );
  }

  Widget _buildReminderList(List<Map<String, dynamic>> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        if (_selectedOption == 1) {
          return ListTile(
            title: Text(
              item['content'] ?? 'No title',
              maxLines: 2, // Limit to 2 lines
              overflow: TextOverflow.ellipsis, // Ellipsis for overflow
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              DateFormat('yyyy-MM-dd').format(item['date'].toDate()),
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _showConfirmation(item),
            ),
            onTap: () => _showDetailDialog(item), // Show detail dialog
          );
        }

        if (_selectedOption == 3) {
          return ListTile(
            title: Text(
              item['content'] ?? 'No title',
              maxLines: 2, // Limit to 2 lines
              overflow: TextOverflow.ellipsis, // Ellipsis for overflow
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              DateFormat('yyyy-MM-dd').format(item['sentDate'].toDate()),
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _showConfirmation(item),
            ),
            onTap: () => _showDetailDialog(item), // Show detail dialog
          );
        }
        final int repeat = item['repeat'];
        DateTime? dateTime = item['datetime']?.toDate();
        String? repeatText = '';
        String dateTimeString =
            dateTime != null ? DateFormat('HH:mm').format(dateTime) : 'No date';
        if (repeat != null) {
          switch (repeat) {
            case 0:
              repeatText = "No repeat";
              break;
            case 1:
              repeatText = "Daily";
              break;
            case 2:
              repeatText = "Every Monday";
              break;
            case 3:
              repeatText = "Every Tuesday";
              break;
            case 4:
              repeatText = "Every Wednesday";
              break;
            case 5:
              repeatText = "Every Thursday";
              break;
            case 6:
              repeatText = "Every Friday";
              break;
            case 7:
              repeatText = "Every Saturday";
              break;
            case 8:
              repeatText = "Every Sunday";
              break;
          }
        }

        return ListTile(
          title: Text(
            item['content'] ?? 'No title',
            maxLines: 2, // Limit to 2 lines
            overflow: TextOverflow.ellipsis, // Ellipsis for overflow
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            dateTimeString + ' - ' + repeatText,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _showConfirmation(item),
          ),
          onTap: () => _showDetailDialog(item), // Show detail dialog
        );
      },
    );
  }
}
