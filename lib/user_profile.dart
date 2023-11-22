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
              profileImageUrl = imageUrl; // Update profileImageUrl with new URL
            });
            userDoc.update({
              'profileImageUrl': imageUrl,
            });
          });
        }

        // Show a success message or navigate to another page.
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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

 String? selectedAge;

  List<String> generateAgeOptions() {
    List<String> ageOptions = [];
    for (int age = 1; age <= 100; age++) {
      ageOptions.add(age.toString());
    }
    return ageOptions;
  }

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
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
                    : (profileImageUrl != "assets/anonymous.jpg"
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
                        title: const Text('Edit Name'),
                        content: TextField(
                          controller: nameController,
                          decoration: InputDecoration(hintText: 'New Name'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
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
            const SizedBox(height: 20.0),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Gender",
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    alignment: Alignment.center,
                    side: MaterialStateProperty.all(const BorderSide(
                        width: 1, color: Color(0xff4338CA))),
                    padding: MaterialStateProperty.all(const EdgeInsets.only(
                        right: 75, left: 75, top: 12.5, bottom: 12.5)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0))),
                  ),
                  onPressed: () {
                    // Handle male gender selection
                  },
                  child: const Icon(Icons.male),
                ),
                OutlinedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    alignment: Alignment.center,
                    side: MaterialStateProperty.all(const BorderSide(
                        width: 1, color: Color(0xff4338CA))),
                    padding: MaterialStateProperty.all(const EdgeInsets.only(
                        right: 75, left: 75, top: 12.5, bottom: 12.5)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0))),
                  ),
                  onPressed: () {
                    // Handle female gender selection
                  },
                  child: const Icon(Icons.female),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            
            // Add more details and edit buttons as needed.
            SizedBox(height: 20),
            const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Age",
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedAge,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAge = newValue;
                      });
                    },
                    items: generateAgeOptions().map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Duration of RA",
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedAge,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAge = newValue;
                      });
                    },
                    items: generateAgeOptions().map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Appt(Previous)",
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Appt(Next)",
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select Date'),
                  ),
                ],
              ),
            
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
