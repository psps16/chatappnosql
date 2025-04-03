import 'package:chatappnosql/components/my_app_bar.dart';
import 'package:chatappnosql/components/my_button.dart';
import 'package:chatappnosql/pages/blocked_users_page.dart';
import 'package:chatappnosql/services/auth/auth_service.dart';
import 'package:chatappnosql/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void logout() {
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // APPEARANCE SECTION
            Container(
              decoration: isDarkMode
                  ? ThemeProvider.neoBrutalistDecorationDark
                  : ThemeProvider.neoBrutalistDecoration,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "APPEARANCE",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Dark Mode",
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        Switch(
                          value: isDarkMode,
                          onChanged: (value) => themeProvider.toggleTheme(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ABOUT SECTION
            Container(
              decoration: isDarkMode
                  ? ThemeProvider.neoBrutalistDecorationDark
                  : ThemeProvider.neoBrutalistDecoration,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "ABOUT",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Neo Brutalist Chat App",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Version 1.0.0",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "A minimalist chat application with a neo-brutalist design aesthetic.",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // LOGOUT BUTTON
            GestureDetector(
              onTap: logout,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black : Colors.red,
                  border: Border.all(
                    color: isDarkMode ? Colors.red : Colors.black,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode ? Colors.red : Colors.black,
                      offset: const Offset(4, 4),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Text(
                  "Logout",
                  style: TextStyle(
                    color: isDarkMode ? Colors.red : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}