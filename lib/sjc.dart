import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:joint_stats_official/tjc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SJC extends StatefulWidget {
  const SJC({super.key});

  @override
  State<SJC> createState() => _SJCState();
}

class _SJCState extends State<SJC> {
  String? checkupId;
  bool _checkupLoader = false;
  List<int> selectedPoints = [];

  @override
  void initState() {
    super.initState();
    _addCheckup();
  }

  Future<void> _addCheckup() async {
    if (_checkupLoader) return; // Ensure checkup is added only once

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      String formattedTime = DateFormat('HH:mm').format(now);

      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('checkup').add({
        'userid': user.uid,
        'date': formattedDate,
        'time': formattedTime,
        'status': 0,
      });

      // Store the document ID in local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('checkupId', docRef.id);
      print('Checkup added successfully with ID: ${docRef.id}');

      setState(() {
        _checkupLoader = true;
        checkupId = docRef.id;
      });
    } catch (e) {
      print('Error adding checkup: $e');
    }
  }

  Future<void> nextPage() async {
    try {
      setState(() {
        _checkupLoader = false;
      });
      if (checkupId == null) {
        throw Exception("No checkup id");
      }
      await FirebaseFirestore.instance.collection('checkup').doc(checkupId).update({
        'sjc': selectedPoints.length
      });
      Fluttertoast.showToast(
        msg: 'Swollen Joint Count Updated',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TJC()),
      );
    } catch (e) {
      setState(() {
        _checkupLoader = true;
      });
      Fluttertoast.showToast(
        msg: 'Swollen Joint Count Updatation failed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      print("Error going to next page: $e");
    }
  }

  List<Point> points = [
    // Right
    Point(
        id: 1, x: 74, y: 107, size: 27, color: Colors.green), // shoulder ready
    Point(
        id: 2, x: 48.6, y: 161.4, size: 27, color: Colors.green), // elbow Ready
    Point(id: 3, x: 27, y: 208.5, size: 27, color: Colors.green), // wrist ready
    Point(
        id: 4, x: 59.5, y: 231, size: 10, color: Colors.green), // thumb 1 ready
    Point(
        id: 5,
        x: 82.5,
        y: 238.5,
        size: 10,
        color: Colors.green), // thumb 2 ready
    Point(
        id: 6, x: 49.5, y: 249, size: 10, color: Colors.green), // index 1 ready
    Point(
        id: 7, x: 49.5, y: 273, size: 10, color: Colors.green), // index 2 Ready
    Point(
        id: 8,
        x: 37,
        y: 255.5,
        size: 10,
        color: Colors.green), // middle 1 ready
    Point(
        id: 9,
        x: 37,
        y: 279.5,
        size: 10,
        color: Colors.green), // middle 2 ready
    Point(
        id: 10, x: 23, y: 276.5, size: 10, color: Colors.green), // ring 2 ready
    Point(
        id: 11,
        x: 22.8,
        y: 252.5,
        size: 10,
        color: Colors.green), // ring 1 ready
    Point(
        id: 12,
        x: 12.5,
        y: 243,
        size: 10,
        color: Colors.green), // pinky 1 ready
    Point(
        id: 13,
        x: 12.3,
        y: 267,
        size: 10,
        color: Colors.green), // pinky 2 ready
    Point(
        id: 14, x: 85.5, y: 281.5, size: 27, color: Colors.green), // knee ready
    // Left
    Point(
        id: 15,
        x: 207,
        y: 107,
        size: 27,
        color: Colors.green), // shoulder ready
    Point(id: 16, x: 232, y: 161, size: 27, color: Colors.green), // elbow ready
    Point(
        id: 17, x: 254, y: 208.5, size: 27, color: Colors.green), // wrist ready
    Point(
        id: 18, x: 238, y: 231, size: 10, color: Colors.green), // thumb 1 ready
    Point(
        id: 19,
        x: 215.5,
        y: 238.5,
        size: 10,
        color: Colors.green), // thumb 2 ready
    Point(
        id: 20, x: 248, y: 249, size: 10, color: Colors.green), // index 1 ready
    Point(
        id: 21, x: 248, y: 273, size: 10, color: Colors.green), // index 2 ready
    Point(
        id: 22,
        x: 261,
        y: 255.5,
        size: 10,
        color: Colors.green), // middle 1 ready
    Point(
        id: 23,
        x: 261,
        y: 279.5,
        size: 10,
        color: Colors.green), // middle 2 ready
    Point(
        id: 24,
        x: 275,
        y: 252.5,
        size: 10,
        color: Colors.green), // ring 1 ready
    Point(
        id: 25,
        x: 275,
        y: 276.5,
        size: 10,
        color: Colors.green), // ring 2 ready
    Point(
        id: 26,
        x: 285.5,
        y: 243,
        size: 10,
        color: Colors.green), // pinky 1 ready
    Point(
        id: 27,
        x: 285.5,
        y: 267,
        size: 10,
        color: Colors.green), // pinky 2 ready
    Point(
        id: 28, x: 195, y: 281.5, size: 27, color: Colors.green), // knee ready
  ];

  void handlePointClick(int id) {
    setState(() {
      points = points.map((point) {
        return point.id == id ? point.copyWith(color: Colors.red) : point;
      }).toList();
      if (!selectedPoints.contains(id)) {
        selectedPoints.add(id);
        print('Point clicked: $id');
        print('Clicked points: $selectedPoints');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Adjust the width and height to match your image size
    const double imageWidth = 350;
    const double imageHeight = 350;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Swollen Joint Count (0–28)"),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              nextPage();
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: InteractiveViewer(
        minScale: 0.1,
        maxScale: 5.0,
        child: Center(
          child: Stack(
            children: [
              _checkupLoader
                  ? Stack(
                      children: [
                        SizedBox(
                          width: imageWidth,
                          height: imageHeight,
                          child: Image.asset(
                            'assets/Body.png',
                            width: imageWidth,
                            height: imageHeight,
                            fit: BoxFit.fill,
                          ),
                        ),
                        for (var point in points)
                          Positioned(
                            left: point.x *
                                (imageWidth / 350), // Scale the x position
                            top: point.y *
                                (imageHeight / 350), // Scale the y position
                            child: GestureDetector(
                              onTap: () {
                                handlePointClick(point.id);
                              },
                              child: Container(
                                width: point.size,
                                height: point.size,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: point.color,
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class Point {
  final int id;
  final double x;
  final double y;
  final double size;
  final Color color;

  Point({
    required this.id,
    required this.x,
    required this.y,
    required this.size,
    this.color = Colors.green,
  });

  Point copyWith({
    int? id,
    double? x,
    double? y,
    double? size,
    Color? color,
  }) {
    return Point(
      id: id ?? this.id,
      x: x ?? this.x,
      y: y ?? this.y,
      size: size ?? this.size,
      color: color ?? this.color,
    );
  }
}
