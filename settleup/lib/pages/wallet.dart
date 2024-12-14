import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:settleup/pages/home.dart';
import 'package:settleup/pages/notification.dart'; 
import 'package:settleup/pages/setting.dart';

class WalletPage extends StatefulWidget {
  final List<Map<String, dynamic>> receiveList;
  final List<Map<String, dynamic>> payList;

  const WalletPage({
    super.key,
    this.receiveList = const [], // Default to an empty list
    this.payList = const [], // Default to an empty list
  });

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  int _currentIndex = 1; // Set initial index to 1 for WalletPage
  bool isReceiveSelected = true;

  late List<Map<String, dynamic>> receiveList;
  late List<Map<String, dynamic>> payList;
  final List<Map<String, dynamic>> archivedItems = [];

  final phoneRegex = RegExp(r'^(09|\+639)\d{9}$');
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  void initState() {
    super.initState();
    // Initialize the lists with data from the widget
    receiveList = List<Map<String, dynamic>>.from(widget.receiveList);
    payList = List<Map<String, dynamic>>.from(widget.payList);
    _loadTransactions(); // Load from SharedPreferences (if any)
  }

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('receiveList', jsonEncode(receiveList));
    await prefs.setString('payList', jsonEncode(payList));
    await prefs.setString('archivedItems', jsonEncode(archivedItems)); // Save archived items
  }

 
 Future<void> _loadTransactions() async {
  final prefs = await SharedPreferences.getInstance();
  final String? payListString = prefs.getString('payList');
  final String? receiveListString = prefs.getString('receiveList');

  if (payListString != null) {
    setState(() {
      payList = List<Map<String, dynamic>>.from(jsonDecode(payListString));
    });
    print('Loaded payList: $payList');
  } else {
    print('No saved payList found.');
  }

  if (receiveListString != null) {
    setState(() {
      receiveList = List<Map<String, dynamic>>.from(jsonDecode(receiveListString));
    });
    print('Loaded receiveList: $receiveList');
  } else {
    print('No saved receiveList found.');
  }
}


void _archiveItem(int index, bool isReceive) {
  setState(() {
    final item = isReceive ? receiveList.removeAt(index) : payList.removeAt(index);
    archivedItems.add(item);
  });
  _saveTransactions(); // Save transactions after archiving an item
}

void addTransaction(Map<String, dynamic> transaction, bool isReceive) {
  final targetList = isReceive ? receiveList : payList;

  if (!targetList.contains(transaction)) {
    setState(() {
      targetList.add(transaction);
    });
    _saveTransactions(); // Save the updated list
    print('Added transaction to ${isReceive ? "receiveList" : "payList"}: $targetList');
  } else {
    print('Duplicate transaction detected.');
  }
}
double getResponsiveFontSize(BuildContext context, double baseFontSize) {
  final screenWidth = MediaQuery.of(context).size.width;
  return baseFontSize * (screenWidth / 375); // 375 is the base width for scaling
}

@override
  Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

    EdgeInsets getResponsivePadding() {
      return EdgeInsets.only(
        top: screenHeight * 0.04,
        left: screenWidth * 0.05,
        right: screenWidth * 0.05,
      );
    }

    double getResponsiveWidth(double baseWidth) {
      return screenWidth * (baseWidth / 375);
    }

    double getResponsiveHeight(double baseHeight) {
      return screenHeight * (baseHeight / 812);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: const Color(0xFFffffff),
          body: SingleChildScrollView(
            child: Padding(
              padding: getResponsivePadding(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: getResponsiveHeight(20)),
                  Text(
                    'Lendings',
                    style: GoogleFonts.poppins(
                      fontSize: getResponsiveFontSize(context, 30),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF582f0e),
                    ),
                  ),
                  SizedBox(height: getResponsiveHeight(20)),
                  Center(
                    child: Container(
                      width: getResponsiveWidth(200),
                      height: getResponsiveHeight(40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          _buildTabButton(
                            text: 'Receive',
                            isSelected: isReceiveSelected,
                            onTap: () => setState(() => isReceiveSelected = true),
                          ),
                          _buildTabButton(
                            text: 'Pay',
                            isSelected: !isReceiveSelected,
                            onTap: () => setState(() => isReceiveSelected = false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: getResponsiveHeight(20)),
                  _buildContentContainer(
                    context: context,
                    width: getResponsiveWidth(350),
                    height: getResponsiveHeight(500),
                    isReceive: isReceiveSelected,
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildResponsiveBottomBar(context, screenWidth),
          floatingActionButton: _buildFloatingActionButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }

  Widget _buildTabButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: double.infinity, // Fill parent container height
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: text == 'Receive' ? const Radius.circular(20) : Radius.zero,
              bottomLeft: text == 'Receive' ? const Radius.circular(20) : Radius.zero,
              topRight: text == 'Pay' ? const Radius.circular(20) : Radius.zero,
              bottomRight: text == 'Pay' ? const Radius.circular(20) : Radius.zero,
            ),
            color: isSelected
                ? (text == 'Receive' ? const Color(0xFF432818) : const Color(0xFF432818))
                : const Color(0xffedede9),
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: getResponsiveFontSize(context, 16),
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF7a7a7a),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentContainer({
    required BuildContext context,
    required double width,
    required double height,
    required bool isReceive,
  }) {
    final items = isReceive ? receiveList : payList;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isReceive ? const Color(0XFFFFE4C9) : const Color(0XFFFFE4C9),
      ),
      child: items.isEmpty
          ? Center(
              child: Text(
                isReceive ? 'No Receive Transactions' : 'No Pay Transactions',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      
                    title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                item['name'],
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: getResponsiveFontSize(context, 18),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.archive),
              onPressed: () {
                  _archiveItem(index, isReceive);
              },
            ),
          ],
        ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                        '₱${NumberFormat('#,##0.00').format(double.parse(item['amount']))}',
                        style: GoogleFonts.poppins(
                        fontSize: getResponsiveFontSize(context, 17),
                        color: isReceive ? Colors.green : Colors.red,
                        ),
                      ),
                      Text('Duration: ${item['startDate']} - ${item['dueDate']}'),
                      // if (item.containsKey('calculatedInterest'))
                      //   Text(
                      //   'Interest: ₱${item['calculatedInterest']}',
                      //   style: GoogleFonts.poppins(color: Colors.orange),
                      //   ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    
                        children: [
                        IconButton(
                          icon: const Icon(Icons.access_time),
                           onPressed: () => showDialogInterestTransaction(context, index, isReceive),
                          tooltip: 'Add Interest',
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications),
                          onPressed: () => _sendReminder(item),
                          tooltip: 'Send Reminder',
                        ),
                        IconButton(
                          icon: const Icon(Icons.money),
                          onPressed: () => _markAsPaid(item, isReceive),
                          tooltip: 'Mark as Paid',
                        ),
                        ],
                      ),
                      ],
                    ),
                    ),
                  );
                  },
                ),
            );
            }

void showDialogInterestTransaction(BuildContext context, int index, bool isReceive) {
  final transactionList = isReceive ? receiveList : payList;
  final transaction = transactionList[index];

  // Check if interest has been added already
  final double previousInterest = transaction['calculatedInterest'] ?? 0.0;
  final double amount = double.tryParse(transaction['amount'].toString()) ?? 0.0;
  final double interestRate = double.tryParse(transaction['interestRate']?.toString() ?? '0') ?? 0.0;

  // Calculate the predicted interest
  final DateTime startDate = DateFormat('MMM dd, yyyy').parse(transaction['startDate']);
  final DateTime dueDate = DateFormat('MMM dd, yyyy').parse(transaction['dueDate']);
  final int days = dueDate.difference(startDate).inDays;
  final int months = (days / 30).floor(); // Use floor to be more conservative
  final double predictedInterest = (amount * interestRate / 100) * months;
  
  // Calculate final amount
  final double finalAmount = amount + predictedInterest;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        'Transaction Interest Details',
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Transaction Details
          _buildDetailRow('Transaction Amount', '₱${amount.toStringAsFixed(2)}'),
          _buildDetailRow('Interest Rate', '${interestRate.toStringAsFixed(2)}%'),
          _buildDetailRow('Transaction Duration', '$days days ($months month${months != 1 ? 's' : ''})'),
          
          const SizedBox(height: 16),
          
          // Interest Calculation
          if (months >= 1)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Predicted Interest: ₱${predictedInterest.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Final Amount: ₱${finalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            )
          else
            const Text(
              'No interest applied (less than 30 days)',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          
          // Previous Interest (if any)
          if (previousInterest > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Previous Interest Added: ₱${previousInterest.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.green),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

// Helper method to create consistent detail rows
Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
  void _addInterestToTransaction({
    required int index,
    required bool isReceive,
    required double interestRate,
  }) {
    final transactionList = isReceive ? receiveList : payList;
    final transaction = transactionList[index];
    final double amount = double.parse(transaction['amount']);
    final double calculatedInterest = amount * (interestRate / 100);

    setState(() {
      transaction['calculatedInterest'] = calculatedInterest;
    });

    _saveTransactions();
  }

  void _sendReminder(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Send Reminder',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('How would you like to send the reminder?'),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  title: Text(
                    'Reminder Sent',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  content: Text(
                    'Reminder sent via email to ${item['email']}',
                    style: GoogleFonts.poppins(),
                  ),
                  actions: [
                    TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF432818), // Cool background color
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.white), // White text color
                    ),
                    ),
                  ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.sms),
              title: const Text('SMS'),
              onTap: () {
                Navigator.pop(context);
               
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                title: Text(
                  'Reminder Sent',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                content: Text(
                  'Reminder sent via SMS to ${item['contact']}',
                  style: GoogleFonts.poppins(),
                ),
                actions: [
                  TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF432818), // Cool background color
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white), // White text color
                  ),
                  ),
                ],
                ),
              );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _markAsPaid(Map<String, dynamic> item, bool isReceive) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Mark as Paid'),
        // content: const Text('Are you sure you want to mark this transaction as paid?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (isReceive) {
                  receiveList.remove(item);
                } else {
                  payList.remove(item);
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Transaction marked as paid')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

 Widget _buildFloatingActionButton() {
  return FloatingActionButton(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25), // Adjust this value for a more oblong shape
    ),
    onPressed: _showAddTransactionDialog,
    backgroundColor: const Color(0xFFf0ead2),
    child: const Icon(Icons.add, color: Color(0XFF582f0e), size: 20),
  );
}

 void _addTransaction(Map<String, dynamic> transaction) {
    final isReceive = isReceiveSelected;
    addTransaction(transaction, isReceive);
  }

 void _showAddTransactionDialog() {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final amountController = TextEditingController();
  final startDateController = TextEditingController();
  final dueDateController = TextEditingController();
  final interestRateController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  DateTime? selectedStartDate;
  DateTime? selectedDueDate;

  showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) {
        void validateDateAndInterest() {
          setState(() {
            if (selectedStartDate != null && selectedDueDate != null) {
              // Ensure due date is after start date
              if (selectedDueDate!.isBefore(selectedStartDate!)) {
                selectedDueDate = null;
                dueDateController.clear();
              }
            }
          });
        }

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Add Transaction',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Please enter a name';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Please enter an email';
                      if (!emailRegex.hasMatch(value!)) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: contactController,
                    decoration: const InputDecoration(labelText: 'Contact Number'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Please enter a contact number';
                      if (!phoneRegex.hasMatch(value!)) return 'Enter a valid phone number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Please enter an amount';
                      if (double.tryParse(value!) == null) return 'Enter a valid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: startDateController,
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          selectedStartDate = date;
                          startDateController.text = DateFormat('MMM dd, yyyy').format(date);
                          
                          // Reset due date if it's before the new start date
                          if (selectedDueDate != null && selectedDueDate!.isBefore(date)) {
                            selectedDueDate = null;
                            dueDateController.clear();
                          }
                        });
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Start Date'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Please select a start date';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: dueDateController,
                    readOnly: true,
                    onTap: () async {
                      if (selectedStartDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select start date first')),
                        );
                        return;
                      }
                      
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedStartDate!.add(const Duration(days: 1)),
                        firstDate: selectedStartDate!.add(const Duration(days: 1)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          selectedDueDate = date;
                          dueDateController.text = DateFormat('MMM dd, yyyy').format(date);
                          validateDateAndInterest();
                        });
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Due Date'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Please select a due date';
                      return null;
                    },
                  ),
              const SizedBox(height: 16),
const SizedBox(height: 16),
TextFormField(
  controller: interestRateController,
  decoration: const InputDecoration(labelText: 'Interest Rate (%)'),
  keyboardType: TextInputType.number,
  enabled: selectedStartDate != null && 
           selectedDueDate != null && 
           selectedDueDate!.difference(selectedStartDate!).inDays >= 30,
  validator: (value) {
    // If the field is enabled, validate the number
    if (value?.isNotEmpty ?? false) {
      if (double.tryParse(value!) == null) return 'Enter a valid number';
    }
    return null;
  },
),
if (selectedStartDate != null && selectedDueDate != null) 
  Builder(
    builder: (context) {
      final days = selectedDueDate!.difference(selectedStartDate!).inDays;
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          days < 30 
            ? 'Note: No interest will be applied for transactions less than 30 days.' 
            : 'Transaction duration: $days day(s)',
          style: TextStyle(color: days < 30 ? Colors.orange : Colors.green),
        ),
      );
    },
  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final transaction = {
                    'name': nameController.text,
                    'email': emailController.text,
                    'contact': contactController.text,
                    'amount': amountController.text,
                    'startDate': startDateController.text,
                    'dueDate': dueDateController.text,
                    'interestRate': interestRateController.text,
                  };
                  _addTransaction(transaction);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    ),
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
          offset: const Offset(0, 3), // Changes position of shadow
        ),
      ],
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
      final tween = Tween<double>(begin: 0.0, end: 1.0);
      final opacityAnimation = animation.drive(tween);

      return FadeTransition(
        opacity: opacityAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 150),
  );
}
}
