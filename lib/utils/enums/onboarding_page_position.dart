enum OnboardingPagePosition { page1, page2, page3 }

extension OnboardingPagePositionExtension on OnboardingPagePosition {
  int get index {
    switch (this) {
      case OnboardingPagePosition.page1:
        return 0;
      case OnboardingPagePosition.page2:
        return 1;
      case OnboardingPagePosition.page3:
        return 2;
    }
  }

  String onBoardingPageImage() {
    switch (this) {
      case OnboardingPagePosition.page1:
        return 'assets/images/logo.png';
      case OnboardingPagePosition.page2:
        return 'assets/images/logo.png';
      case OnboardingPagePosition.page3:
        return 'assets/images/logo.png';
    }
  }

  String onBoardingPageText() {
    switch (this) {
      case OnboardingPagePosition.page1:
        return "Welcome to YOU";
      case OnboardingPagePosition.page2:
        return "Keep every moment";
      case OnboardingPagePosition.page3:
        return 'YOU ARE BEST';
    }
  }

  String onBoardingPageContent() {
    switch (this) {
      case OnboardingPagePosition.page1:
        return "...journey starts right here where you begin to learn how to look into yourself";
      case OnboardingPagePosition.page2:
        return "To master well your boat of life, past needs to be remembered and present needs to be treasured";
      case OnboardingPagePosition.page3:
        return 'No one can ever be a better companion of yours than YOU.';
    }
  }
}
