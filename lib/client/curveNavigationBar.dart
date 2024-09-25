import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'catergory.dart';
import 'chart.dart';
import 'dashboard.dart';
import 'profile.dart';

class CustomCurvedNavigationBar extends StatefulWidget {
  const CustomCurvedNavigationBar({super.key});

  @override
  State<CustomCurvedNavigationBar> createState() =>
      _CustomCurvedNavigationBarState();
}

class _CustomCurvedNavigationBarState extends State<CustomCurvedNavigationBar> {
  int _currentIndex = 0;

  // Define your pages here
  final List<Widget> _pages = [
    Dashboard(),
    Category(),
    Chart(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.home_filled, color: Colors.white, size: 35),
      Icon(Icons.dns, color: Colors.white, size: 35),
      Icon(Icons.equalizer, color: Colors.white, size: 35),
      Icon(Icons.account_circle, color: Colors.white, size: 35),
    ];

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.deepPurple,
        buttonBackgroundColor: Colors.deepPurple,
        height: 70,
        items: items,
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      // Using IndexedStack to maintain the state of the pages
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CustomCurvedNavigationBar(),
  ));
}
