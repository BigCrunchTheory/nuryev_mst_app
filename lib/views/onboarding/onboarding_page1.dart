import 'package:flutter/material.dart';

class OnboardingPage1 extends StatelessWidget {
  final PageController pageController;
  final bool isMobile;

  const OnboardingPage1({
    super.key,
    required this.pageController,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.deepPurple.shade300,
            Colors.deepPurple.shade700,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: isMobile ? 20 : 40),
            Column(
              children: [
                Icon(
                  Icons.rocket_launch,
                  size: isMobile ? 100 : 150,
                  color: Colors.white,
                ),
                SizedBox(height: isMobile ? 30 : 50),
                Text(
                  'Welcome to Nuryev',
                  style: TextStyle(
                    fontSize: isMobile ? 32 : 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMobile ? 20 : 30),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 24 : 80,
                  ),
                  child: Text(
                    'Discover amazing features and unlock your potential with our premium experience.',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 20,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: isMobile ? 40 : 60),
              child: ElevatedButton(
                onPressed: () {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 40 : 60,
                    vertical: isMobile ? 16 : 20,
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
