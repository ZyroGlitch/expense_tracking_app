import 'package:expense_tracking_app/auth/firebaseAuth.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../client/curveNavigationBar.dart';
import '../client/firestoreDB/database.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Controllers for the text fields
  TextEditingController firstnametxt = TextEditingController();
  TextEditingController lastnametxt = TextEditingController();
  TextEditingController emailtxt = TextEditingController();
  TextEditingController passwordtxt = TextEditingController();

  bool _obscureText = true; // Initially, the password is obscured

  @override
  void dispose() {
    firstnametxt.dispose();
    lastnametxt.dispose();
    emailtxt.dispose();
    passwordtxt.dispose();

    super.dispose();
  }

  final FirebaseAuthServices auth = FirebaseAuthServices();

  Future<void> signUp(BuildContext context) async {
    String firstname = firstnametxt.text;
    String lastname = lastnametxt.text;
    String email = emailtxt.text;
    String password = passwordtxt.text;

    // Show loading dialog
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Check if the email is already in use
      final authInstance = FirebaseAuth.instance;
      final emailExist = await authInstance.fetchSignInMethodsForEmail(email);

      if (emailExist.isNotEmpty) {
        Navigator.of(context).pop(); // Close the loading dialog
        showModal(
            context, 'Email already in use. Please choose another email.');
        return;
      }

      // Proceed with sign-up
      User? user = await auth.signUpWithEmailAndPassword(email, password);

      if (user != null) {
        // Store Data in the Firestore Database
        Map<String, dynamic> userInfoMap = {
          'ID': user.uid,
          'firstname': firstname,
          'lastname': lastname,
          'email': email,
          'image': 'assets/women1.png',
        };

        await DatabaseMethods().addUserDetails(userInfoMap, user.uid);

        // Initialize Database Connection
        final DatabaseReference databaseReference =
            FirebaseDatabase.instance.ref("userCrendential");

        // Store the user data in the Firebase Realtime Database
        await databaseReference.child(user.uid).set({
          'ID': user.uid,
          'firstname': firstname,
          'lastname': lastname,
          'email': email,
          'image': 'assets/default.jpg'
        });

        Navigator.of(context).pop(); // Close the loading dialog
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CustomCurvedNavigationBar(),
        ));
      } else {
        Navigator.of(context).pop(); // Close the loading dialog
        showModal(
            context, 'Email already in use. Please choose another email.');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      showModal(context, 'An error occurred: $e');
    }
  }

  // Alert Dialog
  Future<void> showModal(BuildContext context, String message) async {
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
                  child: Text('BACK'),
                ),
              ),
            ],
          ),
        ],
        title: Text(
          'Error',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        contentPadding: EdgeInsets.all(20),
        content: Text(
          message,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(height: 50),
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
              SizedBox(height: 40),

              //Firstname
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: firstnametxt,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Firstname',
                        prefixIcon: Icon(
                          Icons.account_circle,
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                    SizedBox(height: 20),

                    //Lastname
                    TextField(
                      controller: lastnametxt,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Lastname',
                        prefixIcon: Icon(
                          Icons.account_circle,
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                    SizedBox(height: 20),

                    //Email
                    TextField(
                      controller: emailtxt,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Email',
                        prefixIcon: Icon(
                          Icons.email,
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                    SizedBox(height: 20),

                    //Password
                    TextField(
                      controller: passwordtxt,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Password',
                        prefixIcon: Icon(
                          Icons.lock,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText =
                                  !_obscureText; // Toggle password visibility
                            });
                          },
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off, // Change icon
                          ),
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                    SizedBox(height: 40),

                    ElevatedButton(
                      onPressed: () {
                        signUp(context);

                        // Clear the textfields after storing the data
                        firstnametxt.clear();
                        lastnametxt.clear();
                        emailtxt.clear();
                        passwordtxt.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        fixedSize: Size(1000, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(15),
                        ),
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text('Sign Up'),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have a account?',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Login(),
                            ));
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
