import 'package:chatappnosql/pages/chat_page.dart';
import 'package:chatappnosql/services/chat/chat_service.dart';
import 'package:chatappnosql/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatService _chatService = ChatService();
  //final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _chatService.getUsersStreamExcludingBlocked().listen((usersData) {
      if (mounted) {
        setState(() {}); //Rebuild the UI
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("CHATS"),
        actions: [
          // Settings button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Conversations",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? ThemeProvider.darkGrey : Colors.white,
                  border: Border.all(
                    color: isDarkMode ? Colors.white : Colors.black,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode ? Colors.white : Colors.black,
                      offset: const Offset(4, 4),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: _buildUserList(isDarkMode),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(bool isDarkMode) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getUsersStreamExcludingBlocked(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error loading users",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color:
                  isDarkMode
                      ? ThemeProvider.darkModeAccent
                      : ThemeProvider.primaryYellow,
            ),
          );
        }

        final usersData = snapshot.data ?? [];

        if (usersData.isEmpty) {
          return Center(
            child: Text(
              "No users found",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: usersData.length,
          itemBuilder: (context, index) {
            final user = usersData[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 2),
              decoration: BoxDecoration(
                color: isDarkMode ? ThemeProvider.darkGrey : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: isDarkMode ? Colors.white : Colors.black,
                    width: 2,
                  ),
                ),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ChatPage(
                            receiverUserEmail: user['email'],
                            receiverUserID: user['uid'],
                          ),
                    ),
                  );
                },
                title: Text(
                  user['email'],
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
