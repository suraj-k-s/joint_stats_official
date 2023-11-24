import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? selectedGender;
  String name = 'Loading...';
  String email = 'Loading...';
  String profileImageUrl = 'assets/anonymous.jpg'; 
  String? selectedAge;
  String? selectedDurationRA;
  DateTime? selectedPreviousDate;
  DateTime? selectedNextDate;

  

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
            selectedGender = userData?['gender'];
            selectedAge = userData?['age'];
            selectedDurationRA = userData?['durationOfRA'];
            final previousAppt = userData?['previousAppointment'];
            final nextAppt = userData?['nextAppointment'];

            if (previousAppt != null) {
              selectedPreviousDate = DateFormat('dd-MM-yyyy').parse(previousAppt);
            }
            if (nextAppt != null) {
              selectedNextDate = DateFormat('dd-MM-yyyy').parse(nextAppt);
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
  void updateSelectedGender(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  void updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

       await userDoc.update({
        'name': nameController.text,
        'email': emailController.text,
        'gender': selectedGender,
        'age': selectedAge,
        'durationOfRA': selectedDurationRA,
        'previousAppointment': selectedPreviousDate != null
            ? DateFormat('dd-MM-yyyy').format(selectedPreviousDate!)
            : null,
        'nextAppointment': selectedNextDate != null
            ? DateFormat('dd-MM-yyyy').format(selectedNextDate!)
            : null,
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


  List<String> generateAgeOptions() {
    List<String> ageOptions = [];
    for (int age = 1; age <= 100; age++) {
      ageOptions.add(age.toString());
    }
    return ageOptions;
  }

  DateTime? selectedDate;

  Future<DateTime?> _selectDate(BuildContext context) async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
  }
  String _formatDate(DateTime? date) {
    if (date != null) {
      return DateFormat('dd-MM-yyyy').format(date);
    }
    return 'Select Date';
  }

 Widget buildGenderButton(IconData icon, String gender) {
    return OutlinedButton(
      style: ButtonStyle(
        side: MaterialStateProperty.all(BorderSide(
          width: 1,
          color: selectedGender == gender ? Colors.blue : Color(0xff4338CA),
        )),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed) ||
                states.contains(MaterialState.selected)) {
              return Colors.blue.withOpacity(0.2);
            } else if (selectedGender == gender) {
              return Colors.blue.withOpacity(0.1);
            }
            return Colors.transparent;
          },
        ),
      ),
      onPressed: () {
        updateSelectedGender(gender);
      },
      child: Icon(icon),
    );
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
                buildGenderButton(Icons.male, 'male'), // Male button
                buildGenderButton(Icons.female, 'female'), // Female button
                buildGenderButton(Icons.transgender, 'others'), // Female button
              ],
            ),
            const SizedBox(height: 20.0),
            
            // Add more details and edit buttons as needed.
            SizedBox(height: 20),
            const SizedBox(height: 10.0),
             // Age
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Age                   ",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  DropdownButton<String>(
                    value: selectedAge,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAge = newValue;
                      });
                    },
                    items: generateAgeOptions()
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),

              // Duration of RA
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Duration of RA",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  DropdownButton<String>(
                    value: selectedDurationRA, // Use separate state variable
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDurationRA = newValue;
                      });
                    },
                    items: generateAgeOptions()
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
            // Appointment (Previous & Next)
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Appt(Previous)",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final DateTime? picked = await _selectDate(context);
                          if (picked != null) {
                            setState(() {
                              selectedPreviousDate = picked;
                            });
                          }
                        },
                        child: Text(
                          selectedPreviousDate != null
                              ? _formatDate(selectedPreviousDate)
                              : 'Select Date',
                        ),
                      ),
                    ],
                  ),

                  // Appointment (Next)
                  Column(
                    children: [
                      const Text(
                        "Appt(Next)",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final DateTime? picked = await _selectDate(context);
                          if (picked != null) {
                            setState(() {
                              selectedNextDate = picked;
                            });
                          }
                        },
                        child: Text(
                          selectedNextDate != null
                              ? _formatDate(selectedNextDate)
                              : 'Select Date',
                        ),
                      ),
                    ],
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
