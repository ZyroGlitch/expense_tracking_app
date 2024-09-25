import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../auth/login.dart';
import 'editProfile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser!;
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('userCrendential');

  final DatabaseReference dataRef =
      FirebaseDatabase.instance.ref('financialRecords');

  Color profileBtn = Colors.black;
  Color shipBtn = Colors.black;
  Color historyBtn = Colors.black;

  String firstname = '';
  String lastname = '';
  String email = '';
  String profile = 'assets/default.jpg';

  Future<void> fetchUserData() async {
    try {
      final snapshot = await databaseReference.child(user.uid).get();

      if (snapshot.exists) {
        final userData = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          firstname = userData['firstname'];
          lastname = userData['lastname'];
          email = userData['email'];
          profile = userData['image'];
        });
      } else {
        print('No user data found for user ID: ${user.uid}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  int expense = 0;
  Future<void> totalExpense() async {
    try {
      final dataSnapshot =
          await dataRef.orderByChild('userID').equalTo(user.uid).once();

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

        print('Total Expense Amount: $expense');
      } else {
        print('No records found for user ID: ${user.uid}');
      }
    } catch (e) {
      print('Error retrieving balance: $e');
    }
  }

  int income = 0;
  Future<void> totalIncome() async {
    try {
      final dataSnapshot =
          await dataRef.orderByChild('userID').equalTo(user.uid).once();

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

  @override
  void initState() {
    fetchUserData();
    totalExpense();
    totalIncome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Call function to update realtime
    fetchUserData();
    totalExpense();
    totalIncome();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          buildTop(),
          SizedBox(height: 100),
          buildContent(),
        ],
      ),
    );
  }

  Widget buildTop() => Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          buildCoverImage(),
          Positioned(
            top: 280 - 170 / 2,
            child: buildProfileImage(),
          ),
        ],
      );

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: Image.asset(
          'assets/profileCover.jpg',
          width: double.infinity,
          height: 280,
          fit: BoxFit.cover,
        ),
      );

  Widget buildProfileImage() => CircleAvatar(
        radius: 92,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 170 / 2,
          backgroundColor: Colors.deepPurple,
          backgroundImage: AssetImage(profile),
        ),
      );

  Widget buildContent() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                // Display user's name
                Text(
                  '$firstname $lastname',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Display user's email
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 20),
                // Income and Expense Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          '\$${income.toString()}', // Update dynamically if needed
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Income',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 50,
                      child: VerticalDivider(
                        color: Colors.grey,
                        thickness: 2,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          '\$${expense.toString()}', // Update dynamically if needed
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Expense',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Profile and Logout Buttons
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      // My Profile Button
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          color: profileBtn,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                profileBtn = Colors.purple;
                                shipBtn = Colors.black;
                                historyBtn = Colors.black;
                              });

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => editProfile(
                                    getFirstname: firstname,
                                    getLastname: lastname,
                                    getEmail: email,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.person, color: Colors.white),
                                      SizedBox(width: 20),
                                      Text(
                                        'My Profile',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.arrow_forward_ios,
                                      color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Logout Button
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          color: shipBtn,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                profileBtn = Colors.black;
                                shipBtn = Colors.purple;
                                historyBtn = Colors.black;
                              });

                              FirebaseAuth.instance.signOut();

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.logout, color: Colors.white),
                                      SizedBox(width: 20),
                                      Text(
                                        'Logout',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.arrow_forward_ios,
                                      color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
