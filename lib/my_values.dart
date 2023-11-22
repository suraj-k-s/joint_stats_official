import 'package:flutter/material.dart';
import 'package:joint_stats_official/haq.dart';

class MyValuesPage extends StatefulWidget {
  @override
  _MyValuesPageState createState() => _MyValuesPageState();
}

class _MyValuesPageState extends State<MyValuesPage> {
  String? selectedESR;
  String? selectedEMS;
  int pghValue = 0;
  int vasValue = 0;

  List<String> esrOptions = [
    '0', '10', '20', '30', '40', '50', '60', '70', '80', '90', '100',
    '110', '120', '130', '140', '150'
  ];

  List<String> emsOptions = [
    '0 (<5 Min)', '1 (5-10)', '2 (10-15)', '3 (15-20)', '4 (20-25)', '5 (25-30)', '6 (>30 Max)'
  ];

  Widget _buildEmojiRating(int value) {
    String emoji = '😔';
    if (value < 3) {
      emoji = '😊';
    } else if (value >= 3 && value < 6) {
      emoji = '😐';
    }
    return Text(
      emoji,
      style: TextStyle(fontSize: 40),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Values'),
        actions: [
            IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HAQ()),
                  );
                }),
          ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'ESR',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                DropdownButton<String>(
                  value: selectedESR,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedESR = newValue;
                    });
                  },
                  items: esrOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 8),
                Text(selectedESR ?? ''),
              ],
            ),

            SizedBox(height: 20),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'EMS',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                DropdownButton<String>(
                  value: selectedEMS,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedEMS = newValue;
                    });
                  },
                  items: emsOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 8),
                Text(selectedEMS ?? ''),
              ],
            ),

            SizedBox(height: 20),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'PGH',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildEmojiRating(pghValue),
                    Expanded(
                      child: Slider(
                        value: pghValue.toDouble(),
                        min: 0,
                        max: 9,
                        divisions: 9,
                        onChanged: (double newValue) {
                          setState(() {
                            pghValue = newValue.round();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String value) {
                    setState(() {
                      pghValue = int.tryParse(value) ?? 0;
                    });
                  },
                ),
                SizedBox(height: 8),
                Text(pghValue.toString()),
              ],
            ),

            SizedBox(height: 20),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'VAS',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildEmojiRating(vasValue),
                    Expanded(
                      child: Slider(
                        value: vasValue.toDouble(),
                        min: 0,
                        max: 9,
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
                SizedBox(height: 8),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String value) {
                    setState(() {
                      vasValue = int.tryParse(value) ?? 0;
                    });
                  },
                ),
                SizedBox(height: 8),
                Text(vasValue.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
