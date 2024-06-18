import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:joint_stats_official/pass.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HAQ extends StatefulWidget {
  const HAQ({Key? key}) : super(key: key);

  @override
  State<HAQ> createState() => _HAQState();
}

class _HAQState extends State<HAQ> {
  List<Question> questions = [];
  int sum = 0;
  bool showSum = false;
  String? checkupId;
  bool _checkupLoader = true;

  @override
  void initState() {
    super.initState();
    questions = getQuestions();
    setState(() {});
  }

  List<Question> getQuestions() {
    return [
      Question(
          question: 'Question 1',
          answer: null,
          value: "Dress Yourself, include tying shoelaces and doing buttons ?"),
      Question(
          question: 'Question 2',
          answer: null,
          value: "Get in and out of bed ?"),
      Question(
          question: 'Question 3',
          answer: null,
          value: "Lift a full cup or glass to your mouth ?"),
      Question(
          question: 'Question 4',
          answer: null,
          value: "Walk outdoors on flat ground ?"),
      Question(
          question: 'Question 5',
          answer: null,
          value: "Wash and dry your entire body ?"),
      Question(
          question: 'Question 6',
          answer: null,
          value: "Squat in the toilet or sit crosslegged on the floor ?"),
      Question(
          question: 'Question 7',
          answer: null,
          value: "Bend down to pick up clothing off the floor ?"),
      Question(
          question: 'Question 8',
          answer: null,
          value: "Turn taps on and off ?"),
      Question(
          question: 'Question 9',
          answer: null,
          value: "Get in and out of autorickshaw/manual rickshaw/car"),
      Question(
          question: 'Question 10',
          answer: null,
          value: "Walk three kilometers"),
      Question(
          question: 'Question 11',
          answer: null,
          value: "shop in a vegetable market"),
      Question(
          question: 'Question 12',
          answer: null,
          value: "climb a flight of stairs ?")
    ];
  }

  void selectAnswer(int questionIndex, int? answerIndex) {
    setState(() {
      questions[questionIndex].answer = answerIndex;
    });
  }

  void calculateSum() {
    sum = 0;
    for (var question in questions) {
      if (question.answer != null) {
        sum += question.answer!;
      }
    }
  }

  bool allQuestionsAnswered() {
    for (var question in questions) {
      if (question.answer == null) {
        return false;
      }
    }
    return true;
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
      double di = sum / 12;
      await FirebaseFirestore.instance
          .collection('checkup')
          .doc(checkupId)
          .update({
        'di': di,
      });
      Fluttertoast.showToast(
        msg: 'HAQ Updated',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Pass()),
      );
    } catch (e) {
      setState(() {
        _checkupLoader = true;
      });
      Fluttertoast.showToast(
        msg: 'HAQ Updatation failed',
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
        title: const Text('H A Q'),
        actions: [
          if (showSum)
            IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  nextPage();
                }),
        ],
      ),
      body: _checkupLoader
          ? Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'H  A  Q',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Get the total width available for the table
                      final tableWidth = constraints.maxWidth;
                      // Define the widths for each column
                      final columnWidths = List.generate(5, (index) {
                        if (index == 0) {
                          return tableWidth *
                              0.22; // 40% of the table width for the Questions column
                        } else if (index == 4) {
                          return tableWidth *
                              0.2; // 20% of the table width for the Score column
                        } else {
                          return tableWidth *
                              0.18; // The rest 40% of the table width equally divided among the other columns
                        }
                      });

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: tableWidth),
                            child: DataTable(
                              columnSpacing: 0,
                              columns: List.generate(
                                5,
                                (index) {
                                  if (index == 4) {
                                    return const DataColumn(
                                      label: Text(
                                        'Score',
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  } else if (index == 0) {
                                    return const DataColumn(
                                      label: Text(
                                        'Questions',
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  } else {
                                    return DataColumn(
                                      label: SizedBox(
                                        width: columnWidths[index],
                                        child: Text(
                                          '${index - 1}',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                              rows: List.generate(
                                questions.length,
                                (index) => DataRow(
                                  cells: List.generate(
                                    5,
                                    (cellIndex) {
                                      if (cellIndex == 4) {
                                        return DataCell(
                                          Center(
                                            child: Text(
                                                '${questions[index].answer ?? ""}'),
                                          ),
                                        );
                                      } else if (cellIndex == 1 ||
                                          cellIndex == 2 ||
                                          cellIndex == 3) {
                                        return DataCell(
                                          SizedBox(
                                            width: columnWidths[cellIndex],
                                            child: Radio<int>(
                                              value: cellIndex - 1,
                                              groupValue:
                                                  questions[index].answer,
                                              onChanged: (value) {
                                                selectAnswer(index, value);
                                                setState(() {
                                                  showSum = false;
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                      } else {
                                        return DataCell(
                                          SizedBox(
                                            width: columnWidths[cellIndex],
                                            child: Tooltip(
                                              message: questions[index].value,
                                              child: Text(
                                                '${questions[index].question}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: showSum
                      ? Text(
                          'D.I: ${(sum / 12).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : ElevatedButton(
                          onPressed: allQuestionsAnswered()
                              ? () {
                                  calculateSum();
                                  setState(() {
                                    showSum = true;
                                  });
                                }
                              : null,
                          child: Text('Submit'),
                        ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class Question {
  String question;
  String value;
  int? answer;

  Question({required this.question, this.answer, required this.value});
}
