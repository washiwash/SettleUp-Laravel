import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:settleup/pages/notification.dart'; 
import 'package:settleup/pages/setting.dart';
import 'package:settleup/pages/wallet.dart';

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
  int _currentIndex = 0;
  

  @override
  void initState() {
    super.initState();
    receiveList = List<Map<String, dynamic>>.from(widget.receiveList);
    payList = List<Map<String, dynamic>>.from(widget.payList);
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
      (sum, item) => sum + (double.tryParse(item['amount']?.toString() ?? '0') ?? 0.0),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'SettleUP',
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
        _buildNavBarIcon(Icons.home, 0, '/home', HomePage(receiveList: receiveList, payList: payList)),
        _buildNavBarIcon(Icons.wallet, 1, '/wallet', WalletPage()),
        const SizedBox(width: 40), // Placeholder for the FAB
        _buildNavBarIcon(Icons.notifications, 2, '/notification', NotificationPage()),
        _buildNavBarIcon(Icons.settings, 3, '/settings', SettingsPage()),
      ],
    ),
  );
}

Widget _buildNavBarIcon(IconData icon, int index, String route, Widget page) {
  return IconButton(
    icon: Icon(
      icon,
      size: 40,
      color: _currentIndex == index ? const Color(0XFF493628) : Colors.grey,
    ),
    onPressed: () {
      if (_currentIndex != index) {
        setState(() => _currentIndex = index);

        // Navigate with fade transition
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