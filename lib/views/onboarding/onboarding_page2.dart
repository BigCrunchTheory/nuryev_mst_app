import 'package:flutter/material.dart';

class OnboardingPage2 extends StatelessWidget {
  final PageController pageController;
  final VoidCallback onContinue;
  final bool isMobile;

  const OnboardingPage2({
    super.key,
    required this.pageController,
    required this.onContinue,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue.shade300,
            Colors.blue.shade700,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () {
                    pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: isMobile ? 28 : 36,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Icon(
                  Icons.star,
                  size: isMobile ? 100 : 150,
                  color: Colors.yellow.shade300,
                ),
                SizedBox(height: isMobile ? 30 : 50),
                Text(
                  'Unlock Premium Features',
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
                    'Choose a subscription plan that fits your needs and enjoy unlimited access.',
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
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
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
