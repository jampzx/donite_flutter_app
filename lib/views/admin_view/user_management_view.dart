import 'package:donite/controller/authentication_controller.dart';
import 'package:donite/controller/disaster_controller.dart';
import 'package:donite/controller/donation_controller.dart';
import 'package:donite/views/admin_view/admin_constants.dart';
import 'package:donite/views/admin_view/widgets/box_widget.dart';
import 'package:donite/views/admin_view/widgets/users_data_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserManagementView extends StatefulWidget {
  const UserManagementView({Key? key}) : super(key: key);

  @override
  State<UserManagementView> createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
  @override
  void initState() {
    super.initState();
    _authenticationController.getAllUsers();
  }

  final DisasterController _disasterController = Get.put(DisasterController());
  final DonationController _donationController = Get.put(DonationController());
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Scaffold(
        backgroundColor: defaultBackgroundColor,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // first half of page
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  // first 4 boxes in grid
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MyBox(
                            color: Colors.orangeAccent,
                            icon: Icons.post_add_sharp,
                            textTitle: 'POSTS',
                            textDetails: _disasterController.disasterCount),
                        MyBox(
                            color: Colors.redAccent,
                            icon: Icons.attach_money,
                            textTitle: 'SUPPORTS',
                            textDetails: _donationController.donationCount),
                        Obx(() => MyBox(
                            color: Colors.blueAccent,
                            icon: Icons.verified,
                            textTitle: 'VERIFIED USERS',
                            textDetails: _authenticationController
                                .verifiedUserCount
                                .toString())),
                        Obx(() => MyBox(
                            color: Colors.blueAccent,
                            icon: Icons.verified,
                            textTitle: 'UNVERIFIED USERS',
                            textDetails: _authenticationController
                                .unverifiedUserCount
                                .toString())),
                        MyBox(
                            color: Colors.purpleAccent,
                            icon: Icons.verified,
                            textTitle: 'VERIFIED SUPPORT',
                            textDetails:
                                _donationController.verifiedCount.toString()),
                        MyBox(
                            color: Colors.purpleAccent,
                            icon: Icons.pending,
                            textTitle: 'UNVERIFIED SUPPORT',
                            textDetails:
                                _donationController.unverifiedCount.toString())
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // list of previous days
                  Expanded(
                    child: Obx(() {
                      return _authenticationController.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : UsersDataTableWidget(
                              updateUserCountsCallback: updateUserCounts);
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateUserCounts() {
    _authenticationController.getAllUsers();
  }
}
