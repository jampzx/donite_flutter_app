import 'package:donite/controller/authentication_controller.dart';
import 'package:donite/views/user_view/donation_history_view.dart';
import 'package:donite/views/user_view/donations_view.dart';
import 'package:donite/views/user_view/about_us_view.dart';
import 'package:donite/views/user_view/disasters_view.dart';
import 'package:donite/views/user_view/user_constants.dart';
import 'package:donite/views/user_view/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserHomeView extends StatefulWidget {
  const UserHomeView({super.key});

  @override
  _UserHomeViewState createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());
  int currentIndex = 0;
  List<Widget> listOfPage = [];
  @override
  void initState() {
    super.initState();
    listOfPage = [
      const DisasterView(),
      DonationHistoryView(userId: _authenticationController.userId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(_authenticationController.userId);
    return Scaffold(
      appBar: myAppBar,
      drawer: const DrawerWidget(),
      body: listOfPage[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        currentIndex: currentIndex,
        unselectedItemColor: const Color.fromARGB(255, 178, 178, 178),
        selectedItemColor: Colors.blueAccent,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.handshake), label: 'Donations'),
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
