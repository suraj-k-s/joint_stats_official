import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:joint_stats_official/user_profile.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? userProfilePhotoUrl = FirebaseAuth.instance.currentUser?.photoURL;

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
                backgroundImage: userProfilePhotoUrl != null
                    ? NetworkImage(
                        userProfilePhotoUrl) // Use the user's profile photo URL
                    : AssetImage('assets/anonymous.jpg')
                        as ImageProvider, // Placeholder image
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

    final Offset iconPosition = overlay.localToGlobal(
      Offset(0, kToolbarHeight), // Adjust Y offset to place it below the icon
      ancestor: overlay,
    );

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        iconPosition.dx + 140, // Adjust the left position as needed
        iconPosition.dy + 25.0, // Adjust the top position as needed
        iconPosition.dx + 0, // Adjust the right position as needed
        iconPosition.dy + 48.0, // Adjust the bottom position as needed
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
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
