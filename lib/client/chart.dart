import 'package:expense_tracking_app/components/chartList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  final user = FirebaseAuth.instance.currentUser!;
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref("financialRecords");

  int total = 0;
  double incomePercentage = 0;
  double expensePercentage = 0;
  int summation = 0;

  // Initialize variables for percentage
  double salaryPercentage = 0;
  double rentPercentage = 0;
  double foodPercentage = 0;
  double clothPercentage = 0;
  double healthPercentage = 0;
  double electricityPercentage = 0;
  double educationPercentage = 0;
  double transportationPercentage = 0;
  double travelPercentage = 0;
  double repairPercentage = 0;
  double telephonePercentage = 0;

  // Initialize variables for LineBar Value
  double salaryValue = 0;
  double rentValue = 0;
  double foodValue = 0;
  double clothValue = 0;
  double healthValue = 0;
  double electricityValue = 0;
  double educationValue = 0;
  double transportationValue = 0;
  double travelValue = 0;
  double repairValue = 0;
  double telephoneValue = 0;

  int hoveredIndex = -1; // To track which section is being hovered

  Widget legendItems(Color color, String name, String percentage) {
    return Row(
      children: [
        // Box with color representing the pie chart section
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4), // Rounded corners
          ),
        ),
        const SizedBox(width: 8),
        // Name of the section
        Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 5),
        // Percentage of the section
        Text(percentage,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }

  Future<void> totalAmount() async {
    try {
      final dataSnapshot = await databaseReference
          .orderByChild('userID')
          .equalTo(user.uid)
          .once();

      if (dataSnapshot.snapshot.value != null) {
        final records = dataSnapshot.snapshot.value as Map<dynamic, dynamic>;

        int totalIncome = 0;
        int totalExpense = 0;

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

        summation = totalIncome + totalExpense;

        if (summation != 0) {
          setState(() {
            total = summation;
            incomePercentage = (totalIncome / summation) * 100;
            expensePercentage = (totalExpense / summation) * 100;
          });
        } else {
          setState(() {
            total = 0;
            incomePercentage = 0;
            expensePercentage = 0;
          });
        }

        print('Total : $total');
      } else {
        print('No records found for user ID: ${user.uid}');
      }
    } catch (e) {
      print('Error retrieving total: $e');
    }
  }

  Future<void> fetchAllList() async {
    try {
      final dataSnapshot = await databaseReference
          .orderByChild('userID')
          .equalTo(user.uid)
          .once();

      if (dataSnapshot.snapshot.value != null) {
        final records = dataSnapshot.snapshot.value as Map<dynamic, dynamic>;

        int salary = 0;
        int rent = 0;
        int food = 0;
        int cloth = 0;
        int health = 0;
        int electricity = 0;
        int education = 0;
        int transportation = 0;
        int travel = 0;
        int repair = 0;
        int telephone = 0;

        records.forEach((key, value) {
          if (value is Map) {
            final amount = value['amount'] as int?;
            final category = value['category'] as String?;

            if (amount != null && category != null) {
              switch (category) {
                case 'Salary':
                  salary += amount;
                  break;
                case 'Rent':
                  rent += amount;
                  break;
                case 'Food':
                  food += amount;
                  break;
                case 'Cloth':
                  cloth += amount;
                  break;
                case 'Health':
                  health += amount;
                  break;
                case 'Electricity':
                  electricity += amount;
                  break;
                case 'Education':
                  education += amount;
                  break;
                case 'Transportation':
                  transportation += amount;
                  break;
                case 'Travel':
                  travel += amount;
                  break;
                case 'Repair':
                  repair += amount;
                  break;
                case 'Telephone':
                  telephone += amount;
                  break;
                default:
                  print('No Category Found!');
              }
            }
          }
        });

        if (summation != 0) {
          setState(() {
            salaryValue = salary / summation;
            salaryPercentage = (salary / summation) * 100;

            rentValue = rent / summation;
            rentPercentage = (rent / summation) * 100;

            foodValue = food / summation;
            foodPercentage = (food / summation) * 100;

            clothValue = cloth / summation;
            clothPercentage = (cloth / summation) * 100;

            healthValue = health / summation;
            healthPercentage = (health / summation) * 100;

            electricityValue = electricity / summation;
            electricityPercentage = (electricity / summation) * 100;

            educationValue = education / summation;
            educationPercentage = (education / summation) * 100;

            transportationValue = transportation / summation;
            transportationPercentage = (transportation / summation) * 100;

            travelValue = travel / summation;
            travelPercentage = (travel / summation) * 100;

            repairValue = repair / summation;
            repairPercentage = (repair / summation) * 100;

            telephoneValue = telephone / summation;
            telephonePercentage = (telephone / summation) * 100;
          });
        } else {
          setState(() {
            salaryValue = 0;
            salaryPercentage = 0;

            rentValue = 0;
            rentPercentage = 0;

            foodValue = 0;
            foodPercentage = 0;

            clothValue = 0;
            clothPercentage = 0;

            healthValue = 0;
            healthPercentage = 0;

            electricityValue = 0;
            electricityPercentage = 0;

            educationValue = 0;
            educationPercentage = 0;

            transportationValue = 0;
            transportationPercentage = 0;

            travelValue = 0;
            travelPercentage = 0;

            repairValue = 0;
            repairPercentage = 0;

            telephoneValue = 0;
            telephonePercentage = 0;
          });
        }
      } else {
        print('No records found for user ID: ${user.uid}');
      }
    } catch (e) {
      print('Error retrieving of chart list : $e');
    }
  }

  @override
  void initState() {
    totalAmount();
    fetchAllList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Call Again the functions for realtime update
    totalAmount();
    fetchAllList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text(
          'Visual Analytics',
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 100,
        automaticallyImplyLeading: false, // Removes the back arrow
      ),
      body: ListView(
        children: [
          Column(
            children: [
              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Aligns top of elements
                children: [
                  // Pie chart on the left
                  MouseRegion(
                    onHover: (event) {
                      setState(() {
                        // You could add more sophisticated logic based on position if necessary
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        hoveredIndex = -1; // Reset when hover leaves
                      });
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      color: Colors.white,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              if (pieTouchResponse != null &&
                                  pieTouchResponse.touchedSection != null) {
                                setState(() {
                                  hoveredIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                });
                              } else {
                                setState(() {
                                  hoveredIndex = -1;
                                });
                              }
                            },
                          ),
                          centerSpaceRadius: 50,
                          sections: [
                            PieChartSectionData(
                              value: incomePercentage,
                              color: Colors.green,
                              title: '${incomePercentage.toStringAsFixed(0)}%',
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              radius: hoveredIndex == 0
                                  ? 60
                                  : 50, // Elevate on hover
                            ),
                            PieChartSectionData(
                              value: expensePercentage,
                              color: Colors.red,
                              title: '${expensePercentage.toStringAsFixed(0)}%',
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              radius: hoveredIndex == 1
                                  ? 60
                                  : 50, // Elevate on hover
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Legends on the right
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      legendItems(Colors.green, 'Income',
                          incomePercentage.toStringAsFixed(0) + '%'),
                      const SizedBox(height: 10),
                      legendItems(Colors.red, 'Expense',
                          expensePercentage.toStringAsFixed(0) + '%'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 80),

              // Top List
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Top lists',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    chartList(
                      image: 'assets/salary.png',
                      name: 'Salary',
                      boxBg: Color.fromARGB(255, 87, 145, 87),
                      lineBar: Color.fromARGB(255, 87, 145, 87),
                      percentage: '${salaryPercentage.toStringAsFixed(0)}',
                      percentageValue: salaryValue,
                    ),
                    chartList(
                      image: 'assets/home.png',
                      name: 'Rent',
                      boxBg: Color.fromARGB(255, 58, 150, 150),
                      lineBar: Color.fromARGB(255, 58, 150, 150),
                      percentage: '${rentPercentage.toStringAsFixed(0)}',
                      percentageValue: rentValue,
                    ),
                    chartList(
                      image: 'assets/food.png',
                      name: 'Food',
                      boxBg: Color.fromARGB(255, 231, 188, 237),
                      lineBar: Color.fromARGB(255, 231, 188, 237),
                      percentage: '${foodPercentage.toStringAsFixed(0)}',
                      percentageValue: foodValue,
                    ),
                    chartList(
                      image: 'assets/cloth.png',
                      name: 'Cloth',
                      boxBg: Color.fromARGB(255, 208, 200, 255),
                      lineBar: Color.fromARGB(255, 208, 200, 255),
                      percentage: '${clothPercentage.toStringAsFixed(0)}',
                      percentageValue: clothValue,
                    ),
                    chartList(
                      image: 'assets/health.png',
                      name: 'Health',
                      boxBg: Color.fromARGB(255, 255, 207, 207),
                      lineBar: Color.fromARGB(255, 255, 207, 207),
                      percentage: '${healthPercentage.toStringAsFixed(0)}',
                      percentageValue: healthValue,
                    ),
                    chartList(
                      image: 'assets/electricity.png',
                      name: 'Electricity',
                      boxBg: Color.fromARGB(255, 0, 0, 0),
                      lineBar: Colors.yellow,
                      percentage: '${electricityPercentage.toStringAsFixed(0)}',
                      percentageValue: electricityValue,
                    ),
                    chartList(
                      image: 'assets/education.png',
                      name: 'Education',
                      boxBg: Color.fromARGB(255, 224, 212, 212),
                      lineBar: Color.fromARGB(255, 224, 212, 212),
                      percentage: '${educationPercentage.toStringAsFixed(0)}',
                      percentageValue: educationValue,
                    ),
                    chartList(
                      image: 'assets/transportation.png',
                      name: 'Transportation',
                      boxBg: Color.fromARGB(255, 1, 57, 9),
                      lineBar: Color.fromARGB(255, 1, 57, 9),
                      percentage:
                          '${transportationPercentage.toStringAsFixed(0)}',
                      percentageValue: transportationValue,
                    ),
                    chartList(
                      image: 'assets/travel.png',
                      name: 'Travel',
                      boxBg: Color.fromARGB(255, 255, 227, 178),
                      lineBar: Color.fromARGB(255, 255, 227, 178),
                      percentage: '${travelPercentage.toStringAsFixed(0)}',
                      percentageValue: travelValue,
                    ),
                    chartList(
                      image: 'assets/repair.png',
                      name: 'Repair',
                      boxBg: Color.fromARGB(255, 0, 0, 0),
                      lineBar: Color.fromARGB(255, 0, 0, 0),
                      percentage: '${repairPercentage.toStringAsFixed(0)}',
                      percentageValue: repairValue,
                    ),
                    chartList(
                      image: 'assets/telephone.png',
                      name: 'Telephone',
                      boxBg: Color.fromARGB(255, 105, 148, 97),
                      lineBar: Color.fromARGB(255, 105, 148, 97),
                      percentage: '${telephonePercentage.toStringAsFixed(0)}',
                      percentageValue: telephoneValue,
                    ),
                    SizedBox(height: 30),
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
