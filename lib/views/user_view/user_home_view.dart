import 'package:donite/controller/authentication_controller.dart';
import 'package:donite/views/constants.dart';
import 'package:donite/views/user_view/disaster_inactive_view.dart';
import 'package:donite/views/user_view/disasters_active.dart';
import 'package:donite/views/user_view/donation_history_view.dart';
import 'package:donite/views/user_view/about_us_view.dart';
import 'package:donite/views/user_view/disasters_view.dart';
import 'package:donite/views/user_view/feeds_view.dart';
import 'package:donite/views/user_view/user_constants.dart';
import 'package:donite/views/user_view/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserHomeView extends StatefulWidget {
  const UserHomeView({super.key, required this.pageID});
  final int pageID;

  @override
  _UserHomeViewState createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());
  final box = GetStorage();

  int currentIndex = 0;
  List<Widget> listOfPage = [];
  @override
  void initState() {
    super.initState();
    listOfPage = [
      const DisasterActiveView(),
      const FeedView(),
      const DisasterInactiveView(),
      // DonationHistoryView(userId: _authenticationController.userId),
      DonationHistoryView(
        userId: box.read('userId').toString().replaceAll('"', ''),
      ),
    ];
    currentIndex = widget.pageID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar,
      drawer: const DrawerWidget(),
      body: listOfPage[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        currentIndex: currentIndex,
        unselectedItemColor: const Color.fromARGB(255, 178, 178, 178),
        selectedItemColor: foregroundColor(),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'News'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(Icons.handshake), label: 'Supports'),
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
