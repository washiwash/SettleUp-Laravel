import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:settleup/pages/notification.dart';
import 'package:settleup/pages/setting.dart';
import 'package:settleup/pages/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final List<Map<String, dynamic>> receiveList;
  final List<Map<String, dynamic>> payList;

  const HomePage({
    super.key,
    required this.receiveList,
    required this.payList,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Map<String, dynamic>> receiveList;
  late List<Map<String, dynamic>> payList;
  bool isLoading = false;
  int _currentIndex = 0;
  Map<String, dynamic>? userDetails;
  late String token;

  @override
  void initState() {
    super.initState();
    receiveList = List<Map<String, dynamic>>.from(widget.receiveList);
    payList = List<Map<String, dynamic>>.from(widget.payList);
    _fetchUserDetails();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('auth_token') ?? '';
    });
  }

  Future<void> _fetchUserDetails() async {
    final url =
        Uri.parse('http://127.0.0.1:8000/api/user-details'); // API endpoint

    try {
      // Retrieve the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        print("Auth token not found");
        return; // Exit if no token is found
      }

      // Make the API call
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Use the retrieved token
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          userDetails =
              json.decode(response.body); // Parse and store user details
        });
      } else {
        print("Failed to fetch user details: ${response.body}");
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

 Future<void> _fetchDebtors() async {
  setState(() {
    isLoading = true;
  });

  final url = Uri.parse('http://127.0.0.1:8000/api/receivables');

  try {
    if (token.isEmpty) {
      print("Auth token is missing");
      return;
    }

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      setState(() {
        receiveList = data.map((item) => Map<String, dynamic>.from(item)).toList();
      });
    } else {
      print("Failed to fetch debtors: ${response.body}");
    }
  } catch (e) {
    print("Error fetching debtors: $e");
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    final totalUpcomingReceive = _calculateUpcomingTotal(receiveList);
    final totalUpcomingPay = _calculateUpcomingTotal(payList);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.height * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              _buildBalanceOverview(
                totalReceive: totalUpcomingReceive,
                totalPay: totalUpcomingPay,
              ),
              const SizedBox(height: 30),
              Text(
                'Upcoming Due Dates',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              _buildDueDatesList(),
              const Spacer(),
              Center(
                child: Text(
                  'Manage your transactions effortlessly!',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF7A7A7A),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  double _calculateUpcomingTotal(List<Map<String, dynamic>> list) {
    final now = DateTime.now();
    return list.where((item) {
      final dueDateString = item['dueDate'] as String?;
      if (dueDateString == null) return false;
      DateTime? dueDate;
      try {
        dueDate = DateFormat('MMM dd, yyyy').parse(dueDateString);
      } catch (e) {
        dueDate = null;
      }
      return dueDate != null && dueDate.isAfter(now);
    }).fold<double>(
      0,
      (sum, item) =>
          sum + (double.tryParse(item['amount']?.toString() ?? '0') ?? 0.0),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Welcome back, ${userDetails?['name'] ?? 'User'}!',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceOverview({
    required double totalReceive,
    required double totalPay,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF493628), Color(0xFFede0d4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Debt Balance',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 10),
          Text(
            '₱${(totalReceive + totalPay).toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Divider(color: Colors.white30, thickness: 1, height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBalanceDetail(
                title: 'Receive',
                amount: totalReceive,
                color: Colors.greenAccent,
              ),
              _buildBalanceDetail(
                title: 'Pay',
                amount: totalPay,
                color: Colors.redAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceDetail({
    required String title,
    required double amount,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '₱${amount.toStringAsFixed(2)}',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDueDatesList() {
    final now = DateTime.now();
    final upcomingDates = [
      ...receiveList.map((item) => {
            'name': item['name'],
            'amount': item['amount'], // Using 'amount'
            'dueDate': item['dueDate'],
            'type': 'Receive',
          }),
      ...payList.map((item) => {
            'name': item['name'],
            'amount': item['amount'], // Using 'amount'
            'dueDate': item['dueDate'],
            'type': 'Pay',
          }),
    ].where((item) {
      final dueDateString = item['dueDate'] as String?;
      if (dueDateString == null) return false;
      DateTime? dueDate;
      try {
        dueDate = DateFormat('MMM dd, yyyy').parse(dueDateString);
      } catch (e) {
        dueDate = null;
      }
      return dueDate != null && dueDate.isAfter(now);
    }).toList();

    upcomingDates.sort((a, b) {
      final dateA = DateFormat('MMM dd, yyyy').parse(a['dueDate']);
      final dateB = DateFormat('MMM dd, yyyy').parse(b['dueDate']);
      return dateA.compareTo(dateB);
    });

    return upcomingDates.isEmpty
        ? Center(
            child: Text(
              'No upcoming due dates.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF7A7A7A),
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: upcomingDates.length,
            itemBuilder: (context, index) {
              final item = upcomingDates[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: item['type'] == 'Receive'
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    child: Icon(
                      item['type'] == 'Receive'
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    item['name'],
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '₱${double.tryParse(item['amount']?.toString() ?? '0')?.toStringAsFixed(2)} • Due: ${item['dueDate'] ?? 'N/A'}',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ),
              );
            },
          );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavBarIcon(Icons.home, 0, '/home',
              HomePage(receiveList: receiveList, payList: payList)),
          _buildNavBarIcon(
              Icons.wallet, 1, '/wallet', WalletPage(receiveList: receiveList)),

          const SizedBox(width: 40), // Placeholder for the FAB
          _buildNavBarIcon(
              Icons.notifications, 2, '/notification', NotificationPage()),
          _buildNavBarIcon(Icons.settings, 3, '/settings', SettingsPage()),
        ],
      ),
    );
  }

 Widget _buildNavBarIcon(IconData icon, int index, String route, Widget page) {
  return IconButton(
    icon: isLoading && index == 1
        ? CircularProgressIndicator()
        : Icon(
            icon,
            size: 40,
            color: _currentIndex == index ? const Color(0XFF493628) : Colors.grey,
          ),
    onPressed: () async {
      if (_currentIndex != index) {
        setState(() => _currentIndex = index);

        if (index == 1) { // Wallet button is pressed
          await _fetchDebtors(); // Fetch the debtor data
        }

        Navigator.of(context).push(_createFadePageRoute(page));
      }
    },
  );
}


  PageRouteBuilder _createFadePageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 150),
    );
  }
}
