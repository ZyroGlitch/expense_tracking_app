import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'firestoreDB/database.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final user = FirebaseAuth.instance.currentUser!;
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref("financialRecords");

  int currentBalanceAmount = 0;
  int income = 0;
  int expense = 0;

  Color boxDecoration(String category) {
    switch (category) {
      case 'Salary':
        return Color.fromARGB(255, 87, 145, 87);
      case 'Rent':
        return Color.fromARGB(255, 58, 150, 150);
      case 'Food':
        return Color.fromARGB(255, 231, 188, 237);
      case 'Cloth':
        return Color.fromARGB(255, 208, 200, 255);
      case 'Health':
        return Color.fromARGB(255, 255, 207, 207);
      case 'Electricity':
        return Color.fromARGB(255, 0, 0, 0);
      case 'Education':
        return Color.fromARGB(255, 224, 212, 212);
      case 'Transportation':
        return Color.fromARGB(255, 1, 57, 9);
      case 'Travel':
        return Color.fromARGB(255, 255, 227, 178);
      case 'Repair':
        return Color.fromARGB(255, 0, 0, 0);
      default:
        return Colors.black;
    }
  }

  String formatDate(String dateString) {
    try {
      DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat('MMMM dd \'at\' h:mma').format(parsedDate);
    } catch (e) {
      print('Date format error: $e');
      return 'Invalid date';
    }
  }

  Future<void> currentBalance() async {
    try {
      final dataSnapshot = await databaseReference
          .orderByChild('userID')
          .equalTo(user.uid)
          .once();

      // Check if the snapshot contains data
      if (dataSnapshot.snapshot.value != null) {
        final records = dataSnapshot.snapshot.value as Map<dynamic, dynamic>;

        // Initialize income and expense amounts to 0
        int totalIncome = 0;
        int totalExpense = 0;

        // Iterate through each record and separate income and expense amounts
        records.forEach((key, value) {
          if (value is Map) {
            final amount = value['amount'] as int?;
            final type = value['type'] as String?;

            if (amount != null && type != null) {
              if (type == 'Income') {
                totalIncome += amount;
              } else if (type == 'Expense') {
                totalExpense += amount;
              }
            }
          }
        });

        // Calculate the current balance
        final currentBalance = totalIncome - totalExpense;

        // Update the currentBalance variable
        setState(() {
          currentBalanceAmount = currentBalance;
        });

        print('Current Balance: $currentBalanceAmount');
      } else {
        print('No records found for user ID: ${user.uid}');
      }
    } catch (e) {
      print('Error retrieving balance: $e');
    }
  }

  Future<void> totalIncome() async {
    try {
      final dataSnapshot = await databaseReference
          .orderByChild('userID')
          .equalTo(user.uid)
          .once();

      // Check if the snapshot contains data
      if (dataSnapshot.snapshot.value != null) {
        final records = dataSnapshot.snapshot.value as Map<dynamic, dynamic>;

        // Initialize totalAmount to 0 before calculating the sum
        int total = 0;

        // Iterate through each record and sum the amount if the type is 'Income'
        records.forEach((key, value) {
          if (value is Map) {
            final type = value['type'] as String?;
            final amount = value['amount'] as int?;

            if (type != null && type == 'Income' && amount != null) {
              total += amount;
            }
          }
        });

        // Update the totalAmount variable
        setState(() {
          income = total;
        });

        print('Total Income Amount: $income');
      } else {
        print('No records found for user ID: ${user.uid}');
      }
    } catch (e) {
      print('Error retrieving balance: $e');
    }
  }

  Future<void> totalExpense() async {
    try {
      final dataSnapshot = await databaseReference
          .orderByChild('userID')
          .equalTo(user.uid)
          .once();

      // Check if the snapshot contains data
      if (dataSnapshot.snapshot.value != null) {
        final records = dataSnapshot.snapshot.value as Map<dynamic, dynamic>;

        // Initialize totalAmount to 0 before calculating the sum
        int total = 0;

        // Iterate through each record and sum the amount if the type is 'Income'
        records.forEach((key, value) {
          if (value is Map) {
            final type = value['type'] as String?;
            final amount = value['amount'] as int?;

            if (type != null && type == 'Expense' && amount != null) {
              total += amount;
            }
          }
        });

        // Update the totalAmount variable
        setState(() {
          expense = total;
        });

        print('Total Income Amount: $expense');
      } else {
        print('No records found for user ID: ${user.uid}');
      }
    } catch (e) {
      print('Error retrieving balance: $e');
    }
  }

  @override
  void initState() {
    currentBalance();
    totalIncome();
    totalExpense();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Call again the functions to realtime update
    currentBalance();
    totalIncome();
    totalExpense();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/background.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
                      Text(
                        'CURRENT BALANCE',
                        style: TextStyle(
                          color: Color.fromARGB(255, 227, 227, 227),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '\$${currentBalanceAmount.toStringAsFixed(0)}', // Show balance with 2 decimal places
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 46,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        DateFormat('MMMM dd, yyyy').format(DateTime.now()),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/income.png',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'INCOME',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                      Text(
                                        '\$${income.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/expense.png',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'EXPENSE',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                      Text(
                                        '\$${expense.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: FirebaseAnimatedList(
                query:
                    databaseReference.orderByChild('userID').equalTo(user.uid),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map<dynamic, dynamic> record =
                      snapshot.value as Map<dynamic, dynamic>;

                  String description =
                      record['description'] ?? 'No description';
                  String amount = record['amount']?.toString() ?? '0';
                  String image = record['image'] ?? '';
                  String category = record['category'] ?? 'Unknown';
                  String type = record['type'] ?? '';
                  String date = formatDate(record['date'] ?? '');

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              // Delete the specific record
                              databaseReference
                                  .child(snapshot.key!)
                                  .remove()
                                  .then((_) {
                                // Call functions to update balance and totals after deletion
                                currentBalance();
                                totalIncome();
                                totalExpense();
                              }).catchError((error) {
                                print('Failed to delete record: $error');
                              });
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: boxDecoration(category),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Image.asset(
                                    image,
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      description,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      date,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              '\$$amount',
                              style: TextStyle(
                                color: type == 'Income'
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
