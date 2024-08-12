import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:your/pages/home/home.dart';
import 'package:your/pages/onboard/account_created_notice.dart';
import 'package:your/pages/onboard/onboard.dart';
import 'package:your/pages/onboard/signup.dart';
import 'package:your/pages/onboard/welcome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/welcome': (context) => AccountCreatedNotice(),
        '/signup': (context) => SignupPage(),
        '/default': (context) => MainPage(),
      },
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // backgroundColor: Theme.of(context).colorScheme.primary, from rgba(103, 58, 183, 1)
          ),
      // body: MainPage(),
      // body: WelcomePage(isFirstTimeInstallApp: false),
      body: OnBoardingPageView(),
    );
  }
}
