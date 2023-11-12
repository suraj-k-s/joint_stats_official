import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = 'Loading...';
  String email = 'Loading...';
  String profileImageUrl = 'assets/anonymous.jpg'; // Default image path

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      userDoc.get().then((documentSnapshot) {
        if (documentSnapshot.exists) {
          final userData = documentSnapshot.data();
          setState(() {
            name = userData?['name'] ?? 'Name Not Found';
            email = userData?['email'] ?? 'Email Not Found';
            // Update the profileImageUrl only if it's available in the user data.
            if (userData?['profileImageUrl'] != null) {
              profileImageUrl = userData?['profileImageUrl'];
            }
            nameController.text = name;
            emailController.text = email;
          });
        }
      }).catchError((error) {
        // Handle any potential errors
        print('Error retrieving user data: $error');
      });
    }
  }

  void updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      userDoc.update({
        'name': nameController.text,
        'email': emailController.text,
      }).then((_) async {
        // Update the local state with the new data.
        setState(() {
          name = nameController.text;
          email = emailController.text;
        });

        // Handle updating the profile picture here (if needed).
        if (_selectedImage != null) {
          final storage = FirebaseStorage.instance;
          final Reference storageRef =
              storage.ref().child('user_profile_images/$userId.jpg');
          final UploadTask uploadTask =
              storageRef.putFile(File(_selectedImage!.path));

          await uploadTask.whenComplete(() async {
            final imageUrl = await storageRef.getDownloadURL();
            setState(() {
              profileImageUrl = imageUrl;
            });
            userDoc.update({
              'profileImageUrl': imageUrl,
            });
          });
        }

        // Show a success message or navigate to another page.
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Profile updated successfully'),
        ));
      }).catchError((error) {
        print('Error updating user data: $error');
        // Handle the error.
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error updating profile: $error'),
        ));
      });
    }
  }

  XFile? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = XFile(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            // Navigate back to the dashboard or home page.
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Profile Picture with Edit Button
            GestureDetector(
              onTap: () {
                _pickImage(); // Open image picker
              },
              child: CircleAvatar(
                radius: 80,
                backgroundImage: _selectedImage != null
                    ? FileImage(File(_selectedImage!.path))
                    : (profileImageUrl != null
                        ? NetworkImage(profileImageUrl)
                        : AssetImage('assets/anonymous.jpg') as ImageProvider),
                child: Icon(Icons.edit),
              ),
            ),

            SizedBox(height: 20),
            // Registration Details with Edit Buttons
            ListTile(
              title: Text('Name: $name'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Handle editing the name field.
                  nameController.text =
                      name; // Initialize the field with current value.
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Edit Name'),
                        content: TextField(
                          controller: nameController,
                          decoration: InputDecoration(hintText: 'New Name'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              updateProfile();
                              Navigator.of(context).pop();
                            },
                            child: Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            ListTile(
              title: Text('Email: $email'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Handle editing the email field.
                  emailController.text =
                      email; // Initialize the field with the current value.
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Edit Email'),
                        content: TextField(
                          controller: emailController,
                          decoration: InputDecoration(hintText: 'New Email'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              updateProfile();
                              Navigator.of(context).pop();
                            },
                            child: Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            // Add more details and edit buttons as needed.
            SizedBox(height: 20),
            // Update Button
            ElevatedButton(
              onPressed: () {
                // Handle updating user data.
                updateProfile();
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
