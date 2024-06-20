import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:joint_stats_official/main.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class ViewResult extends StatefulWidget {
  const ViewResult({super.key, required this.id});
  final String id;

  @override
  State<ViewResult> createState() => _ViewResultState();
}

class _ViewResultState extends State<ViewResult> {
  double esr = 0;
  double esrLabel = 0;
  double haq = 0.0;
  double haqLabel = 0.0;
  double pass = 0.0;
  double mpass = 0.0;
  double das = 0.0;
  double dasLabel = 0.0;
  double radai = 0.0;
  double radaiLabel = 0.0;
  String? checkupId;
  bool _checkupLoader = false;

  @override
  void initState() {
    super.initState();
    checkupId = widget.id;
    result();
  }

  Future<void> result() async {
    try {
      if (checkupId == null) {
        throw Exception("No checkup id");
      }

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('checkup')
          .doc(checkupId)
          .get();

      if (doc.exists) {
        setState(() {
          esr = doc['esr'].toDouble();
          das = doc['das'].toDouble();
          haq = doc['di'].toDouble();
          radai = doc['radai'].toDouble();
          pass = doc['pass'].toDouble();
          mpass = doc['mpass'].toDouble();
          _checkupLoader = true;
        });
      } else {
        throw Exception("Document does not exist");
      }
    } catch (e) {
      print("Error fetching checkup values: $e");
    }
  }

  Future<void> _generatePdf(BuildContext context) async {
    // Request permission to access storage
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final pdf = pw.Document();

    pw.Widget buildPdfResultRow(String label, dynamic value) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
        child: pw.Row(
          children: [
            pw.Expanded(
              flex: 3,
              child: pw.Text(
                label,
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(width: 20),
            pw.Container(
              width: 300,
              height: 20,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey),
                borderRadius: pw.BorderRadius.circular(5),
              ),
              child: pw.Container(
                alignment: pw.Alignment.centerLeft,
                width: 300,
                child: pw.Container(
                  color: value == 1.0 ? PdfColors.green : PdfColors.red,
                  width: 300,
                  height: 20,
                ),
              ),
            ),
            pw.SizedBox(width: 10),
            pw.Flexible(
              fit: pw.FlexFit.tight,
              child: pw.Text(
                value is double ? value.toStringAsFixed(1) : value,
                overflow: pw.TextOverflow.span,
              ),
            ),
          ],
        ),
      );
    }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("My Final Results",
                  style: const pw.TextStyle(fontSize: 24)),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(
                        "ESR",
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.SizedBox(width: 20),
                    pw.Container(
                      width: 300,
                      height: 20,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey),
                        borderRadius: pw.BorderRadius.circular(5),
                      ),
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        width: 300,
                        child: pw.Container(
                          color: esr <= 20
                              ? PdfColors.green
                              : (esr <= 35
                                  ? PdfColors.yellow
                                  : (esr <= 50
                                      ? PdfColors.orange
                                      : PdfColors.red)),
                          width: ((esr*10)/15)*3,
                          height: 20,
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Flexible(
                      fit: pw.FlexFit.tight,
                      child: pw.Text(
                        esr.toStringAsFixed(1),
                        overflow: pw.TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(
                        "DAS 28 (ESR)",
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.SizedBox(width: 20),
                    pw.Container(
                      height: 20,
                      width: 300,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey),
                        borderRadius: pw.BorderRadius.circular(5),
                      ),
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        width: 300,
                        child: pw.Container(
                          color: das <= 2.6
                              ? PdfColors.green
                              : (das <= 3.1
                                  ? PdfColors.yellow
                                  : (das <= 5.1
                                      ? PdfColors.orange
                                      : PdfColors.red)),
                          width: ((das/6.2)*100)*3,
                          height: 20,
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Flexible(
                      fit: pw.FlexFit.tight,
                      child: pw.Text(
                        das.toStringAsFixed(1),
                        overflow: pw.TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(
                        "HAQ",
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.SizedBox(width: 20),
                    pw.Container(
                      height: 20,
                      width: 300,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey),
                        borderRadius: pw.BorderRadius.circular(5),
                      ),
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        width: 300,
                        child: pw.Container(
                          color: haq <= 1
                              ? PdfColors.green
                              : (haq <= 1.5
                                  ? PdfColors.yellow
                                  : PdfColors.red),
                          width: (haq * 50) * 3,
                          height: 20,
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Flexible(
                      fit: pw.FlexFit.tight,
                      child: pw.Text(
                        haq.toStringAsFixed(1),
                        overflow: pw.TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(
                        "RADAI",
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.SizedBox(width: 20),
                    pw.Container(
                      height: 20,
                      width: 300,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey),
                        borderRadius: pw.BorderRadius.circular(5),
                      ),
                      child: pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        width: 300,
                        child: pw.Container(
                          color: radai <= 2.2
                              ? PdfColors.green
                              : (radai <= 4.9
                                  ? PdfColors.yellow
                                  : PdfColors.red),
                          width: ((radai/9.2)*100)*3,
                          height: 20,
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Flexible(
                      fit: pw.FlexFit.tight,
                      child: pw.Text(
                        radai.toStringAsFixed(1),
                        overflow: pw.TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ),
              buildPdfResultRow('PASS', pass),
              buildPdfResultRow('PASS (MODIFIED)', mpass),
            ],
          );
        },
      ),
    );

    try {
      final downloadsDirectory = Directory('/storage/emulated/0/Download');
      if (!await downloadsDirectory.exists()) {
        await downloadsDirectory.create(recursive: true);
      }
      final file = File("${downloadsDirectory.path}/result-$checkupId.pdf");
      await file.writeAsBytes(await pdf.save());

      await showNotification(downloadsDirectory.path);

      Fluttertoast.showToast(
        msg: "PDF saved to Downloads",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      print("Error saving PDF: $e");
      Fluttertoast.showToast(
        msg: "Failed to save PDF",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> showNotification(String filePath) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'PDF Saved',
      'Your PDF has been saved successfully. Tap to open.',
      platformChannelSpecifics,
      payload: filePath,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Final Results'),
        ),
        body: _checkupLoader
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 3,
                              child: Text(
                                "ESR",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 6,
                              child: Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: ((esr * 10) / 150) /
                                      10, // Assuming max value is 10
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: esr <= 20
                                          ? Colors.green
                                          : (esr <= 35
                                              ? Colors.yellow
                                              : (esr <= 50
                                                  ? Colors.orange
                                                  : Colors.red)),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                esr.toStringAsFixed(1),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 3,
                              child: Text(
                                'DAS 28 (ESR)',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 6,
                              child: Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor:
                                      das / 10, // Assuming max value is 10
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: das <= 2.6
                                          ? Colors.green
                                          : (das <= 3.1
                                              ? Colors.yellow
                                              : (das <= 5.1
                                                  ? Colors.orange
                                                  : Colors.red)),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                das.toStringAsFixed(1),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 3,
                              child: Text(
                                'HAQ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 6,
                              child: Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: ((haq * 10) / 2) /
                                      10, // Assuming max value is 10
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: haq <= 1
                                          ? Colors.green
                                          : (haq <= 1.5
                                              ? Colors.yellow
                                              : Colors.red),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                haq.toStringAsFixed(1),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 3,
                              child: Text(
                                'RADAI',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 6,
                              child: Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor:
                                      radai / 10, // Assuming max value is 10
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: radai <= 2.2
                                          ? Colors.green
                                          : (radai <= 4.9
                                              ? Colors.yellow
                                              : Colors.red),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                radai.toStringAsFixed(1),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildResultShow('PASS', pass),
                      _buildResultShow('PASS (MODIFIED)', mpass),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _generatePdf(context);
                          },
                          style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.blueAccent),
                          ),
                          label: const Text(
                            'Download as PDF',
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: const Icon(
                            Icons.download_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: Lottie.asset(
                  'assets/splashScreen.json',
                  width: 300,
                  height: 600,
                  fit: BoxFit.fill,
                ),
              ));
  }

  Widget _buildResultShow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 6,
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 1, // Assuming max value is 10
                child: Container(
                  decoration: BoxDecoration(
                    color: value == 1.0 ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              value == 1.0 ? 'Yes' : 'No',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
