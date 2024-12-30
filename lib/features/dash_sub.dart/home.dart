import 'package:cure/core/resources/managers/colors_manager.dart';
import 'package:cure/features/dash_sub.dart/lectures/presentation/view.dart';
import 'package:cure/features/dash_sub.dart/stat.dart';
import 'package:cure/main.dart';
import 'package:flutter/material.dart';

import 'show_codes.dart';
import 'subjects/presentation/view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTap(int index) {
    _pageController.jumpToPage(index);
  }

  final String subjectName = "Mathematics"; // Example subject name
  final int subjectId = 11; // Example subject ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: const <Widget>[
          ShowSubjects(),
          ShowCodes(),
          ShowStatistics(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'مقررات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_sharp),
              label: 'أكواد',
              //   backgroundColor: Color.fromARGB(255, 73, 59, 59)
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'المستخدمين',
            ),
          ],

          selectedItemColor: Colors.white, // Color for selected item
          unselectedItemColor: Colors.white, // Color for unselected items

          backgroundColor: ColorsManager.secondaryColor,
        ),
      ),
    );
  }
}