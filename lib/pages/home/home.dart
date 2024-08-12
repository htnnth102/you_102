import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:your/pages/home/default.dart';
import 'package:your/pages/setting/profile.dart';
import 'package:your/pages/storage/future_note.dart';
import 'package:your/pages/storage/monthly_advice.dart';
import 'package:your/pages/storage/reminder_management.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> _pages = [];
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _pages = [
      DefaultPage(),
      ReminderManagement(),
      MonthlyAdvice(),
      // FutureNote(),
      EditProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: #ff66923b, with opacity 0.5
        selectedItemColor: const Color(0xff66923b),
        unselectedItemColor: Colors.black,
        currentIndex: _currentPage,
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_mall_directory),
            label: 'Storage',
          ),
          // BottomNavigationBarItem(
          //   icon: const SizedBox.shrink(),
          //   label: '',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_off_outlined),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      // floatingActionButton: Container(
      //   width: 60,
      //   height: 60,
      //   decoration: BoxDecoration(
      //     color: const Color(0xff66923b),
      //     shape: BoxShape.circle,
      //   ),
      //   child: IconButton(
      //     icon: const Icon(Icons.add),
      //     color: Colors.white,
      //     onPressed: () {},
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
