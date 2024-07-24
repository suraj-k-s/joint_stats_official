import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:joint_stats_official/haq.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyValuesPage extends StatefulWidget {
  const MyValuesPage({super.key});

  @override
  State<MyValuesPage> createState() => _MyValuesPageState();
}

class EmsOption {
  final int value;
  final String label;

  EmsOption({required this.value, required this.label});
}

class _MyValuesPageState extends State<MyValuesPage> {
  int? selectedESR;
  int? selectedEMS;
  int pghValue1 = 1;
  int pghValue2 = 1;
  int vasValue = 1;
  String? checkupId;
  bool _checkupLoader = true;

  List<int> esrOptions = [
    1,
    10,
    20,
    30,
    40,
    50,
    60,
    70,
    80,
    90,
    100,
    110,
    120,
    130,
    140,
    150
  ];

  List<EmsOption> emsOptions = [
    EmsOption(value: 0, label: '0 (<5 Min)'),
    EmsOption(value: 1, label: '1 (5-10)'),
    EmsOption(value: 2, label: '2 (10-15)'),
    EmsOption(value: 3, label: '3 (15-20)'),
    EmsOption(value: 4, label: '4 (20-25)'),
    EmsOption(value: 5, label: '5 (25-30)'),
    EmsOption(value: 6, label: '6 (>30 Max)')
  ];

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

  Future<void> nextPage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      checkupId = prefs.getString('checkupId');
      setState(() {
        _checkupLoader = false;
      });
      if (checkupId == null) {
        throw Exception("No checkup id");
      }
      await FirebaseFirestore.instance
          .collection('checkup')
          .doc(checkupId)
          .update({
        'esr': selectedESR,
        'ems': selectedEMS,
        'pgh1': pghValue1,
        'pgh2': pghValue2,
        'vas': vasValue,
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
        MaterialPageRoute(builder: (context) => const HAQ()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Values'),
        actions: [
          if (selectedEMS != '' &&
              selectedESR != '' &&
              vasValue != 0 &&
              pghValue1 != 0)
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                nextPage();
              },
            ),
        ],
      ),
      body: _checkupLoader
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'ESR',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        DropdownButton<int>(
                          value: selectedESR,
                          onChanged: (int? newValue) {
                            setState(() {
                              selectedESR = newValue;
                            });
                          },
                          items: esrOptions
                              .map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 8),
                        Text(selectedESR != null ? selectedESR.toString() : ''),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'EMS',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        DropdownButton<EmsOption>(
                          value: selectedEMS != null
                              ? emsOptions.firstWhere(
                                  (option) => option.value == selectedEMS,
                                  orElse: () => EmsOption(value: -1, label: ''),
                                )
                              : null,
                          onChanged: (EmsOption? newValue) {
                            setState(() {
                              selectedEMS = newValue?.value;
                            });
                          },
                          items: emsOptions.map<DropdownMenuItem<EmsOption>>(
                              (EmsOption option) {
                            return DropdownMenuItem<EmsOption>(
                              value: option,
                              child: Text(option.label),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 8),
                        Text(selectedEMS != null ? selectedEMS.toString() : ''),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'PGH (Today)',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _buildEmojiRating(pghValue1),
                            Expanded(
                              child: Slider(
                                value: pghValue1.toDouble(),
                                min: 1,
                                max: 10,
                                divisions: 9,
                                onChanged: (double newValue) {
                                  setState(() {
                                    pghValue1 = newValue.round();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(pghValue1.toString()),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'PGH (6 Months ago)',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _buildEmojiRating(pghValue2),
                            Expanded(
                              child: Slider(
                                value: pghValue2.toDouble(),
                                min: 1,
                                max: 10,
                                divisions: 9,
                                onChanged: (double newValue) {
                                  setState(() {
                                    pghValue2 = newValue.round();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(pghValue2.toString()),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'VAS',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _buildEmojiRating(vasValue),
                            Expanded(
                              child: Slider(
                                value: vasValue.toDouble(),
                                min: 1,
                                max: 10,
                                divisions: 9,
                                onChanged: (double newValue) {
                                  setState(() {
                                    vasValue = newValue.round();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(vasValue.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
