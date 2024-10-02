import 'package:expense_tracking_app/client/Store/addList.dart';
import 'package:expense_tracking_app/components/category_component.dart';
import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: double
                      .infinity, // Set width to fill the entire screen width
                  child: Stack(
                    children: [
                      // Background image
                      Positioned.fill(
                        child: Image.asset(
                          'assets/background.png',
                          fit: BoxFit
                              .cover, // Ensures the image fits and covers the container
                        ),
                      ),
                      // Overlay widgets (Text or other widgets)

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Categories',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Income',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => addList(
                                title: 'Income',
                                image: 'assets/salary.png',
                                name: 'Salary',
                                boxBg: Color.fromARGB(255, 87, 145, 87),
                              ),
                            ),
                          );
                        },
                        child: categoryComponent(
                          image: 'assets/salary.png',
                          name: 'Salary',
                          boxBg: Color.fromARGB(255, 87, 145, 87),
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Text(
                            'Expenses',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => addList(
                                title: 'Expense',
                                image: 'assets/home.png',
                                name: 'Rent',
                                boxBg: Color.fromARGB(255, 58, 150, 150),
                              ),
                            ),
                          );
                        },
                        child: categoryComponent(
                          image: 'assets/home.png',
                          name: 'Rent',
                          boxBg: Color.fromARGB(255, 58, 150, 150),
                        ),
                      ),
                      SizedBox(height: 24),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => addList(
                                title: 'Expense',
                                image: 'assets/food.png',
                                name: 'Food',
                                boxBg: Color.fromARGB(255, 231, 188, 237),
                              ),
                            ),
                          );
                        },
                        child: categoryComponent(
                          image: 'assets/food.png',
                          name: 'Food',
                          boxBg: Color.fromARGB(255, 231, 188, 237),
                        ),
                      ),
                      SizedBox(height: 24),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => addList(
                                title: 'Expense',
                                image: 'assets/cloth.png',
                                name: 'Cloth',
                                boxBg: Color.fromARGB(255, 208, 200, 255),
                              ),
                            ),
                          );
                        },
                        child: categoryComponent(
                          image: 'assets/cloth.png',
                          name: 'Cloth',
                          boxBg: Color.fromARGB(255, 208, 200, 255),
                        ),
                      ),
                      SizedBox(height: 24),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => addList(
                                title: 'Expense',
                                image: 'assets/health.png',
                                name: 'Health',
                                boxBg: Color.fromARGB(255, 255, 207, 207),
                              ),
                            ),
                          );
                        },
                        child: categoryComponent(
                          image: 'assets/health.png',
                          name: 'Health',
                          boxBg: Color.fromARGB(255, 255, 207, 207),
                        ),
                      ),
                      SizedBox(height: 24),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => addList(
                                title: 'Expense',
                                image: 'assets/electricity.png',
                                name: 'Electricity',
                                boxBg: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          );
                        },
                        child: categoryComponent(
                          image: 'assets/electricity.png',
                          name: 'Electricity',
                          boxBg: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      SizedBox(height: 24),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => addList(
                                title: 'Expense',
                                image: 'assets/education.png',
                                name: 'Education',
                                boxBg: Color.fromARGB(255, 224, 212, 212),
                              ),
                            ),
                          );
                        },
                        child: categoryComponent(
                          image: 'assets/education.png',
                          name: 'Education',
                          boxBg: Color.fromARGB(255, 224, 212, 212),
                        ),
                      ),
                      SizedBox(height: 24),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => addList(
                                title: 'Expense',
                                image: 'assets/transportation.png',
                                name: 'Transportation',
                                boxBg: Color.fromARGB(255, 1, 57, 9),
                              ),
                            ),
                          );
                        },
                        child: categoryComponent(
                          image: 'assets/transportation.png',
                          name: 'Transportation',
                          boxBg: Color.fromARGB(255, 1, 57, 9),
                        ),
                      ),
                      SizedBox(height: 24),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => addList(
                                title: 'Expense',
                                image: 'assets/travel.png',
                                name: 'Travel',
                                boxBg: Color.fromARGB(255, 255, 227, 178),
                              ),
                            ),
                          );
                        },
                        child: categoryComponent(
                          image: 'assets/travel.png',
                          name: 'Travel',
                          boxBg: Color.fromARGB(255, 255, 227, 178),
                        ),
                      ),
                      SizedBox(height: 24),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => addList(
                                title: 'Expense',
                                image: 'assets/repair.png',
                                name: 'Repair',
                                boxBg: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          );
                        },
                        child: categoryComponent(
                          image: 'assets/repair.png',
                          name: 'Repair',
                          boxBg: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      SizedBox(height: 24),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => addList(
                                title: 'Expense',
                                image: 'assets/telephone.png',
                                name: 'Telephone',
                                boxBg: Color.fromARGB(255, 105, 148, 97),
                              ),
                            ),
                          );
                        },
                        child: categoryComponent(
                          image: 'assets/telephone.png',
                          name: 'Telephone',
                          boxBg: Color.fromARGB(255, 105, 148, 97),
                        ),
                      ),
                    ],
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
