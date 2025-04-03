import 'package:chatappnosql/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    // Define colors and styles based on mode
    Color bubbleColor;
    Color textColor;
    Color timestampColor;
    Border? border;
    List<BoxShadow>? boxShadow;

    if (isDarkMode) {
      bubbleColor = Colors.black;
      textColor = Colors.white;
      timestampColor = Colors.grey.shade400;
      Color borderColor = isCurrentUser ? Colors.white : ThemeProvider.darkModeAccent;
      border = Border.all(
        color: borderColor,
        width: 2,
      );
      boxShadow = [
        BoxShadow(
          color: borderColor,
          offset: const Offset(4, 4),
          blurRadius: 0,
        ),
      ];
    } else {
      // Light Mode Styles
      if (isCurrentUser) {
        bubbleColor = Colors.white; 
        textColor = Colors.black;
      } else {
        // Change friend's bubble color and text color in light mode
        bubbleColor = Colors.blue.shade200; // Lighter blue
        textColor = Colors.black; // Black text
      }
      timestampColor = isCurrentUser ? Colors.black54 : Colors.black54; // Keep timestamp color consistent maybe?
      border = Border.all(color: Colors.black, width: 2); 
      boxShadow = [
        const BoxShadow(
          color: Colors.black,
          offset: Offset(4, 4),
          blurRadius: 0,
        ),
      ];
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      decoration: BoxDecoration(
        color: bubbleColor,
        border: border,
        borderRadius: BorderRadius.circular(12),
        boxShadow: boxShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: TextStyle(
              color: textColor,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            timestamp,
            style: TextStyle(
              color: timestampColor,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}