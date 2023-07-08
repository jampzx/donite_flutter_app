import 'dart:io';
import 'package:donite/controller/authentication_controller.dart';
import 'package:donite/controller/disaster_controller.dart';
import 'package:donite/controller/donation_controller.dart';
import 'package:donite/views/admin_view/admin_constants.dart';
import 'package:donite/views/admin_view/widgets/box_widget.dart';
import 'package:donite/views/admin_view/widgets/disasters_data_table_widget.dart';
import 'package:donite/views/admin_view/widgets/donations_data_table_widget%20.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DonationManagementView extends StatefulWidget {
  const DonationManagementView({Key? key}) : super(key: key);

  @override
  State<DonationManagementView> createState() => _DonationManagementViewState();
}

class _DonationManagementViewState extends State<DonationManagementView> {
  @override
  void initState() {
    super.initState();
    _donationController.getAllDonations();
  }

  final DisasterController _disasterController = Get.put(DisasterController());
  final DonationController _donationController = Get.put(DonationController());
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());
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
                  Row(
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
                          textTitle: 'DONATIONS',
                          textDetails: _donationController.donationCount),
                      MyBox(
                          color: Colors.blueAccent,
                          icon: Icons.verified,
                          textTitle: 'VERIFIED',
                          textDetails: _authenticationController.verifiedUser),
                      MyBox(
                          color: Colors.purpleAccent,
                          icon: Icons.pending,
                          textTitle: 'PENDING',
                          textDetails: _authenticationController.unverifiedUser)
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // list of previous days
                  Expanded(
                    child: Obx(() {
                      return _donationController.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : const DonationsDataTableWidget();
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
}
