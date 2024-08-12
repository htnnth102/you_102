import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  String? _confirmPassword;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildOnboardingText(),
              SizedBox(height: 20),
              _buildLoginFormField(),
              SizedBox(height: 20),
              _buildLoginButton(),
            ],
          ),
        ),
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
          child: Text("Your journey starts here",
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
    return Column(
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
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
            if (!emailRegex.hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
          onSaved: (value) => _email = value,
        ),
        const SizedBox(height: 20),
        TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Password",
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters long';
            }
            return null;
          },
          onSaved: (value) => _password = value,
        ),
        const SizedBox(height: 20),
        TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Confirm Password",
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            return null;
          },
          onSaved: (value) => _confirmPassword = value,
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            if (_password != _confirmPassword) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Passwords do not match'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            _registerUser();
          }
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xff66923b),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text("CREATE ACCOUNT",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )),
      ),
    );
  }

  void _registerUser() async {
    print('Registering user');
    print(_email);
    print(_password);
    CollectionReference colRef = _firestore.collection('users');
    await colRef.add({
      'email': _email,
      'password': _password,
    });

    Navigator.pushNamed(context, '/welcome');
  }
}
