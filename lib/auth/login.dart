// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:expense_tracking_app/auth/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../client/curveNavigationBar.dart';
import '../client/dashboard.dart';
import 'firebaseAuth.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailtxt = TextEditingController();
  TextEditingController passwordtxt = TextEditingController();
  bool _obscureText = true;

  late String errorMessage;
  late bool isError;

  @override
  void dispose() {
    emailtxt.dispose();
    passwordtxt.dispose();

    super.dispose();
  }

  // Alert Dialog
  void showModal() {
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
          'Login failed!',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  final FirebaseAuthServices auth = FirebaseAuthServices();
  void signIn() async {
    String email = emailtxt.text;
    String password = passwordtxt.text;

    // Show the loading dialog
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    User? user = await auth.signInWithEmailAndPassword(email, password);

    // Close the loading dialog before showing the next one
    Navigator.pop(context);

    if (user != null) {
      print('$email login successfully.');

      // Navigate to CustomCurvedNavigationBar if login is successful
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CustomCurvedNavigationBar(),
      ));
    } else {
      // Show the error modal
      showModal();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Image.asset(
                'assets/logo.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
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
                    SizedBox(height: 10),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        signIn();
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
                      child: Text('Login'),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have account?",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Register(),
                              ),
                            );
                          },
                          child: Text(
                            "Create new account",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.deepPurple,
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
          ),
        ],
      ),
    );
  }
}
