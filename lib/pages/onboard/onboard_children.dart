import 'package:flutter/material.dart';
import 'package:your/utils/enums/onboarding_page_position.dart';

class OnboardChildren extends StatefulWidget {
  final OnboardingPagePosition position;
  final VoidCallback onNavigate;
  final VoidCallback onBack;
  final VoidCallback onSkip;
  const OnboardChildren(
      {super.key,
      required this.position,
      required this.onNavigate,
      required this.onBack,
      required this.onSkip});

  @override
  State<OnboardChildren> createState() => _OnboardChildrenState();
}

class _OnboardChildrenState extends State<OnboardChildren> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xff66923b),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSkipButton(),
              _buildOnboardingImage(),
              _buildOnboardingPageController(),
              _buildOnboardingText(),
              SizedBox(height: 150),
              _buildNavigateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Container(
      margin: EdgeInsets.only(top: 14),
      alignment: AlignmentDirectional.centerStart,
      child: TextButton(
          onPressed: () {
            widget.onSkip();
          },
          child: Text("Skip", style: TextStyle(color: Colors.black))),
    );
  }

  Widget _buildOnboardingImage() {
    return Image.asset(widget.position.onBoardingPageImage(),
        width: 396, height: 396);
  }

  Widget _buildOnboardingPageController() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 4,
          width: 26,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: widget.position.index == 0
                ? Colors.black.withOpacity(0.9)
                : Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(56),
          ),
        ),
        Container(
          height: 4,
          width: 26,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: widget.position.index == 1
                ? Colors.black.withOpacity(0.9)
                : Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(56),
          ),
        ),
        Container(
          height: 4,
          width: 26,
          decoration: BoxDecoration(
            color: widget.position.index == 2
                ? Colors.black.withOpacity(0.9)
                : Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(56),
          ),
        ),
      ],
    );
  }

  Widget _buildOnboardingText() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.position.onBoardingPageText(),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 16, left: 16),
              child: Text(
                widget.position.onBoardingPageContent(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ));
  }

  Widget _buildNavigateButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          TextButton(
              onPressed: () {
                widget.onBack();
              },
              child: Text("BACK")),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              widget.onNavigate();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff66923b),
            ),
            child: Text(
                //      widget.position.index == 2 ? "Get Started" : "Next",
                widget.position.index == 2 ? "Get Started" : "Next",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ],
      ),
    );
  }
}
