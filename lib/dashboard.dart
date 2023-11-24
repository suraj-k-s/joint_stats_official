import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:joint_stats_official/login_page.dart';
import 'package:joint_stats_official/sjc.dart';
import 'package:joint_stats_official/user_profile.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
    String profileImageUrl = 'assets/anonymous.jpg'; // Set initial value here

 @override
void initState() {
  super.initState();
  // Fetch profile image URL on init
  fetchProfileImageUrl().then((imageUrl) {
    setState(() {
      profileImageUrl = imageUrl;
    });
  });
}

Future<String> fetchProfileImageUrl() async {
  final user = FirebaseAuth.instance.currentUser;
  final userId = user?.uid;
  String imageUrl = 'assets/anonymous.jpg'; // Set default image

  if (userId != null) {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    try {
      final documentSnapshot = await userDoc.get();
      if (documentSnapshot.exists) {
        final userData = documentSnapshot.data();
        if (userData != null && userData['profileImageUrl'] != null) {
          imageUrl = userData['profileImageUrl'];
        }
      }
    } catch (error) {
      // Handle any potential errors
      print('Error retrieving user data: $error');
    }
  }
  return imageUrl;
}

  @override
  Widget build(BuildContext context) {
      
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
              backgroundImage: profileImageUrl != "assets/anonymous.jpg"
                  ? NetworkImage(profileImageUrl)
                  : AssetImage(profileImageUrl) as ImageProvider,
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
              FirebaseAuth.instance.signOut().then((value) {
              Navigator.pop(context); // Close the menu
              // Navigate to the login page or perform any other necessary action
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Login()));
            }).catchError((error) {
              print('Error logging out: $error');
            });
            },
          ),
        ),
      ],
    );
  }
}
