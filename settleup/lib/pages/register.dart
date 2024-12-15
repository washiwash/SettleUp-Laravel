// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:settleup/pages/otp.dart'; // Adjust the path as necessary

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Variables remain the same
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  //laravel
  Future<Map<String, dynamic>> registerUser(
      String name, String email, String password) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'message': 'Registration successful'};
    } else {
      final errorData = jsonDecode(response.body);
      return {
        'success': false,
        'message': errorData['message'] ?? 'Registration failed'
      };
    }
  }

  String? nameError;
  String? _passwordError;
  String? _emailError;
  double _passwordStrength = 0;
  String _passwordStrengthLabel = '';
  bool _showPasswordMeter = false;
  bool _wasSubmitted = false;

  // Existing validation methods remain the same
  void validateUsername(String value) {
    if (_wasSubmitted) {
      setState(() {
        if (value.isEmpty) {
          nameError = 'Please enter your username';
        } else if (!isValidUsername(value)) {
          nameError =
              'Username must be 5-20 letters only & no special characters';
        } else {
          nameError = null;
        }
      });
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@(gmail|yahoo)\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void validateEmail(String value) {
    if (_wasSubmitted) {
      setState(() {
        if (value.isEmpty) {
          _emailError = 'Please enter your email';
        } else if (!isValidEmail(value)) {
          _emailError = 'Invalid email address';
        } else {
          _emailError = null;
        }
      });
    }
  }

  void validatePassword(String value) {
    if (_wasSubmitted) {
      setState(() {
        if (value.isEmpty) {
          _passwordError = 'Please enter your password';
        } else if (value.length <= 8) {
          _passwordError = 'It must have 8 characters';
        } else {
          _passwordError = null;
        }
      });
    }
  }

  bool isValidUsername(String name) {
    final nameRegex = RegExp(r'^[a-zA-Z0-9]{5,20}$');
    return nameRegex.hasMatch(name);
  }

  void updatePasswordStrength(String password) {
    setState(() {
      _showPasswordMeter = password.isNotEmpty;
      if (password.isEmpty) {
        _passwordStrength = 0;
        _passwordStrengthLabel = '';
      } else if (password.length < 8) {
        _passwordStrength = 0.3;
        _passwordStrengthLabel = 'Weak';
      } else if (password.length >= 8 &&
          !RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
        _passwordStrength = 0.6;
        _passwordStrengthLabel = 'Medium';
      } else if (password.length >= 12 &&
          RegExp(r'\d|[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
        _passwordStrength = 1.0;
        _passwordStrengthLabel = 'Strong';
      }
    });
  }

  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final url = Uri.parse('http://127.0.0.1:8000/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {'success': true, 'message': data['message']};
    } else {
      final errorData = jsonDecode(response.body);
      return {'success': false, 'message': errorData};
    }
  }
//   Future<Map<String, dynamic>> login(String email, String password) async {
//   final url = Uri.parse('http://127.0.0.1:8000/login'); // Replace with your Laravel API URL
//   final response = await http.post(
//     url,
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode({'email': email, 'password': password}),
//   );

//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     if (data['success'] == true) {
//       return {'success': true, 'token': data['token'], 'user': data['user']};
//     }
//   }
//   return {'success': false, 'message': 'Invalid login credentials'};
// }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? errorText,
    bool isPassword = false,
    Function(String)? onChanged,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust text field size based on screen width
        final double fieldWidth = constraints.maxWidth;
        final double fontSize = fieldWidth < 400 ? 14 : 16;
        final double labelSize = fieldWidth < 400 ? 16 : 20;

        return SizedBox(
          width: fieldWidth,
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            maxLength: maxLength,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: fontSize,
            ),
            onChanged: onChanged,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: GoogleFonts.poppins(
                color: Color(0xFF666161),
                fontSize: labelSize,
              ),
              errorText: errorText,
              prefixIcon: Icon(icon),
              filled: true,
              fillColor: Color(0XFFE9EFEC),
              contentPadding: EdgeInsets.symmetric(
                horizontal: fieldWidth * 0.05,
                vertical: fieldWidth * 0.04,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
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
    final double logoWidth = screenSize.width * (isSmallScreen ? 0.4 : 0.3);
    final double logoHeight = screenSize.height * (isSmallScreen ? 0.15 : 0.2);
    final double doorWidth = screenSize.width * (isSmallScreen ? 0.8 : 0.6);
    final double doorHeight = screenSize.height * (isSmallScreen ? 0.2 : 0.25);
    final double horizontalPadding = screenSize.width * 0.05;
    final double verticalSpacing = screenSize.height * 0.02;

    return Scaffold(
      backgroundColor: Color(0xFFFFE4C9),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: verticalSpacing),
                          // Logo section with responsive sizing
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/logo.png',
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

                          // Form section
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildInputField(
                                  controller: _emailController,
                                  label: 'Email',
                                  icon: Icons.email,
                                  errorText: _emailError,
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: validateEmail,
                                ),
                                SizedBox(height: verticalSpacing),
                                _buildInputField(
                                  controller: _nameController,
                                  label: 'Username',
                                  icon: Icons.person,
                                  errorText: nameError,
                                  maxLength: 20,
                                  onChanged: validateUsername,
                                ),
                                SizedBox(height: verticalSpacing),
                                _buildInputField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  icon: Icons.lock,
                                  errorText: _passwordError,
                                  isPassword: true,
                                  onChanged: (value) {
                                    updatePasswordStrength(value);
                                    validatePassword(value);
                                  },
                                ),
                                if (_showPasswordMeter) ...[
                                  SizedBox(height: verticalSpacing * 0.5),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      return SizedBox(
                                        width: constraints.maxWidth * 0.8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            LinearProgressIndicator(
                                              value: _passwordStrength,
                                              backgroundColor:
                                                  Colors.red.shade100,
                                              color: _passwordStrength == 1.0
                                                  ? Colors.green
                                                  : (_passwordStrength == 0.6
                                                      ? Colors.blue
                                                      : Colors.red),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              _passwordStrengthLabel,
                                              style: TextStyle(
                                                fontSize:
                                                    isSmallScreen ? 12 : 14,
                                                color: _passwordStrength == 1.0
                                                    ? Colors.green
                                                    : (_passwordStrength == 0.6
                                                        ? Colors.blue
                                                        : Colors.red),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),

                          SizedBox(height: verticalSpacing * 1),

                          // Buttons section with responsive sizing
                          Column(
                            children: [
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
                                onPressed: () async {
                                  setState(() {
                                    _wasSubmitted = true;
                                  });
                                  validateEmail(_emailController.text);
                                  validateUsername(_nameController.text);
                                  validatePassword(_passwordController.text);

                                  if (nameError == null &&
                                      _passwordError == null &&
                                      _emailError == null) {
                                    final response = await registerUser(
                                      _nameController.text,
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                    if (response['success']) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OTPPage(
                                            email: _emailController.text,
                                            name: _nameController.text,
                                            password: _passwordController.text,
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(response['message'])),
                                      );
                                    }
                                  }
                                },
                              ),
                              SizedBox(height: verticalSpacing),
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
                                      backgroundColor: Color(0xFFFFFFFF),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenSize.width * 0.11,
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
                            ],
                          ),
                          SizedBox(height: verticalSpacing),
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
