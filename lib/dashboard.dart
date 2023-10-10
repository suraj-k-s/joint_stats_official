import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? userProfilePhotoUrl = FirebaseAuth.instance.currentUser?.photoURL;
    print(userProfilePhotoUrl);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          // User profile icon button
          GestureDetector(
            onTap: () {
              // Show a dropdown menu when the profile icon is tapped
              _showProfilePopupMenu(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                // You can use the user's profile picture here
                backgroundImage: AssetImage('assets/profile_image.png'),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to the Dashboard!'),
      ),
    );
  }

  void _showProfilePopupMenu(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          overlay.localToGlobal(Offset.zero, ancestor: overlay),
          overlay.localToGlobal(overlay.size.bottomRight(Offset.zero),
              ancestor: overlay),
        ),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              // Navigate to the profile page
              Navigator.pop(context); // Close the menu
              // Add your navigation logic here
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Implement your logout logic here
              Navigator.pop(context); // Close the menu
              // Add your logout logic here
            },
          ),
        ),
      ],
    );
  }
}
