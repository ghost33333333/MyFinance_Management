import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import '../main.dart'; // Import MainPage
import '../utils/constants.dart';
import 'login.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUpWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        User? user = userCredential.user;

        if (user != null) {
          // Store user data in Firestore
          await FirebaseFirestore.instance
              .collection('user_info')
              .doc(user.uid)
              .set({
            'first_name': _firstNameController.text.trim(),
            'phone_number': _phoneController.text.trim(),
            'email': _emailController.text.trim(),
            'role': 'user',
            'created_at': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign-up successful!')),
          );

          // Navigate to MainPage
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainPage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'An error occurred')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = screenWidth * 0.05;
    TextStyle textStyle = GoogleFonts.itim(
      color: Colors.black,
      fontSize: screenWidth > 600 ? 24 : 18,
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTitle("Registration", textStyle),
                _buildForm(),
                _buildSignUpButton(textStyle),
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title, TextStyle textStyle) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Colors.black.withOpacity(0.4), width: 2)),
      ),
      child: Text(title, style: textStyle),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
              "Full Name", _firstNameController, "Enter full name", false),
          _buildTextField(
            "Email:",
            _emailController,
            "Enter your email",
            false,
            keyboardType: TextInputType.emailAddress,
          ),
          _buildTextField(
            "Phone Number:",
            _phoneController,
            "Enter your phone number",
            false,
            keyboardType: TextInputType.phone,
            inputFormatter: FilteringTextInputFormatter.digitsOnly,
          ),
          _buildPasswordField(
              "Password:", _passwordController, "Enter your password"),
          _buildPasswordField("Confirm Password:", _confirmPasswordController,
              "Re-enter your password",
              confirmPassword: true),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      String hint, bool obscureText,
      {TextInputType keyboardType = TextInputType.text,
      TextInputFormatter? inputFormatter}) {
    return Column(
      children: [
        Row(
          children: [
            Text(label,
                style: GoogleFonts.itim(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500))
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
              color: secondaryLight, borderRadius: BorderRadius.circular(12)),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            inputFormatters: inputFormatter != null ? [inputFormatter] : null,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Please enter $label' : null,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPasswordField(
      String label, TextEditingController controller, String hint,
      {bool confirmPassword = false}) {
    return Column(
      children: [
        Row(
          children: [
            Text(label,
                style: GoogleFonts.itim(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500))
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
              color: secondaryLight, borderRadius: BorderRadius.circular(12)),
          child: TextFormField(
            controller: controller,
            obscureText: confirmPassword
                ? !_isConfirmPasswordVisible
                : !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(24),
              suffixIcon: IconButton(
                icon: Icon(
                  confirmPassword
                      ? (_isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off)
                      : (_isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                ),
                onPressed: () {
                  setState(() {
                    if (confirmPassword) {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    } else {
                      _isPasswordVisible = !_isPasswordVisible;
                    }
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              if (confirmPassword && value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSignUpButton(TextStyle textStyle) {
    return _isLoading
        ? const CircularProgressIndicator(color: secondaryLight)
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              backgroundColor: secondaryLight,
              fixedSize: const Size(109, 47),
            ),
            onPressed: _signUpWithEmailAndPassword,
            child: Text("Sign Up", style: textStyle),
          );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Already have an account? ",
            style: GoogleFonts.itim(
                color: const Color(0xFF3B82F6),
                fontSize: 18,
                fontWeight: FontWeight.w400)),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginPage()));
          },
          child: Text("Login",
              style: GoogleFonts.itim(
                  color: const Color(0xFF3B82F6),
                  fontSize: 18,
                  fontWeight: FontWeight.w400)),
        ),
      ],
    );
  }
}
