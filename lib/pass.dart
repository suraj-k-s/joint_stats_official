import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:joint_stats_official/emoji.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pass extends StatefulWidget {
  const Pass({Key? key}) : super(key: key);

  @override
  State<Pass> createState() => _PassState();
}

class _PassState extends State<Pass> {
  bool selectedYes1 = false;
  bool selectedNo1 = false;
  bool selectedYes2 = false;
  bool selectedNo2 = false;
  int? pass;
  int? mpass;
  String? checkupId;
  bool _checkupLoader = true;

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
          .update({'pass': pass, 'mpass': mpass});
      Fluttertoast.showToast(
        msg: 'PASS Updated',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MoodPage()),
      );
    } catch (e) {
      setState(() {
        _checkupLoader = true;
      });
      Fluttertoast.showToast(
        msg: 'PASS Updatation failed',
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
          title: const Text('Pass'),
          actions: [
            if (pass != null && mpass != null)
              IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    nextPage();
                  }),
          ],
        ),
        body: _checkupLoader
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Pass',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      " Considering all the different ways your diseases is affecting you, if you were to stay in this state for the next few months do you consider your present state satisfactory?",
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
                          elevation: WidgetStateProperty.all(0),
                          alignment: Alignment.center,
                          side: WidgetStateProperty.all(
                            const BorderSide(
                                width: 1, color: Color(0xff4338CA)),
                          ),
                          padding:
                              WidgetStateProperty.all(const EdgeInsets.only(
                            right: 75,
                            left: 75,
                            top: 12.5,
                            bottom: 12.5,
                          )),
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (selectedYes1) {
                                return Colors.blue;
                              } else {
                                return Colors.transparent;
                              }
                            },
                          ),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          )),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedYes1 = true;
                            selectedNo1 = false;
                            pass = 1;
                          });
                        },
                        child: const Text(
                          "Yes",
                          style:
                              TextStyle(color: Color(0xff4338CA), fontSize: 16),
                        ),
                      ),
                      OutlinedButton(
                        style: ButtonStyle(
                          elevation: WidgetStateProperty.all(0),
                          alignment: Alignment.center,
                          side: WidgetStateProperty.all(
                            const BorderSide(
                                width: 1, color: Color(0xff4338CA)),
                          ),
                          padding:
                              WidgetStateProperty.all(const EdgeInsets.only(
                            right: 75,
                            left: 75,
                            top: 12.5,
                            bottom: 12.5,
                          )),
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (selectedNo1) {
                                return Colors.blue;
                              } else {
                                return Colors.transparent;
                              }
                            },
                          ),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          )),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedYes1 = false;
                            selectedNo1 = true;
                            pass = 0;
                          });
                        },
                        child: const Text(
                          "No",
                          style:
                              TextStyle(color: Color(0xff4338CA), fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Modified Pass',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Do you feel the same as your pre diagnosis state of health?",
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
                          elevation: WidgetStateProperty.all(0),
                          alignment: Alignment.center,
                          side: WidgetStateProperty.all(
                            const BorderSide(
                                width: 1, color: Color(0xff4338CA)),
                          ),
                          padding:
                              WidgetStateProperty.all(const EdgeInsets.only(
                            right: 75,
                            left: 75,
                            top: 12.5,
                            bottom: 12.5,
                          )),
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (selectedYes2) {
                                return Colors.blue;
                              } else {
                                return Colors.transparent;
                              }
                            },
                          ),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          )),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedYes2 = true;
                            selectedNo2 = false;
                            mpass = 1;
                          });
                        },
                        child: const Text(
                          "Yes",
                          style:
                              TextStyle(color: Color(0xff4338CA), fontSize: 16),
                        ),
                      ),
                      OutlinedButton(
                        style: ButtonStyle(
                          elevation: WidgetStateProperty.all(0),
                          alignment: Alignment.center,
                          side: WidgetStateProperty.all(
                            const BorderSide(
                                width: 1, color: Color(0xff4338CA)),
                          ),
                          padding:
                              WidgetStateProperty.all(const EdgeInsets.only(
                            right: 75,
                            left: 75,
                            top: 12.5,
                            bottom: 12.5,
                          )),
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (selectedNo2) {
                                return Colors.blue;
                              } else {
                                return Colors.transparent;
                              }
                            },
                          ),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          )),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedYes2 = false;
                            selectedNo2 = true;
                            mpass = 0;
                          });
                        },
                        child: const Text(
                          "No",
                          style:
                              TextStyle(color: Color(0xff4338CA), fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()));
  }
}
