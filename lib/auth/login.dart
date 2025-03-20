import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/main_page.dart';
import 'package:finance/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finance/auth/signup.dart';
import 'package:finance/auth/forgot.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => MainPage()),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Login failed')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final textStyle = GoogleFonts.itim(
      fontSize: media.width * 0.07,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: media.width * 0.06),
            child: Column(
              children: [
                SizedBox(height: media.height * 0.08),
                _buildHeader(textStyle),
                SizedBox(height: media.height * 0.04),
                _buildFormCard(media, textStyle),
                SizedBox(height: media.height * 0.03),
                _buildLoginButton(media, textStyle),
                SizedBox(height: media.height * 0.02),
                _buildSignUpLink(media),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(TextStyle textStyle) {
    return Text(
      "Welcome Back",
      style: textStyle.copyWith(fontSize: 32,fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 88, 145, 244)),
    );
  }

  Widget _buildFormCard(Size media, TextStyle textStyle) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(media.width * 0.05),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _emailController,
                hint: "Email",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty
                    ? 'Email required'
                    : !RegExp(r'\S+@\S+\.\S+').hasMatch(value)
                        ? 'Invalid email'
                        : null,
              ),
              SizedBox(height: media.height * 0.02),
              _buildTextField(
                controller: _passwordController,
                hint: "Password",
                icon: Icons.lock_outline,
                obscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
                validator: (value) => value!.isEmpty
                    ? 'Password required'
                    : value.length < 6
                        ? 'Password too short'
                        : null,
              ),
              _buildForgotPassword(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText, 
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, color: Colors.blueAccent) : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
      validator: validator,
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ForgotPassword()),
        ),
        child: Text(
          "Forgot Password?",
          style: GoogleFonts.itim(
            color: Colors.blueAccent,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(Size media, TextStyle textStyle) {
    return _isLoading
        ? CircularProgressIndicator(color: Colors.blueAccent)
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 6,
              minimumSize: Size(media.width * 0.7, 55),
            ),
            onPressed: _login,
            child: Ink(
              decoration: BoxDecoration(
                
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Login",
                  style: textStyle.copyWith(color: const Color.fromARGB(205, 6, 122, 255), fontSize: 20),
                ),
              ),
            ),
          );
  }

  Widget _buildSignUpLink(Size media) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account ? ",
          style: GoogleFonts.itim(fontSize: 16, color: Colors.black54),
        ),
        TextButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SignUpView()),
          ),
          child: Text(
            "Sign Up",
            style: GoogleFonts.itim(
              color: Colors.blueAccent,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}