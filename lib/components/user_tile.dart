import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final Map<String, dynamic> userData;
  final void Function()? onTap; 

  const UserTile({
    super.key,
    required this.userData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile( // Use ListTile for a cleaner look
      title: Text(userData['email']),
      leading: const Icon(Icons.person),  // Add a leading icon
      onTap: onTap,                       // Attach the tap handler
    );
  }
}