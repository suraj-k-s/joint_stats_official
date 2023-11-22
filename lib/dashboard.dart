import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:joint_stats_official/emoji.dart';
import 'package:joint_stats_official/my_values.dart';
import 'package:joint_stats_official/result.dart';
import 'package:joint_stats_official/sjc.dart';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section 1: Button with plus icon
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to the SJC page when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SJC()),
                );
              },
              icon: Icon(Icons.add),
              label: Text('Click to Upload Data'),
            ),
          ),
          Divider(),
          // Section 2: Scrollable list of data
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with your data count
              itemBuilder: (context, index) {
                // Sample data for demonstration
                final DateTime currentDate = DateTime.now();
                final String formattedDate =
                    '${currentDate.day}/${currentDate.month}/${currentDate.year}';
                final String formattedTime =
                    '${currentDate.hour}:${currentDate.minute}';
                final String emoji = '😊';
                final String details = 'Details for item $index';

                return ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        formattedTime,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  title: Text('$emoji Item $index'),
                  subtitle: Text(details),
                  // Add onTap logic if needed
                  onTap: () {
                    // Your onTap logic here
                  },
                );
              },
            ),
          ),
        ],
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
