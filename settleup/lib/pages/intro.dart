import 'package:flutter/material.dart';
import 'package:settleup/pages/start.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  IntroPageState createState() => IntroPageState();
}

class IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController();
  bool _isAnimating = false; // Prevents multiple animations stacking
  int _currentStep = 0;
  bool _isAtEnd = false;

  // Function to handle smooth scrolling and prevent stacking animations
  void _scrollRight() async {
    if (_isAtEnd) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StartScreen()),
      );
    } else if (!_isAnimating) {
      // Disable further scrolling until animation ends
      setState(() {
        _isAnimating = true;
      });

      // Scroll to next position with smooth animation
      await _pageController.animateToPage(
        _currentStep + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      // Re-enable scrolling and update step information
      setState(() {
        _isAnimating = false;
        _updateCurrentStep();
      });
    }
  }

  // Function to update the current step
  void _updateCurrentStep() {
    setState(() {
      _currentStep = _pageController.page!.round();
      _isAtEnd = _currentStep >= 3; // Last step check
    });
  }

  // Function to get header text based on the current step
  String _getStepHead() {
    switch (_currentStep) {
      case 0:
        return "Debts List";
      case 1:
        return "Remind";
      case 2:
        return "Record Logs";
      case 3:
        return "Track Now";
      default:
        return "";
    }
  }

  // Function to get description text based on the current step
  String _getStepText() {
    switch (_currentStep) {
      case 0:
        return "Track your debts and\nsettle them with ease.";
      case 1:
        return "Remind your debtors to pay\ntheir dues on time.";
      case 2:
        return "Keep track of your activities";
      case 3:
        return "Maximize full capabilities";
      default:
        return "";
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      _updateCurrentStep(); // Update current step on page change
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Calculate responsive dimensions
    final double titleSize = screenWidth * 0.05;
    final double scrollViewWidth = screenWidth * 0.55;
    final double scrollViewHeight = screenHeight * 0.45;
    final double imageSize = scrollViewWidth;
    final double headingSize = screenWidth * 0.045;
    final double textSize = screenWidth * 0.04;
    final double buttonWidth = screenWidth * 0.85;
    final double buttonHeight = screenHeight * 0.07;
    final double dotWidth = screenWidth * 0.05;
    final double dotHeight = screenHeight * 0.005;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4C9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App title
            Text(
              'SettleUp',
              style: GoogleFonts.poppins(
                fontSize: titleSize.clamp(18.0, 24.0),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF493628),
              ),
            ),
            const SizedBox(height: 40),

            // Horizontal scrolling ListView with images
            SizedBox(
                width: scrollViewWidth,
                height: scrollViewHeight,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable manual scrolling
                children: [
                  Image.asset('assets/Feature1.png', width: imageSize, height: imageSize),
                  Image.asset('assets/Feature2.png', width: imageSize, height: imageSize),
                  Image.asset('assets/Feature3.png', width: imageSize , height: imageSize),
                  Image.asset('assets/Feature4.png', width: imageSize, height: imageSize),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Progress indicator dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  width: dotWidth,
                  height: dotHeight,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: index == _currentStep
                        ? const Color(0xFF493628) // Active step color
                        : const Color(0xff131C2B).withOpacity(0.3), // Inactive step color
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            // Step text content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getStepHead(),
                  style: GoogleFonts.poppins(
                    fontSize: headingSize.clamp(16.0, 20.0),
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  _getStepText(),
                  style: GoogleFonts.poppins(
                    fontSize: textSize.clamp(14.0, 18.0),
                    fontWeight: FontWeight.w300,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 60),

            // Continue / Get Started button
            SizedBox(
              height: buttonHeight,
              width: buttonWidth,
              child: ElevatedButton(
                onPressed: _scrollRight,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF493628),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
                child: Text(
                  _isAtEnd ? 'Get Started' : 'Continue',
                  style: GoogleFonts.poppins(
                    fontSize: textSize.clamp(14.0, 16.0),
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
