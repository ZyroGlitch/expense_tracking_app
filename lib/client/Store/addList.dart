import 'package:expense_tracking_app/client/firestoreDB/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import '../dashboard.dart';

class addList extends StatefulWidget {
  final String title;
  final String image;
  final String name;
  final Color boxBg;

  const addList({
    super.key,
    required this.title,
    required this.image,
    required this.name,
    required this.boxBg,
  });

  @override
  State<addList> createState() => _addListState();
}

class _addListState extends State<addList> {
  final user = FirebaseAuth.instance.currentUser!;

  TextEditingController memoTxt = TextEditingController();
  TextEditingController amountTxt = TextEditingController();

  int memoLength = 0;
  int amountLength = 0;
  DateTime? pickedDateTime;
  var isStored = true;

  // Alert Dialog
  void showModal(bool status) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ),
            ],
          ),
        ],
        title: Text(
          status ? 'Success' : 'Error',
          style: TextStyle(
            color: status ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        contentPadding: EdgeInsets.all(20),
        content: Text(
          status ? 'List added successfully.' : 'Failed to store the list!',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // DateTime Picker Dialog
  void showDateTimePickerDialog() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          // Combine date and time
          pickedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  // Store Financial Records
  void storeFinancialRecords(String type, String description, int amount,
      String category, DateTime date) async {
    try {
      // Store Data in the Firestore Database
      String autoID = randomAlphaNumeric(20);

      Map<String, dynamic> addCategoryMap = {
        'ID': autoID,
        'userID': user.uid,
        'type': type,
        'description': description,
        'amount': amount,
        'category': category,
        'image': widget.image.toString(),
        'boxShadow': widget.boxBg.toString(),
        'date': date.toIso8601String(),
      };

      await DatabaseMethods().addCategoryList(addCategoryMap, autoID);

      // ----------------------------------------

      // Store Data in the Realtime Database
      final DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref("financialRecords");

      // Store the user data in Firebase
      databaseReference.child(autoID).set({
        'ID': autoID,
        'userID': user.uid,
        'type': type,
        'description': description,
        'amount': amount,
        'category': category,
        'image': widget.image.toString(),
        'boxShadow': widget.boxBg.toString(),
        'date': date.toIso8601String(), // Store DateTime in ISO 8601 format
      });

      setState(() {
        isStored = true;
      });
    } on Exception catch (e) {
      print("Add list can't store data $e");
      setState(() {
        isStored = false;
      });
    }

    showModal(isStored);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text(widget.title),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.boxBg,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Image.asset(
                        widget.image,
                        width: 30,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: 20),

                    // Category
                    Text(
                      widget.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Memo Input
                TextField(
                  controller: memoTxt,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Memo',
                    prefixIcon: Icon(Icons.edit),
                    suffixIcon: IconButton(
                      onPressed: () {
                        memoTxt.clear();
                        setState(() {
                          memoLength = 0;
                        });
                      },
                      icon: Icon(Icons.clear),
                    ),
                    counterText: '', // Hide counter text
                  ),
                  maxLength: 40,
                  onChanged: (value) {
                    setState(() {
                      memoLength = memoTxt.text.length;
                    });
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${memoLength.toString()} / 40',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Amount Input
                TextField(
                  controller: amountTxt,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Amount',
                    prefixIcon: Icon(Icons.paid),
                    suffixIcon: IconButton(
                      onPressed: () {
                        amountTxt.clear();
                        setState(() {
                          amountLength = 0;
                        });
                      },
                      icon: Icon(Icons.clear),
                    ),
                    counterText: '', // Hide counter text
                  ),
                  maxLength: 10,
                  onChanged: (value) {
                    setState(() {
                      amountLength = amountTxt.text.length;
                    });
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${amountLength.toString()} / 10',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // DateTime Picker
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selected date: ',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    Text(
                      pickedDateTime != null
                          ? '${pickedDateTime!.month}/${pickedDateTime!.day}/${pickedDateTime!.year} ${pickedDateTime!.hour}:${pickedDateTime!.minute}'
                          : 'No date selected',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Choose Date Button
                ElevatedButton.icon(
                  onPressed: showDateTimePickerDialog,
                  icon: Icon(Icons.calendar_month),
                  label: Text('Choose Date'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size.fromHeight(50),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Add List Button
                ElevatedButton(
                  onPressed: () {
                    try {
                      // Ensure amount can be parsed to an integer
                      int amount = int.parse(amountTxt.text);

                      if (pickedDateTime != null) {
                        storeFinancialRecords(
                          widget.title,
                          memoTxt.text,
                          amount,
                          widget.name,
                          pickedDateTime!,
                        );

                        // Clear all fields after storing
                        setState(() {
                          memoTxt.clear();
                          amountTxt.clear();
                          pickedDateTime = null;
                        });
                      } else {
                        print("Please select a date and time.");
                      }
                    } catch (e) {
                      print("Invalid input for amount: $e");
                    }
                  },
                  child: Text('ADD LIST'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size.fromHeight(50),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
