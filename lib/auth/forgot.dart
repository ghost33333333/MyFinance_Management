import 'package:finance/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showSnackBar('Please enter your email');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSnackBar('Reset link sent to your email!');
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      _showSnackBar(e.code == 'user-not-found'
          ? 'No account found'
          : 'Something went wrong');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: message.contains('sent') ? Colors.green : Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: media.width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeader(),
              SizedBox(height: media.height * 0.03),
              _buildEmailField(media),
              SizedBox(height: media.height * 0.03),
              _buildResetButton(media),
              SizedBox(height: media.height * 0.02),
              _buildBackLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      "Forgot Password?",
      style: GoogleFonts.itim(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: Colors.blueAccent,
      ),
    );
  }

  Widget _buildEmailField(Size media) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: "Enter your email",
          prefixIcon: Icon(Icons.email_outlined, color: Colors.blueAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildResetButton(Size media) {
    return _isLoading
        ? CircularProgressIndicator(color: Colors.blueAccent)
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 4,
              minimumSize: Size(media.width * 0.7, 50),
            ),
            onPressed: _resetPassword,
            child: Text(
              "Send Reset Link",
              style: GoogleFonts.itim(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
  }

  Widget _buildBackLink() {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text(
        "Back to Login",
        style: GoogleFonts.itim(
          fontSize: 16,
          color: Colors.blueAccent,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}