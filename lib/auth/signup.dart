import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController _confirmPasswordController = TextEditingController();

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
      setState(() => _isLoading = true);

      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        User? user = userCredential.user;

        if (user != null) {
          await FirebaseFirestore.instance.collection('user_info').doc(user.uid).set({
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
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTitle("Sign Up"),
                const SizedBox(height: 20),
                _buildForm(),
                const SizedBox(height: 30),
                _buildSignUpButton(),
                const SizedBox(height: 20),
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField("Full Name", _firstNameController, "Enter full name", false),
          _buildTextField("Email", _emailController, "Enter your email", false, keyboardType: TextInputType.emailAddress),
          _buildTextField("Phone Number", _phoneController, "Enter your phone number", false, keyboardType: TextInputType.phone, inputFormatter: FilteringTextInputFormatter.digitsOnly),
          _buildPasswordField("Password", _passwordController, "Enter your password"),
          _buildPasswordField("Confirm Password", _confirmPasswordController, "Re-enter your password", confirmPassword: true),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, bool obscureText,
      {TextInputType keyboardType = TextInputType.text, TextInputFormatter? inputFormatter}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatter != null ? [inputFormatter] : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, String hint, {bool confirmPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: confirmPassword ? !_isConfirmPasswordVisible : !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[200],
          suffixIcon: IconButton(
            icon: Icon(confirmPassword
                ? (_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off)
                : (_isPasswordVisible ? Icons.visibility : Icons.visibility_off)),
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
          if (value == null || value.isEmpty) return 'Please enter $label';
          if (value.length < 6) return 'Password must be at least 6 characters';
          if (confirmPassword && value != _passwordController.text) return 'Passwords do not match';
          return null;
        },
      ),
    );
  }

  Widget _buildSignUpButton() {
    return _isLoading
        ? const CircularProgressIndicator(color: Colors.blueAccent)
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _signUpWithEmailAndPassword,
            child: const Text("Sign Up", style: TextStyle(fontSize: 18)),
          );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Already have an account?", style: TextStyle(fontSize: 16)),
        TextButton(
          onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage())),
          child: const Text("Login", style: TextStyle(fontSize: 16, color: Colors.blueAccent)),
        ),
      ],
    );
  }
}
