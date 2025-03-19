import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/transactionProvider.dart';
import 'notification_page.dart'; // Ensure this file exists

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Helper method to group transactions by date
  Map<String, List<Map<String, dynamic>>> _groupTransactionsByDate(
      List<Map<String, dynamic>> transactions) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    final now = DateTime.now();

    for (var transaction in transactions) {
      final date = DateTime.parse(transaction['date']);
      String key;

      if (date.day == now.day &&
          date.month == now.month &&
          date.year == now.year) {
        key = "Today";
      } else if (date.day == now.day - 1 &&
          date.month == now.month &&
          date.year == now.year) {
        key = "Yesterday";
      } else {
        key = "${date.day}/${date.month}/${date.year}";
      }

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(transaction);
    }

    return grouped;
  }

  // Calculate total balance, income, and expenses
  Map<String, double> _calculateBalances(
      List<Map<String, dynamic>> transactions) {
    double totalBalance = 0;
    double income = 0;
    double expenses = 0;

    for (var t in transactions) {
      final amount = t['amount'] as double;
      totalBalance += amount;
      if (amount >= 0) {
        income += amount;
      } else {
        expenses += amount.abs();
      }
    }

    return {
      'totalBalance': totalBalance,
      'income': income,
      'expenses': expenses,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: provider.transactionsStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return const Scaffold(
                body: Center(child: Text('Error loading transactions')),
              );
            }

            final transactions = snapshot.data!;
            final balances = _calculateBalances(transactions);
            final transactionsByDate = _groupTransactionsByDate(transactions);

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: const Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/img_4.png'),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Hey, Jacob!",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications,
                        color: Color.fromARGB(255, 73, 176, 205)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationsPage()),
                      );
                    },
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "\$${balances['totalBalance']!.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Total Balance",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildBalanceCard(
                          "Income",
                          balances['income']!,
                          Icons.arrow_upward,
                          const Color.fromARGB(255, 6, 210, 111),
                        ),
                        _buildBalanceCard(
                          "Expense",
                          balances['expenses']!,
                          Icons.arrow_downward,
                          Colors.redAccent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Recent Transactions",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 82, 80, 80)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: transactions.isEmpty
                          ? const Center(
                              child: Text(
                                "No transactions yet.",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            )
                          : ListView(
                              padding: const EdgeInsets.only(top: 5),
                              children: transactionsByDate.entries.map((entry) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.key,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    ...entry.value.map(
                                      (transaction) => _buildTransactionCard(
                                        transaction["title"],
                                        transaction["description"] ??
                                            "${transaction['type']} - ${transaction['category'] ?? 'Uncategorized'}",
                                        transaction["amount"],
                                        _getIconForCategory(
                                            transaction["category"]),
                                        _getColorForType(transaction["type"]),
                                        transaction["date"],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                );
                              }).toList(),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBalanceCard(
    String title,
    double amount,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
                const SizedBox(height: 7),
                Text(
                  "\$${amount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Icon(icon, color: Colors.white, size: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(
    String title,
    String desc,
    double amount,
    IconData icon,
    Color iconColor,
    String date,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: iconColor.withOpacity(0.2),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    desc,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "\$${amount.abs().toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: amount >= 0 ? Colors.green : Colors.red,
                ),
              ),
              Text(
                date,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIconForCategory(String? category) {
    switch (category ?? 'Uncategorized') {
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Food':
        return Icons.local_dining;
      case 'Transport':
        return Icons.directions_car;
      default:
        return Icons.category;
    }
  }

  Color _getColorForType(String? type) {
    switch (type ?? 'Uncategorized') {
      case 'Income':
        return Colors.green;
      case 'Expense':
        return Colors.red;
      default:
        return Colors.grey; // Neutral fallback color
    }
  }
}
