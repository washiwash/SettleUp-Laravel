import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    
    // Calculate responsive sizes
    final double logoWidth = screenWidth * 0.8; // 80% of screen width
    final double logoHeight = screenHeight * 0.5; // 30% of screen height
    final double titleSize = screenWidth * 0.1; // 10% of screen width
    final double subtitleSize = screenWidth * 0.035; // 3.5% of screen width
    final double buttonWidth = screenWidth * 0.35; // 35% of screen width
    final double buttonHeight = screenHeight * 0.06; // 6% of screen height
    final double buttonFontSize = screenWidth * 0.04; // 4% of screen width

    return Scaffold(
      backgroundColor: const Color(0xFFFFE4C9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight - MediaQuery.of(context).padding.top,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    SizedBox(
                      width: logoWidth,
                      height: logoHeight,
                      child: Image.asset(
                        'assets/SettleUp_logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(
                              'Image could not be loaded',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: subtitleSize,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // Title
                    Text(
                      'Settle Up',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        fontSize: titleSize.clamp(24.0, 40.0), // Min 24, max 40
                        color: const Color(0xFF493628),
                      ),
                    ),
                    
                    // Subtitle
                    Text(
                      'Lend your money here',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300,
                        fontSize: subtitleSize.clamp(12.0, 16.0), // Min 12, max 16
                        color: const Color(0xFF493628),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.15),
                    
                    // Buttons
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Sign In Button
                          SizedBox(
                            width: buttonWidth,
                            height: buttonHeight,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF493628),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                  ),
                                ),
                                elevation: 5,
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Sign In',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w600,
                                    fontSize: buttonFontSize.clamp(16.0, 18.0),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // Register Button
                          SizedBox(
                            width: buttonWidth,
                            height: buttonHeight,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDADADA),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                elevation: 5,
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Register',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w500,
                                    fontSize: buttonFontSize.clamp(16.0, 18.0),
                                    color: const Color(0xFF493628),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}