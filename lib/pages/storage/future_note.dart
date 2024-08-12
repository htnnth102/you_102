import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:your/pages/components/confirmation.dart';

class FutureNote extends StatefulWidget {
  const FutureNote({super.key});

  @override
  State<FutureNote> createState() => _FutureNoteState();
}

class _FutureNoteState extends State<FutureNote> {
  Future<void> _showConfirmation() async {
    bool? confirmed = await ConfirmationDialog.showConfirmationDialog(
      context,
      title: 'Confirm Action',
      message:
          'I am aware that at the moment you write down this letter, it means something important to you. Do you sure you want to delete it?',
    );

    if (confirmed == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item deleted')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Action canceled')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Fixed Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Letter of future",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xff66923b),
              ),
            ),
          ),
          // Search Bar
          _buildSearchBar(),
          // Fixed Calendar
          _buildCalendar(),
          // Scrollable Reminder List
          Expanded(
            child: _buildReminderItem(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
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
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      width: double.infinity,
      height: 450,
      child: SingleChildScrollView(
        child: TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: DateTime.now(),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: const Color(0xff66923b),
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
        ),
      ),
    );
  }

  Widget _buildReminderItem() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            title: Text('Meeting with John Doe'),
            subtitle: Text('10:00 AM - 11:00 AM'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _showConfirmation();
              },
            ),
          ),
          ListTile(
            title: Text('Lunch with Jane Doe'),
            subtitle: Text('12:00 PM - 1:00 PM'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
            ),
          ),
          ListTile(
            title: Text('Dinner with John Smith'),
            subtitle: Text('6:00 PM - 7:00 PM'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
            ),
          ),
          ListTile(
            title: Text('Meeting with John Doe'),
            subtitle: Text('10:00 AM - 11:00 AM'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
            ),
          ),
          ListTile(
            title: Text('Lunch with Jane Doe'),
            subtitle: Text('12:00 PM - 1:00 PM'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
            ),
          ),
          ListTile(
            title: Text('Dinner with John Smith'),
            subtitle: Text('6:00 PM - 7:00 PM'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
            ),
          ),
          ListTile(
            title: Text('Lunch with Jane Doe'),
            subtitle: Text('12:00 PM - 1:00 PM'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
            ),
          ),
          ListTile(
            title: Text('Dinner with John Smith'),
            subtitle: Text('6:00 PM - 7:00 PM'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
