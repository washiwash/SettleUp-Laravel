import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:settleup/pages/notification.dart';
import 'package:settleup/pages/home.dart'; // Import the HomePage class
import 'package:settleup/pages/wallet.dart'; // Import the WalletPage class

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _currentIndex = 3; // Set the default index for the settings page
  String username = "Melchi"; // Replace with the actual username
  String email = "Melchi@example.com"; // Replace with the actual email

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    EdgeInsets getResponsivePadding() {
      return EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.02,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          // Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildResponsiveBottomBar(context, screenWidth),
          ),

          // Settings List at the bottom
          Positioned(
            bottom: 96, // Height of bottom navigation bar
            left: 0,
            right: 0,
            child: Padding(
              padding: getResponsivePadding(),
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  _buildSettingsTile(
                    icon: Icons.account_circle,
                    title: 'Account',
                    onTap: () {
                      _showCustomDialog(
                        context,
                        title: 'Account Settings',
                        content: 'Username: $username\nEmail: $email',
                      );
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.help,
                    title: 'Help & Support',
                    onTap: () {
                      _showCustomDialog(
                        context,
                        title: 'Help & Support',
                        content:   'If you have any questions or need help, please contact us at settleUp@gmail.com',
                      );
                        // Use dynamic user data
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.info,
                    title: 'About',
                    onTap: () {
                      _showCustomDialog(
                        context,
                        title: 'About',
                        content: ' SettleUp is a convenient app designed to help you keep track of your debts and remind you of any outstanding balances. Whether you owe money to friends or need to collect payments, SettleUp ensures you never forget a debt again.',
                       

                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF582F0E),
          size: 30,
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF582F0E),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showCustomDialog(BuildContext context,
    {required String title, required String content}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.all(20),
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: const Color(0xFF582F0E),
              size: 30,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF582F0E),
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Text(
              content,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Divider(
              color: Colors.grey[300],
              thickness: 1,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF582F0E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.close, color: Colors.white),
              label: Text(
                'Close',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}


  Widget _buildResponsiveBottomBar(BuildContext context, double screenWidth) {
    return Container(
      width: screenWidth,
      height: 96,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavBarIcon(Icons.home, 0, HomePage(receiveList: [], payList: [])),
          _buildNavBarIcon(Icons.wallet, 1, WalletPage()),
          const SizedBox(width: 40), // Placeholder for the FAB
          _buildNavBarIcon(Icons.notifications, 2, NotificationPage()),
          _buildNavBarIcon(Icons.settings, 3, SettingsPage()),
        ],
      ),
    );
  }

  Widget _buildNavBarIcon(IconData icon, int index, Widget page) {
    return IconButton(
      icon: Icon(
        icon,
        size: 40,
        color: _currentIndex == index ? const Color(0XFF493628) : Colors.grey,
      ),
      onPressed: () {
        if (_currentIndex != index) {
          setState(() => _currentIndex = index);

          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => page,
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 150),
            ),
          );
        }
      },
    );
  }
}
