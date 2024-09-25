import 'package:flutter/material.dart';

class chartList extends StatelessWidget {
  const chartList({
    super.key,
    required this.image,
    required this.name,
    required this.boxBg,
    required this.lineBar,
    required this.percentage,
    required this.percentageValue,
  });

  final String image;
  final String name;
  final Color boxBg;
  final Color lineBar;
  final String percentage;
  final double percentageValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: boxBg,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '$percentage%',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 280, // Set a specific width
                          child: LinearProgressIndicator(
                            value:
                                percentageValue, // 100% progress (from 0.0 to 1.0)
                            valueColor: AlwaysStoppedAnimation<Color>(
                              lineBar,
                            ),
                            backgroundColor: Colors.white,
                            minHeight: 10.0,
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
      ),
    );
  }
}
