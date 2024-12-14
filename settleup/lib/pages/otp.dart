// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  String? _errorMessage;

  /// Verifies the OTP entered by the user.
  ///
  /// If any of the fields are empty, sets [_errorMessage] to
  /// 'Please enter all digits'.
  ///
  /// If the OTP is incorrect, sets [_errorMessage] to
  /// 'Incorrect verification code', clears all fields, focuses
  /// back to the first field and returns.
  ///
  /// If the OTP is correct, clears [_errorMessage], navigates to
  /// the home page.
  void _verifyOTP() {
    String otp = _otpControllers.map((controller) => controller.text).join();
    
    // Check if any fields are empty
    if (otp.length < 4) {
      setState(() {
        _errorMessage = 'Please enter all digits';
      });
      return;
    }

    // Here you would typically verify with your backend
    // For demo, let's assume correct OTP is "1234"
    if (otp != "1234") {
      setState(() {
        _errorMessage = 'Incorrect verification code';
      });
      // Optional: Clear all fields on wrong input
      for (var controller in _otpControllers) {
        controller.clear();
      }
      // Focus back to first field
      _focusNodes[0].requestFocus();
      return;
    }

    // Clear error message if verification is successful
    setState(() {
      _errorMessage = null;
    });

    // If OTP is correct, navigate to home
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4C9),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Verify OTP',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 40,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Enter the code sent to your Email',
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Error message display
                          if (_errorMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: GoogleFonts.outfit(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              4,
                              (index) => SizedBox(
                                width: 50,
                                child: TextFormField(
                                  controller: _otpControllers[index],
                                  focusNode: _focusNodes[index],
                                  style: TextStyle(
                                  fontWeight: FontWeight.bold, // Set font weight
                                  fontSize: 20.0, // Font size
                                   color: Colors.white, // Text color
                                                    ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color.fromARGB(255, 122, 95, 75),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    counterText: '',
                                  ),
                                  onChanged: (value) {
                                    // Clear error message when user starts typing
                                    if (_errorMessage != null) {
                                      setState(() {
                                        _errorMessage = null;
                                      });
                                    }
                                    if (value.length == 1 && index < 5) {
                                      _focusNodes[index + 1].requestFocus();
                                    }
                                  else if (value.isEmpty && index > 0) {
                                      _focusNodes[index - 1].requestFocus();
                                    }
                                    else if (index == 3 && value.length == 1) {
                                      _verifyOTP();
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0XFF493628),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 80,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                            ),
                            onPressed:_verifyOTP,
                            
                            child: Text(
                              'Continue',
                              
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                color: Colors.white,
                              
                              
                              ),
                            ),
                          ),
                      
                          TextButton(
                            onPressed: () {
                              
                              // Add resend OTP logic here
                            },
                            child: Text(
                              'Resend Code',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: const Color(0XFF493628),
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
          );
        },
      ),
    );
  }
}