import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your/pages/home/home.dart';
import 'package:your/pages/onboard/onboard.dart';
import 'package:your/pages/onboard/welcome.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _checkAppState(BuildContext context) async {
    final isDone = await _isOnBoardingDone();
    if (isDone) {
      if (!context.mounted) {
        return;
      }
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const WelcomePage(
                    isFirstTimeInstallApp: false,
                  )));
    } else {
      if (!context.mounted) {
        return;
      }
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OnBoardingPageView(),
          ));
    }
  }

  Future<bool> _isOnBoardingDone() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final rs = prefs.getBool('isOnBoardingDone');
      return rs ?? false;
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkAppState(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: _buildBodyPage(),
    );
  }

  Widget _buildBodyPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Loading...'),
        ],
      ),
    );
  }
}
