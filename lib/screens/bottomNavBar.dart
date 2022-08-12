import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class BottomNavBar extends StatefulWidget {
  // BottomNavBar(this.currentIndex);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedPage = 0;
  final _childrens = [
    HomePage(),
    Container(
      color: Colors.yellow,
    ),
    HomePage(),
    Container(
      color: Colors.deepPurple,
    ),
    Container(
      color: Colors.blue,
    ),
  ];

  // void onTabTapped(int index) {
  //   setState(() {
  //     widget.currentIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _childrens[selectedPage],
      bottomNavigationBar: Container(
        child: ConvexAppBar(
            height: 70,
            style: TabStyle.reactCircle,
            backgroundColor: Colors.white,
            items: [
              TabItem(title: 'Explore', icon: Icons.home),
              TabItem(title: 'Search', icon: Icons.content_paste_outlined),
              TabItem(title: 'Consult', icon: Icons.health_and_safety),
              TabItem(title: 'Free tolols', icon: Icons.history),
              TabItem(title: 'Files', icon: Icons.file_copy_sharp),
              // TabItem(icon: Icons.person),
            ],
            color: Colors.black.withOpacity(0.6),
            activeColor: Colors.deepOrange,
            initialActiveIndex: selectedPage,
            curveSize: 100,
            top: -30,
            onTap: (int index) {
              setState(() {
                selectedPage = index;
              });
            }),
      ),
    );
  }
}
