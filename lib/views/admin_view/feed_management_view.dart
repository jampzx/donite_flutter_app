import 'dart:io';
import 'package:donite/controller/authentication_controller.dart';
import 'package:donite/controller/disaster_controller.dart';
import 'package:donite/controller/donation_controller.dart';
import 'package:donite/controller/feed_controller.dart';
import 'package:donite/views/admin_view/admin_constants.dart';
import 'package:donite/views/admin_view/widgets/box_widget.dart';
import 'package:donite/views/admin_view/widgets/disasters_data_table_widget.dart';
import 'package:donite/views/admin_view/widgets/feeds_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class FeedManagementView extends StatefulWidget {
  const FeedManagementView({Key? key}) : super(key: key);

  @override
  State<FeedManagementView> createState() => _FeedManagementViewState();
}

class _FeedManagementViewState extends State<FeedManagementView> {
  @override
  void initState() {
    super.initState();
    _feedController.getAllFeeds();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _disasterTypeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _informationController = TextEditingController();
  late DateTime _selectedDate = DateTime.now();
  File? imageFile;

  final FeedController _feedController = Get.put(FeedController());
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
                          textDetails: box
                              .read('verifiedUser')
                              .toString()
                              .replaceAll('"', '')),
                      MyBox(
                          color: Colors.purpleAccent,
                          icon: Icons.pending,
                          textTitle: 'PENDING',
                          textDetails: box
                              .read('unverifiedUser')
                              .toString()
                              .replaceAll('"', ''))
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // list of previous days
                  Expanded(
                    child: Obx(() {
                      return _feedController.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : const FeedsDataTable();
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
