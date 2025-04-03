import 'package:chatappnosql/services/auth/auth_service.dart';
import 'package:chatappnosql/themes/theme_provider.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  // email and pw text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  // tap method
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  // register method
  void register(BuildContext context) {
    final auth = AuthService();
    // make sure passwords match
    if (_pwController.text == _confirmPwController.text) {
      try {
        auth.signUpWithEmailAndPassword(
          _emailController.text,
          _pwController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(color: Colors.black, width: 2),
            ),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Passwords don't match!"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Colors.black, width: 2),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            // Register Text
            Text(
              "Register",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 50),
            // Create account message
            Text(
              "Create Account",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              "Sign up to get started",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 50),
            // Email field
            Container(
              decoration: ThemeProvider.neoBrutalistDecoration,
              margin: const EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            // Password field
            Container(
              decoration: ThemeProvider.neoBrutalistDecoration,
              margin: const EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: _pwController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            // Confirm Password field
            Container(
              decoration: ThemeProvider.neoBrutalistDecoration,
              margin: const EdgeInsets.only(bottom: 30),
              child: TextField(
                controller: _confirmPwController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm your password",
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            // Register button
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: ThemeProvider.primaryYellow,
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => register(context),
                  child: Center(
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            // Login now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Login Now',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
