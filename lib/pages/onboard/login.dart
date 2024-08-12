import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          _buildOnboardingText(),
          _buildLoginFormField(),
          SizedBox(height: 20),
          _buildLoginButton(),
          const Spacer(),
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
          child: Text("Log in to your account",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        const SizedBox(height: 26),
      ],
    );
  }

  Widget _buildLoginFormField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: "Email",
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              hintText: "Password",
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 48,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
          onPressed: () {},
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
}
