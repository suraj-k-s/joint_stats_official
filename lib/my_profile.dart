import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String? selectedAge;

  List<String> generateAgeOptions() {
    List<String> ageOptions = [];
    for (int age = 1; age <= 100; age++) {
      ageOptions.add(age.toString());
    }
    return ageOptions;
  }

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> ageOptions = generateAgeOptions();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'My Profile',
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
                  "Gender",
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
                        elevation: MaterialStateProperty.all(0),
                        alignment: Alignment.center,
                        side: MaterialStateProperty.all(const BorderSide(
                            width: 1, color: Color(0xff4338CA))),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.only(
                                right: 75, left: 75, top: 12.5, bottom: 12.5)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)))),
                    onPressed: () {},
                    child: const Icon(Icons.male),
                  ),
                  OutlinedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        alignment: Alignment.center,
                        side: MaterialStateProperty.all(const BorderSide(
                            width: 1, color: Color(0xff4338CA))),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.only(
                                right: 75, left: 75, top: 12.5, bottom: 12.5)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)))),
                    onPressed: () {},
                    child: const Icon(Icons.female),
                  )
                ],
              ),
              const SizedBox(height: 20.0),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Age",
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedAge,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAge = newValue;
                      });
                    },
                    items: ageOptions.map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Duration of RA",
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedAge,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAge = newValue;
                      });
                    },
                    items: ageOptions.map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Appt",
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Appt",
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select Date'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
