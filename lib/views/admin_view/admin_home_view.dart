import 'package:donite/controller/authentication_controller.dart';
import 'package:donite/controller/disaster_controller.dart';
import 'package:donite/controller/donation_controller.dart';
import 'package:donite/views/admin_view/admin_constants.dart';
import 'package:donite/views/admin_view/disaster_management_view.dart';
import 'package:donite/views/admin_view/donation_management_view.dart';
import 'package:donite/views/admin_view/feed_management_view.dart';
import 'package:donite/views/admin_view/user_management_view.dart';
import 'package:donite/views/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminHomeView extends StatefulWidget {
  const AdminHomeView({Key? key}) : super(key: key);

  @override
  _AdminHomeViewState createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  @override
  void initState() {
    super.initState();
    // _authenticationController.getAllUsers();
    // _disasterController.getAllDisasters();
    // _donationController.getAllDonations();
  }

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DisasterManagementView(),
    const FeedManagementView(),
    const DonationManagementView(),
    const UserManagementView(),
  ];
  bool isExpanded = false;

  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());
  final DisasterController _disasterController = Get.put(DisasterController());
  final DonationController _donationController = Get.put(DonationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: myAppBar,
      body: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  if (index == 4) {
                    _authenticationController.logout();
                  } else {
                    setState(() {
                      _selectedIndex = index;
                    });
                  }
                });
              },
              extended: isExpanded,
              backgroundColor: foregroundColor(),
              unselectedIconTheme:
                  const IconThemeData(color: Colors.white, opacity: 1),
              unselectedLabelTextStyle: const TextStyle(
                color: Colors.white,
              ),
              selectedIconTheme: const IconThemeData(color: Colors.orange),
              selectedLabelTextStyle: TextStyle(
                color: Colors.orange,
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text("D I S A S T E R S"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.newspaper),
                  label: Text("N E W S  F E E D"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.bar_chart),
                  label: Text("D O N A T I O N S"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  label: Text("U S E R S"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.logout),
                  label: Text("L O G  O U T"),
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
