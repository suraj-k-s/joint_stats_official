import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Final Results'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow('ESR', 8.5),
            _buildResultRow('DAS 28 (ESR)', 6.3),
            _buildResultRow('HAQ', 7.2),
            _buildResultRow('RADAI', 5.1),
            _buildResultRow('PASS', 6.8),
            _buildResultRow('PASS (MODIFIED)', 7.5),
            _buildResultRow('MOOD CHANGE (VAS)', 9.2),
            _buildResultRow('PAIN (VAS)', 8.4),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle download action
              },
              child: Text('Download'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            flex: 7,
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: value / 10, // Assuming max value is 10
                child: Container(
                  decoration: BoxDecoration(
                    color: _getColor(value),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              value.toStringAsFixed(1),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor(double value) {
    // Customize color based on value ranges or thresholds
    // For example:
    if (value <= 5) {
      return Colors.green;
    } else if (value > 5 && value <= 7.5) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}
