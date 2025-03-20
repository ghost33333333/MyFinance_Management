import 'package:finance/main_page.dart';
import 'package:finance/provider/category_provider.dart';
import 'package:finance/provider/transactionProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if the app is running on the web and initialize Firebase accordingly
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDVpS3Xfyc4J-c9zjjGzxs5AjNpXdQdvPs",
          authDomain: "finance-tracker-b17af.firebaseapp.com",
          projectId: "finance-tracker-b17af",
          storageBucket: "finance-tracker-b17af.firebasestorage.app",
          messagingSenderId: "480580024190",
          appId: "1:480580024190:web:a72db8416f9b6c2643652f"),
    );
  } else {
    await Firebase.initializeApp();
  }
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool hasSeenOnboarding = prefs.getBool('onboarding_complete') ?? false;
  
  runApp(
    MultiProvider(
      providers: [ 
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: MyApp(showOnboarding: !hasSeenOnboarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;

  const MyApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: showOnboarding ? const OnboardingScreen() : const AuthWrapper(),
    );
  }
}
