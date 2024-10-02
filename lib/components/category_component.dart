import 'package:flutter/material.dart';

class categoryComponent extends StatelessWidget {
  const categoryComponent({
    super.key,
    required this.image,
    required this.name,
    required this.boxBg,
  });

  final String image;
  final String name;
  final Color boxBg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: boxBg,
                  borderRadius: BorderRadius.circular(100), // Rounded corners
                ),
                child: Image.asset(
                  image,
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 20),

              // Category
              Text(
                name,
                style: TextStyle(
                  color: Color.fromARGB(255, 115, 115, 115),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
