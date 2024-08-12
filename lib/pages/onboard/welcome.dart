import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:your/pages/onboard/login.dart';
import 'package:your/pages/onboard/signup.dart';

class WelcomePage extends StatefulWidget {
  final bool isFirstTimeInstallApp;
  const WelcomePage({super.key, required this.isFirstTimeInstallApp});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Column(
        children: [
          _buildOnboardingText(),
          const Spacer(),
          _buildLoginButton(),
          _buildSignUpButton(),
        ],
      ),
    );
  }

  Widget _buildOnboardingText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/logo.png",
          width: 200,
          height: 200,
        ),
        Container(
          margin: EdgeInsets.only(top: 50),
          child: Text("Look into you",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        const SizedBox(height: 26),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Text(
              "Please login in to your account before you start your journey with YOUR",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.normal)),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 48,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
          onPressed: () {
            _showLoginPage();
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xff66923b),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text("LOGIN",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ))),
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      width: double.infinity,
      height: 48,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: ElevatedButton(
          onPressed: () {
            _showSignUpPage();
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text("SIGN UP",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ))),
    );
  }

  void _showLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _showSignUpPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupPage()),
    );
  }
}
