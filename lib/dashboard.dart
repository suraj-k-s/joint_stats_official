import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:joint_stats_official/login_page.dart';
import 'package:joint_stats_official/sjc.dart';
import 'package:joint_stats_official/user_profile.dart';
import 'package:joint_stats_official/viewresult.dart';
import 'package:lottie/lottie.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String profileImageUrl = 'assets/anonymous.jpg';
  String userName = '';

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<Map<String, String>> fetchProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    final String userId = user!.uid;
    String imageUrl = 'assets/anonymous.jpg'; // Set default image
    String userName = 'Anonymous';
    print(userId);
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    try {
      final documentSnapshot = await userDoc.get();
      if (documentSnapshot.exists) {
        print('hi');
        final userData = documentSnapshot.data();
        if (userData != null) {
          if (userData['profileImageUrl'] != null) {
            imageUrl = userData['profileImageUrl'];
          }
          if (userData['name'] != null) {
            userName = userData['name'];
            print(userName);
          }
        }
      }
    } catch (error) {
      // Handle any potential errors
      print('Error retrieving user data: $error');
    }

    return {'imageUrl': imageUrl, 'userName': userName, 'uid': userId};
  }

  Future<void> loadProfileData() async {
    final profileData = await fetchProfileData();
    setState(() {
      profileImageUrl = profileData['imageUrl']!;
      userName = profileData['userName']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 237, 242),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'JointStats',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight
                              .w600, // Use FontWeight.w600 for semibold
                          fontFamily:
                              'Poppins', // Use the font family name defined in pubspec.yaml
                        ),
                      ),
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          fontWeight: FontWeight
                              .w500, // Use FontWeight.w600 for semibold
                          fontFamily: 'Poppins',
                          color: Colors.blueAccent,
                        ),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // Show a dropdown menu when the profile icon is tapped
                      _showProfilePopupMenu(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue,
                          width: 1.5,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage:
                            profileImageUrl != "assets/anonymous.jpg"
                                ? NetworkImage(profileImageUrl)
                                : AssetImage(profileImageUrl) as ImageProvider,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Hello,',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight
                                      .w500, // Use FontWeight.w600 for semibold
                                  fontFamily: 'Poppins',
                                  color: Color.fromRGBO(68, 138, 255, 1),
                                ),
                              ),
                              Text(
                                userName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight
                                      .w600, // Use FontWeight.w600 for semibold
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      Colors.blueAccent),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const SJC()),
                                  );
                                },
                                label: const Text(
                                  'Start Scan',
                                  style: TextStyle(color: Colors.white),
                                ),
                                icon: const Icon(
                                  Icons.search_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            child: Lottie.asset('assets/Body-Check.json',
                                fit: BoxFit.fill, height: 150),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Previous Scanning',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight
                                  .w500, // Use FontWeight.w600 for semibold
                              fontFamily: 'Poppins',
                              color: Color.fromRGBO(68, 138, 255, 1),
                            ),
                          ),
                          const Divider(),
                          FutureBuilder<Map<String, String>>(
                            future: fetchProfileData(),
                            builder: (BuildContext context,
                                AsyncSnapshot<Map<String, String>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  final profileData = snapshot.data!;
                                  final String userId = profileData['uid']!;
                                  return _buildStreamBuilder(userId);
                                } else {
                                  return const Center(
                                    child: Text('Error fetching profile data'),
                                  );
                                }
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreamBuilder(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('checkup')
          .where('userid', isEqualTo: userId)
          .where('status', isEqualTo: 1)
          .orderBy('date', descending: true)
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(28.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Text('No previous data found');
        }
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var checkupData =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            final String checkupId = snapshot.data!.docs[index].id;
            final String remark = checkupData['remark'];
            final String date = checkupData['date'];
            final String time = checkupData['time'];
            final int fatigue = checkupData['fatigue'];
            final int mood = checkupData['mood'];
            final int pain = checkupData['pain'];
            final double emoji = (fatigue + mood + pain) / 3;
            print("Emoji: $emoji");
            IconData emojiIcon;
            Color emojiColor;

            if (emoji > 5) {
              emojiIcon = Icons.sentiment_very_satisfied;
              emojiColor = Colors.green;
            } else if (emoji >= 4 && emoji <= 5) {
              emojiIcon = Icons.sentiment_neutral;
              emojiColor = Colors.orange;
            } else {
              emojiIcon = Icons.sentiment_very_dissatisfied;
              emojiColor = Colors.red;
            }

            return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewResult(id: checkupId),
                      ));
                },
                leading: Icon(
                  emojiIcon,
                  color: emojiColor,
                  size: 28,
                ),
                title: Text(
                  remark == '' ? "No remark added" : remark,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("$date | $time"),
                trailing: IconButton(
                    onPressed: () {
                      deleteCheckup(checkupId);
                    },
                    icon: const Icon(Icons.delete_outlined)));
          },
        );
      },
    );
  }

  Future<void> deleteCheckup(String checkupId) async {
    try {
      await FirebaseFirestore.instance
          .collection('checkup')
          .doc(checkupId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Checkup deleted successfully')),
      );
    } catch (e) {
      print('Error deleting checkup: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete checkup')),
      );
    }
  }

  void _showProfilePopupMenu(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final Offset iconPosition = overlay.localToGlobal(
      const Offset(
          0, kToolbarHeight), // Adjust Y offset to place it below the icon
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
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
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
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pop(context); // Close the menu
                // Navigate to the login page or perform any other necessary action
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Login()));
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
