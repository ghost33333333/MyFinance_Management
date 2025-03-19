import 'package:finance/Analytics/analytics.dart';
import 'package:finance/Home/home_page.dart';
import 'package:finance/accounts/account_page.dart';
import 'package:finance/category/category_page.dart';
import 'package:finance/provider/transactionProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    DashboardScreen(), // Replace with your actual implementation
    AnalyticsPage(),
    CategoryManagementPage(), // Replace with your actual implementation
    AccountPage(), // Replace with your actual implementation
  ];

  @override
  Widget build(BuildContext context) {
    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: GNav(
                gap: 8,
                backgroundColor: Colors.white,
                color: const Color.fromARGB(255, 12, 154, 236),
                activeColor: Colors.white,
                tabBackgroundColor: Colors.grey[800]!,
                padding: const EdgeInsets.all(10),
                onTabChange: _onItemTapped,
                tabs: const [
                  GButton(icon: Icons.home, text: 'Home'),
                  GButton(icon: Icons.analytics, text: 'Analytics'),
                  GButton(icon: Icons.category, text: 'Categories'),
                  GButton(icon: Icons.person, text: 'Accounts'),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () {
                  transactionProvider.showTransactionDialog(context);
                },
                backgroundColor: Colors.blue,
                elevation: 0,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, size: 32, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
