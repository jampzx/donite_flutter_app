import 'package:donite/views/admin_view/responsive/mobile_body.dart';
import 'package:donite/views/user_view/donations_view.dart';
import 'package:donite/views/user_view/profile_view.dart';
import 'package:flutter/material.dart';

class NavBarWidget extends StatefulWidget {
  const NavBarWidget({super.key});

  @override
  State<NavBarWidget> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
  int currentIndex = 0;
  List listOfPage = [
    MobileScaffold(),
    DonationsView(),
    ProfileView(),
    Container(
      color: Colors.black,
    ),
    Container(
      color: Colors.green,
    ),
    Container(
      color: Colors.red,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listOfPage[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF7C4DFF),
        currentIndex: currentIndex,
        unselectedItemColor: Color(0xFFF5F5F5),
        selectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: new Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: new Icon(Icons.phone), label: 'Emergency'),
          BottomNavigationBarItem(
              icon: new Icon(Icons.person), label: 'Profile')
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
