import 'package:chatappnosql/services/auth/auth_service.dart';
import 'package:chatappnosql/services/chat/chat_service.dart';
import 'package:chatappnosql/themes/theme_provider.dart';
import 'package:flutter/material.dart';

class BlockedUsersPage extends StatelessWidget {
  const BlockedUsersPage({super.key});

  void _showUnblockBox(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Unblock User"),
        content: const Text("Are you sure you want to unblock this user?"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: Colors.black, width: 2),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: ThemeProvider.primaryYellow,
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(2, 2),
                  blurRadius: 0,
                ),
              ],
            ),
            child: TextButton(
              onPressed: () {
                final chatService = ChatService();
                chatService.unblockUser(userId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('User Unblocked!'),
                    backgroundColor: ThemeProvider.primaryYellow,
                    shape: Border(
                      top: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                );
              },
              child: const Text(
                'Unblock',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ChatService chatService = ChatService();
    final AuthService authService = AuthService();
    String userId = authService.getCurrentUser()!.uid;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("BLOCKED USERS"),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Blocked Users",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: ThemeProvider.neoBrutalistDecoration,
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: chatService.getBlockedUsersStream(userId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error loading users',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final blockedUsers = snapshot.data ?? [];

                    if (blockedUsers.isEmpty) {
                      return Center(
                        child: Text(
                          'No blocked users',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: blockedUsers.length,
                      itemBuilder: (context, index) {
                        final user = blockedUsers[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(color: Colors.black, width: 2),
                            ),
                          ),
                          child: ListTile(
                            onTap: () => _showUnblockBox(context, user['uid']),
                            title: Text(
                              user['email'] ?? 'Unknown User',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: ThemeProvider.primaryYellow,
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              child: const Text(
                                'Unblock',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}