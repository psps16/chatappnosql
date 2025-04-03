import 'package:chatappnosql/pages/settings_page.dart';
import 'package:chatappnosql/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Distribute items evenly
        children: [
          Column(children: [
            // Header (Logo and Email)
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.message,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Consumer<AuthService>(
                    builder: (context, authService, child) {
                      return Text(
                        authService.getCurrentUser()?.email ?? 'Not signed in',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Home list tile
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                leading: const Icon(Icons.home),
                title: const Text('H O M E'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                },
              ),
            ),

            // Settings list tile
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('S E T T I N G S'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
            ),
          ]),

          // Logout list tile (Bottom)
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('L O G O U T'),
              onTap: () => logout(context), 
            ),
          ),
        ],
      ),
    );
  }
}