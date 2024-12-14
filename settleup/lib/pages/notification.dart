import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:settleup/pages/wallet.dart';
import 'package:settleup/pages/home.dart';
import 'package:settleup/pages/setting.dart'; // Add this import statement

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _currentIndex = 2;

  // Example notifications list
  final List<Map<String, String>> notifications = [
    {
      'title': 'Payment Reminder',
      'message': 'Your payment of ₱1,000 is due tomorrow.',
      'time': '1 hour ago'
    },
    {
      'title': 'Debt Reminder',
      'message': "Remil's debt of ₱100 is due tommorrow.",
      'time': 'Yesterday'
    },
   
  ];

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
    
      body: Padding(
        padding: getResponsivePadding(),
        child: notifications.isEmpty
            ? Center(
                child: Text(
                  'No new notifications',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF7A7A7A),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      title: Text(
                        notification['title'] ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF582F0E),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            notification['message'] ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF7A7A7A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            notification['time'] ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.notifications,
                        color: Color(0xFF432818),
                      ),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: _buildResponsiveBottomBar(context, screenWidth),
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
        _buildNavBarIcon(Icons.home, 0, HomePage(receiveList: [], payList: [])), // Replace with actual pages
        _buildNavBarIcon(Icons.wallet, 1,  WalletPage()), // Replace with actual pages
        const SizedBox(width: 40), // Placeholder for FAB
        _buildNavBarIcon(Icons.notifications, 2,  NotificationPage()), // Replace with actual pages
        _buildNavBarIcon(Icons.settings, 3,  SettingsPage()), // Replace with actual pages
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

        // Custom fade transition
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
            transitionDuration: const Duration(milliseconds: 150), // Adjust duration if needed
          ),
        );
      }
    },
  );
}
}
