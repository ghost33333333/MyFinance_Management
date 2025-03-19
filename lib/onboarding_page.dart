import 'package:finance/main.dart';
import 'package:flutter/material.dart';
import 'package:finance/auth/signup.dart';
import 'package:finance/main_page.dart';
import 'package:finance/provider/category_provider.dart';
import 'package:finance/provider/transactionProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// Onboarding Screen
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _onboardingData = OnboardingData.list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (page) => setState(() => _currentPage = page),
                itemBuilder: (context, index) =>
                    OnboardingPage(data: _onboardingData[index]),
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _buildDots(),
          const SizedBox(height: 20),
          _buildNextButton(),
          if (_currentPage != _onboardingData.length - 1)
            TextButton(
              onPressed: _navigateToAuthScreen,
              child: const Text('Skip'),
            ),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _onboardingData.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 10,
          width: _currentPage == index ? 20 : 10,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: _handleNextOrFinish,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        _currentPage == _onboardingData.length - 1 ? 'Get Started' : 'Next',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  void _handleNextOrFinish() {
    if (_currentPage == _onboardingData.length - 1) {
      _navigateToAuthScreen();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _navigateToAuthScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthWrapper()),
    );
  }
}

// Onboarding Page Model
class OnboardingData {
  final String title, description, image;

  const OnboardingData({
    required this.title,
    required this.description,
    required this.image,
  });

  static const List<OnboardingData> list = [
    OnboardingData(
      title: 'Welcome to Budget Buddy',
      description: 'Track your expenses and income with ease',
      image: 'assets/welcome.png',
    ),
    OnboardingData(
      title: 'Set Your Goals',
      description: 'Plan your budget and achieve your financial dreams',
      image: 'assets/goals.png',
    ),
    OnboardingData(
      title: 'Stay in Control',
      description: 'Get insights and stay on top of your finances',
      image: 'assets/control.png',
    ),
  ];
}

// Single Onboarding Page Widget
class OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  const OnboardingPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(data.image, height: 300, width: 300),
          const SizedBox(height: 40),
          Text(
            data.title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            data.description,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Authentication Wrapper
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.hasData ? const MainPage() : const SignUpView();
      },
    );
  }
}
