import 'package:chatappnosql/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:chatappnosql/themes/theme_provider.dart';

class LoginPage extends StatelessWidget {
  // email and pw text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwcontroller = TextEditingController();

  // tap method
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  //login
  void login(BuildContext context) async {
    //auth service
    final authService = AuthService();
    try {
      await authService.signInWithEmailAndPassword(
          _emailController.text, _pwcontroller.text);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString()),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(color: Colors.black, width: 2),
                ),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Login Text
                Text(
                  "Login",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 30),
                // Welcome Back message
                Text(
                  "Welcome Back",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  "Sign in to continue",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 30),
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
                  margin: const EdgeInsets.only(bottom: 30),
                  child: TextField(
                    controller: _pwcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                // Login button
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
                      onTap: () => login(context),
                      child: Center(
                        child: Text(
                          'Login',
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
                const SizedBox(height: 30),
                // Register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member? ',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: Text(
                        'Register Now',
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
