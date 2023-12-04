import 'package:flutter/material.dart';
import 'package:joint_stats_official/result.dart';

class MoodPage extends StatefulWidget {
  @override
  _MoodPageState createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  int depressionValue = 0;
  int fatigueValue = 0;
  int painValue = 0;

  Widget _buildEmojiRating(int value) {
    String emoji = '😊';
    if (value < 3) {
      emoji = '😔';
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
        title: Text('Mood'),
        actions: [
            IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ResultPage()),
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
            _buildMoodSection(
              title: 'Depression/Mood Change',
              value: depressionValue,
              onChanged: (newValue) {
                setState(() {
                  depressionValue = newValue;
                });
              },
            ),
            SizedBox(height: 16),
            _buildMoodSection(
              title: 'Fatigue',
              value: fatigueValue,
              onChanged: (newValue) {
                setState(() {
                  fatigueValue = newValue;
                });
              },
            ),
            SizedBox(height: 16),
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
      ),
    );
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
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
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
        SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: (String newValue) {
            onChanged(int.tryParse(newValue) ?? 0);
          },
        ),
        SizedBox(height: 8),
        Text(value.toString()),
      ],
    );
  }
}
