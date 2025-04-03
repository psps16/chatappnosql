import 'package:chatappnosql/firebase_options.dart';
import 'package:chatappnosql/pages/settings_page.dart';
import 'package:chatappnosql/services/auth/auth_gate.dart';
import 'package:chatappnosql/services/auth/auth_service.dart';
import 'package:chatappnosql/themes/dark_mode.dart';
import 'package:chatappnosql/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(  // Use MultiProvider if you have multiple providers
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()), // Provide AuthService
        ChangeNotifierProvider(create: (context) => ThemeProvider()), // Provide ThemeProvider
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthGate(), //Use AuthGate for authentication flow
        theme: Provider.of<ThemeProvider>(context).themeData,  // Access theme here
        darkTheme: darkMode,                 // and/or provide darkTheme
        themeMode: Provider.of<ThemeProvider>(context).isDarkMode ? ThemeMode.dark : ThemeMode.light, //Set ThemeMode according to isDarkMode 
        // Define routes
        routes: {
          '/settings': (context) => const SettingsPage(),
        },
     );
  }
}