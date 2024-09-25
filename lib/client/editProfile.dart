import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class editProfile extends StatefulWidget {
  const editProfile({
    super.key,
    required this.getFirstname,
    required this.getLastname,
    required this.getEmail,
  });

  final String? getFirstname;
  final String? getLastname;
  final String? getEmail;

  @override
  State<editProfile> createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();

  final user = FirebaseAuth.instance.currentUser!;

  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref("userCrendential");

  var selectedProfile;
  var getProfile;

  void showWideAvatarSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Center(child: Text('Select Profile Avatar')),
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.8, // 80% of screen width
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // First row of avatars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildAvatar(
                          context,
                          asset: 'assets/men1.jpg',
                          profileId: 1,
                          setState: setState,
                        ),
                        _buildAvatar(
                          context,
                          asset: 'assets/men2.jpg',
                          profileId: 2,
                          setState: setState,
                        ),
                        _buildAvatar(
                          context,
                          asset: 'assets/men3.jpg',
                          profileId: 3,
                          setState: setState,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Second row of avatars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildAvatar(
                          context,
                          asset: 'assets/women1.jpg',
                          profileId: 4,
                          setState: setState,
                        ),
                        _buildAvatar(
                          context,
                          asset: 'assets/women2.jpg',
                          profileId: 5,
                          setState: setState,
                        ),
                        _buildAvatar(
                          context,
                          asset: 'assets/women3.jpg',
                          profileId: 6,
                          setState: setState,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        child: Text('CANCEL'),
                      ),
                    ),
                    SizedBox(width: 20),
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
                          switch (selectedProfile) {
                            case 1:
                              setState(() {
                                getProfile = 'assets/men1.jpg';
                              });
                              break;
                            case 2:
                              setState(() {
                                getProfile = 'assets/men2.jpg';
                              });
                              break;
                            case 3:
                              setState(() {
                                getProfile = 'assets/men3.jpg';
                              });
                              break;
                            case 4:
                              setState(() {
                                getProfile = 'assets/women1.jpg';
                              });
                              break;
                            case 5:
                              setState(() {
                                getProfile = 'assets/women2.jpg';
                              });
                              break;
                            case 6:
                              setState(() {
                                getProfile = 'assets/women3.jpg';
                              });
                              break;
                            default:
                              setState(() {
                                getProfile = 'assets/default.jpg';
                              });
                          }
                          updateProfile();
                          Navigator.pop(context);
                        },
                        child: Text('SAVE'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildAvatar(BuildContext context,
      {required String asset,
      required int profileId,
      required StateSetter setState}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedProfile = profileId;
        });
      },
      child: CircleAvatar(
        backgroundColor:
            selectedProfile == profileId ? Colors.deepPurple : Colors.white,
        radius: 45,
        child: CircleAvatar(
          backgroundImage: AssetImage(asset),
          radius: 40,
        ),
      ),
    );
  }

  Future<void> fetchUserData() async {
    final snapshot = await databaseReference.child(user.uid).get();

    final userData = snapshot.value as Map<dynamic, dynamic>;
    setState(() {
      getProfile = userData['image'];
    });
  }

  void updateData() async {
    await databaseReference.child(user.uid).update({
      'firstname': firstname.text,
      'lastname': lastname.text,
    });
  }

  void updateProfile() async {
    await databaseReference.child(user.uid).update({
      'image': getProfile,
    });
  }

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
                  child: Text('CANCEL'),
                ),
              ),
            ],
          ),
        ],
        title: Text(
          status ? 'Success' : 'Failed',
          style: TextStyle(
            color: status ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        contentPadding: EdgeInsets.all(20),
        content: Text(
          status
              ? 'User data update successfully.'
              : 'User data update failed!',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  void initState() {
    firstname.text = widget.getFirstname ?? 'No Firstname';
    lastname.text = widget.getLastname ?? 'No Lastname';
    email.text = widget.getEmail ?? 'No Email';
    fetchUserData();
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    firstname.dispose();
    lastname.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fetchUserData();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text('EDIT PROFILE'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Stack(
                    children: [
                      InkWell(
                        onTap: () => showWideAvatarSelectionDialog(context),
                        child: CircleAvatar(
                          radius: 90,
                          backgroundColor: Colors.deepPurple,
                          child: CircleAvatar(
                            radius: 80,
                            backgroundImage: AssetImage(getProfile),
                          ),
                        ),
                      ),

                      // Positioned Pencil Icon
                      Positioned(
                        bottom: 4,
                        right: 10,
                        child: InkWell(
                          onTap: () => showWideAvatarSelectionDialog(context),
                          child: CircleAvatar(
                            radius: 18, // Size of the pencil button
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),

                  // Firstname
                  TextField(
                    controller: firstname,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Firstname',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Lastname
                  TextField(
                    controller: lastname,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Lastname',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Email
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.mail),
                    ),
                    readOnly: true,
                  ),
                  SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: () {
                      try {
                        // Call Update Method
                        updateData();
                        showModal(true);
                      } on Exception catch (e) {
                        showModal(false);
                      }
                    },
                    label: Text(
                      'Update',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(Icons.edit),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      minimumSize: Size.fromHeight(60),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
