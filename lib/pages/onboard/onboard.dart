import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your/pages/home/home.dart';
import 'package:your/pages/onboard/onboard_children.dart';
import 'package:your/pages/onboard/welcome.dart';
import 'package:your/utils/enums/onboarding_page_position.dart';

class OnBoardingPageView extends StatefulWidget {
  const OnBoardingPageView({super.key});

  @override
  State<OnBoardingPageView> createState() => _OnBoardingPageViewState();
}

class _OnBoardingPageViewState extends State<OnBoardingPageView> {
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            OnboardChildren(
                position: OnboardingPagePosition.page1,
                onSkip: () {
                  _markOnBoardingDone();
                  print("SKIP");
                },
                onNavigate: () {
                  _pageController.jumpToPage(1);
                },
                onBack: () {}),
            OnboardChildren(
                position: OnboardingPagePosition.page2,
                onSkip: () {
                  _markOnBoardingDone();
                  print("SKIP");
                },
                onBack: () {
                  _pageController.jumpToPage(0);
                },
                onNavigate: () {
                  _pageController.jumpToPage(2);
                }),
            OnboardChildren(
                position: OnboardingPagePosition.page3,
                onSkip: () {
                  print("SKIP");
                  _markOnBoardingDone();
                },
                onBack: () {
                  _pageController.jumpToPage(1);
                },
                onNavigate: () {
                  _markOnBoardingDone();
                  _goToWelcomePage();
                  print("HOME");
                }),
          ]),
    );
  }

  void _goToWelcomePage() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const WelcomePage(
                  isFirstTimeInstallApp: true,
                )));
  }

  Future<void> _markOnBoardingDone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnBoardingDone', true);
  }
}
