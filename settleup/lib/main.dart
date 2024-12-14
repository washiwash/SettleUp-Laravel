import 'package:flutter/material.dart';
import 'package:settleup/pages/wallet.dart';
import 'package:settleup/pages/home.dart';
import 'package:settleup/pages/intro.dart';
import 'package:settleup/pages/register.dart';
import 'package:settleup/pages/login.dart';
import 'package:settleup/pages/otp.dart';
import 'package:settleup/pages/notification.dart'; 
import 'package:settleup/pages/setting.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Define the initial route
      routes: {
        '/': (context) => const IntroPage(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/otp': (context) => const OTPPage(),
        '/notification': (context) => const NotificationPage(),
        '/settings': (context) => SettingsPage(),
      },
      // `onGenerateRoute` for passing arguments dynamically
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            return MaterialPageRoute(
              builder: (context) => HomePage(
                receiveList: args['receiveList'] ?? [],
                payList: args['payList'] ?? [],
              ),
            );
          case '/wallet':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            return MaterialPageRoute(
              builder: (context) => WalletPage(
                receiveList: args['receiveList'] ?? [],
                payList: args['payList'] ?? [],
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const IntroPage(),
            );
        }
      },
    );
  }
}
