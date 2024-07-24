import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:joint_stats_official/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  int depressionValue = 0;
  int fatigueValue = 0;
  int painValue = 0;
  String? checkupId;
  bool _checkupLoader = true;

  Future<void> nextPage() async {
    double radaiValue=0.0;
    double dasValue=0.0;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      checkupId = prefs.getString('checkupId');
      setState(() {
        _checkupLoader = false;
      });
      try {
        if (checkupId == null) {
          throw Exception("No checkup id");
        }

        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('checkup')
            .doc(checkupId)
            .get();

        if (doc.exists) {
          radaiValue = (doc['pgh2'] +
                  ((doc['tjc'] * 10) / 28 +
                      doc['vas'] +
                      doc['pgh1'] +
                      doc['ems'])) /
              5;
          print("RADAI: ${radaiValue.toString()}");

          dasValue = 0.56 * sqrt(doc['tjc']) +
              0.28 * sqrt(doc['sjc']) +
              0.70 * log(doc['esr']) +
              0.014 * doc['pgh1'];
          print("DAS: ${dasValue.toString()}");
        } else {
          throw Exception("Document does not exist");
        }
      } catch (e) {
        print("Error fetching checkup values: $e");
      }
      if (checkupId == null) {
        throw Exception("No checkup id");
      }
      await FirebaseFirestore.instance
          .collection('checkup')
          .doc(checkupId)
          .update({
        'mood': depressionValue,
        'fatigue': fatigueValue,
        'pain': painValue,
        'radai': radaiValue,
        'das': dasValue,
      });
      Fluttertoast.showToast(
        msg: 'Values Updated',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ResultPage()),
      );
    } catch (e) {
      setState(() {
        _checkupLoader = true;
      });
      Fluttertoast.showToast(
        msg: 'Values Updatation failed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      print("Error going to next page: $e");
    }
  }

  Widget _buildEmojiRating(int value) {
    String emoji = '😊';
    if (value >= 6) {
      emoji = '😔';
    } else if (value >= 3 && value < 6) {
      emoji = '😐';
    }
    return Text(
      emoji,
      style: const TextStyle(fontSize: 40),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mood'),
          actions: [
            IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  nextPage();
                }),
          ],
        ),
        body: _checkupLoader
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildMoodSection(
                      title: 'Depression/Mood Change',
                      value: depressionValue,
                      onChanged: (newValue) {
                        setState(() {
                          depressionValue = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildMoodSection(
                      title: 'Fatigue',
                      value: fatigueValue,
                      onChanged: (newValue) {
                        setState(() {
                          fatigueValue = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildMoodSection(
                      title: 'Pain',
                      value: painValue,
                      onChanged: (newValue) {
                        setState(() {
                          painValue = newValue;
                        });
                      },
                    ),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }

  Widget _buildMoodSection({
    required String title,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildEmojiRating(value),
            Expanded(
              child: Slider(
                value: value.toDouble(),
                min: 0,
                max: 9,
                divisions: 9,
                onChanged: (double newValue) {
                  onChanged(newValue.round());
                },
              ),
            ),
          ],
        ),
        Text(value.toString()),
        const SizedBox(
          height: 8,
        ),
        const Divider()
      ],
    );
  }
}
