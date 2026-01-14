import 'package:flutter/material.dart';
import 'onboarding_page1.dart';
import 'onboarding_page2.dart';
import '../paywall/paywall_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPaywall() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PaywallScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
          });
        },
        children: [
          OnboardingPage1(pageController: _pageController, isMobile: isMobile),
          OnboardingPage2(
            pageController: _pageController,
            onContinue: _goToPaywall,
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }
}
