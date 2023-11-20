import 'package:flutter/material.dart';
import 'package:joint_stats_official/pass.dart';

class HAQ extends StatefulWidget {
  const HAQ({Key? key}) : super(key: key);

  @override
  State<HAQ> createState() => _HAQState();
}

class _HAQState extends State<HAQ> {
  List<Question> questions = [];
  int sum = 0;
  bool showSum = false;

  @override
  void initState() {
    super.initState();
    questions = getQuestions();
    setState(() {
      
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('H A Q'),
        actions: [
          IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Pass()),
                );
              }),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'H  A  Q',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: List.generate(
                  6,
                  (index) {
                    if (index == 5) {
                      return const DataColumn(
                        label: Text('Score'),
                      );
                    } else if (index == 0) {
                      return const DataColumn(
                        label: Text('Questions'),
                      );
                    } else {
                      return DataColumn(
                        label: Text('${index - 1}'),
                      );
                    }
                  },
                ),
                rows: List.generate(
                  questions.length,
                  (index) => DataRow(
                    cells: List.generate(
                      6,
                      (cellIndex) {
                        if (cellIndex == 5) {
                          return DataCell(
                            Text('${questions[index].answer ?? ""}'),
                          );
                        } else if (cellIndex == 1 ||
                            cellIndex == 2 ||
                            cellIndex == 3 ||
                            cellIndex == 4) {
                          return DataCell(
                            Radio<int>(
                              value: cellIndex - 1,
                              groupValue: questions[index].answer,
                              onChanged: (value) {
                                selectAnswer(index, value);
                              },
                            ),
                          );
                        } else {
                          return DataCell(
                            Tooltip(
                              message: questions[index].value,
                              child: Text(
                                '${questions[index].question}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
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
          ElevatedButton(
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
          if (showSum)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'D.I: ${(sum / 12).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
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
