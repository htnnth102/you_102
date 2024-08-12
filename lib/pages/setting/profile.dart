import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? _name;
  bool _receiveQuote = false;
  bool _receiveReminder = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 14),
              alignment: AlignmentDirectional.center,
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/avatar.jpeg'),
                  ),
                  // TextButton(
                  //   onPressed: () {},
                  //   child: const Text(
                  //     'Change Profile Picture',
                  //     style: TextStyle(color: Colors.black),
                  //   ),
                  // ),
                  SizedBox(height: 16), // Space between text fields
                  Container(
                    margin: EdgeInsets.only(top: 14),
                    child: Column(
                      children: [
                        if (_name == "Change Password") _buildChangePassword(),
                        if (_name == "Change Profile") _buildTextFieldData(),
                        if (_name == "Change Language") _buildOptionSetting(),
                        if (_name == "Change Theme") _buildOptionSetting(),
                        if (_name == null) _buildOptionSetting(),
                      ],
                    ),
                  ),
                  SizedBox(height: 16), // Space between text fields
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangePassword() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          height: 50,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Old Password',
            ),
          ),
        ),
        SizedBox(height: 16), // Space between text fields
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          height: 50,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'New Password',
            ),
          ),
        ),
        SizedBox(height: 16), // Space between text fields
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          height: 50,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Confirm New Password',
            ),
          ),
        ),
        SizedBox(height: 16), // Space between text fields
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _selectedName(null);
              },
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _name = null;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff66923b),
              ),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildTextFieldData() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          height: 58,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Your Name',
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 16), // Add padding inside the TextField
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(height: 8), // Gap between text fields
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          height: 58,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Your Email',
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 16), // Add padding inside the TextField
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(height: 8), // Gap between text fields
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          height: 58,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Your Phone Number',
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 16), // Add padding inside the TextField
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(height: 16), // Space before buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _selectedName(null);
              },
              child: const Text('CANCEL'),
            ),
            SizedBox(width: 16), // Space between buttons
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _name = null;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff66923b),
              ),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionSetting() {
    return Column(
      children: [
        ListTile(
          title: const Text('Change Profile'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            _selectedName("Change Profile");
          },
        ),
        ListTile(
          title: const Text('Change Password'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            _selectedName("Change Password");
          },
        ),
        ListTile(
          title: const Text('Language'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            _selectedName("Change Language");
          },
        ),
        ListTile(
          title: const Text('Theme'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            _selectedName("Change Theme");
          },
        ),
        ListTile(
          title: const Text('Logout'),
          trailing: const Icon(Icons.logout_outlined),
          onTap: () {
            _selectedName("Change Theme");
          },
        ),
        SizedBox(height: 16), // Space between text fields
        _buildDefaultSetting(),
      ],
    );
  }

  Widget _buildDefaultSetting() {
    return Column(
      children: [
        SwitchListTile(
            title: const Text('Receive daily quote'),
            value: _receiveQuote,
            onChanged: (bool value) {
              setState(() {
                _receiveQuote = value;
              });
            },
            activeColor: const Color(0xff66923b),
            inactiveThumbColor: const Color(0xff66923b).withOpacity(0.5),
            inactiveTrackColor: const Color(0xff66923b).withOpacity(0.1)),
        SwitchListTile(
            title: const Text('Receive morning reminder'),
            value: _receiveReminder,
            onChanged: (bool value) {
              setState(() {
                _receiveReminder = value;
              });
            },
            activeColor: const Color(0xff66923b),
            inactiveThumbColor: const Color(0xff66923b).withOpacity(0.5),
            inactiveTrackColor: const Color(0xff66923b).withOpacity(0.1)),
      ],
    );
  }

  void _selectedName(String? value) {
    setState(() {
      _name = value;
    });
  }
}
