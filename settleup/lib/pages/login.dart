// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _usernameError;
  String? _passwordError;
  bool _wasSubmitted = false;

  bool isValidUsername(String username) {
    final usernameRegex = RegExp(r'^[a-zA-Z0-9]{5,20}$');
    return usernameRegex.hasMatch(username);
  }

  void validateUsername(String value) {
    if (_wasSubmitted) {
      setState(() {
        if (value.isEmpty) {
          _usernameError = 'Please enter your username';
        } else if (!isValidUsername(value)) {
          _usernameError = 'Username must be 5-20 letters only & no special characters';
        } else {
          _usernameError = null;
        }
      });
    }
  }

  void validatePassword(String value) {
    if (_wasSubmitted) {
      setState(() {
        if (value.isEmpty) {
          _passwordError = 'Please enter your password';
        } else if (!isValidPassword(value)) {
          _passwordError = 'Password must be at least 8 characters';
        } else {
          _passwordError = null;
        }
      });
    }
  }

  bool isValidPassword(String password) {
    return password.length >= 8;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? errorText,
    String? helperText,
    bool isPassword = false,
    Function(String)? onChanged,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        final fieldWidth = constraints.maxWidth * 0.85;
        final fontSize = isSmallScreen ? 16.0 : 20.0;
        
        return SizedBox(
          width: fieldWidth,
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            onChanged: onChanged,
            style: GoogleFonts.montserrat(
              fontSize: isSmallScreen ? 14 : 16,
            ),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: GoogleFonts.poppins(
                color: Color(0xFF666161),
                fontSize: fontSize,
              ),
              prefixIcon: Icon(icon),
              filled: true,
              fillColor: Color(0XFFE9EFEC),
              contentPadding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 15 : 20,
                vertical: isSmallScreen ? 15 : 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              errorText: errorText,
              errorStyle: TextStyle(
                color: Colors.red,
                fontSize: isSmallScreen ? 10 : 12,
              ),
              helperText: helperText,
              helperStyle: TextStyle(
                color: Color(0xFF666161),
                fontSize: isSmallScreen ? 10 : 12,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    
    // Responsive dimensions
    final logoWidth = screenSize.width * (isSmallScreen ? 0.4 : 0.3);
    final logoHeight = screenSize.height * (isSmallScreen ? 0.15 : 0.2);
    final doorWidth = screenSize.width * (isSmallScreen ? 0.8 : 0.6);
    final doorHeight = screenSize.height * (isSmallScreen ? 0.2 : 0.25);
    final paddingHorizontal = screenSize.width * 0.05;
    final spacing = screenSize.height * 0.02;

    return Scaffold(
      backgroundColor: Color(0xFFFFE4C9),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: spacing),
                          // Logo Section
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/settle_logo.png',
                                width: logoWidth,
                                height: logoHeight,
                                fit: BoxFit.contain,
                              ),
                              Image.asset(
                                'assets/door.png',
                                width: doorWidth * 1.2,
                                height: doorHeight * 1.45,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                          
                          // Form Section
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildInputField(
                                  controller: _usernameController,
                                  label: 'Username',
                                  icon: Icons.person,
                                  errorText: _usernameError,
                                  onChanged: validateUsername,
                                ),
                                SizedBox(height: spacing),
                                _buildInputField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  icon: Icons.lock,
                                  errorText: _passwordError,
                                  helperText: 'Password must be at least 8 characters',
                                  isPassword: true,
                                  onChanged: validatePassword,
                                ),
                                SizedBox(height: spacing * 1.5),
                                
                                // Confirm Button
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenSize.width * 0.2,
                                      vertical: screenSize.height * 0.02,
                                    ),
                                    textStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: isSmallScreen ? 16 : 18,
                                    ),
                                    foregroundColor: Colors.black,
                                  ),
                                  child: Text('Confirm'),
                                  onPressed: () {
                                    setState(() {
                                      _wasSubmitted = true;
                                    });
                                    validateUsername(_usernameController.text);
                                    validatePassword(_passwordController.text);

                                    if (_usernameError == null && _passwordError == null) {
                                      Navigator.pushNamed(context, '/wallet');
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: spacing * 1),
                          
                          // Navigation Buttons
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF493628),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenSize.width * 0.1,
                                    vertical: screenSize.height * 0.020,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  elevation: 5,
                                ),
                                child: Text(
                                  'Sign In',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w600,
                                    fontSize: isSmallScreen ? 18 : 22,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0XFFFFFFFF),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenSize.width * 0.1,
                                    vertical: screenSize.height * 0.020,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  elevation: 5,
                                ),
                                child: Text(
                                  'Register',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w500,
                                    fontSize: isSmallScreen ? 18 : 22,
                                    color: Color(0XFF493628),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: spacing),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}