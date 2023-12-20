import 'dart:io';
import 'package:donite/controller/authentication_controller.dart';
import 'package:donite/controller/disaster_controller.dart';
import 'package:donite/controller/donation_controller.dart';
import 'package:donite/views/admin_view/admin_constants.dart';
import 'package:donite/views/admin_view/widgets/box_widget.dart';
import 'package:donite/views/admin_view/widgets/disasters_data_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class DisasterManagementView extends StatefulWidget {
  const DisasterManagementView({Key? key}) : super(key: key);

  @override
  State<DisasterManagementView> createState() => _DisasterManagementViewState();
}

class _DisasterManagementViewState extends State<DisasterManagementView> {
  @override
  void initState() {
    super.initState();
    _disasterController.getAllDisasters();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _disasterTypeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _informationController = TextEditingController();
  late DateTime _selectedDate = DateTime.now();
  File? imageFile;

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
                          textTitle: 'VERIFIED USERS',
                          textDetails:
                              _authenticationController.verifiedUserCount),
                      MyBox(
                          color: Colors.blueAccent,
                          icon: Icons.pending,
                          textTitle: 'UNVERIFIED USERS',
                          textDetails:
                              _authenticationController.unverifiedUserCount),
                      MyBox(
                          color: Colors.purpleAccent,
                          icon: Icons.verified,
                          textTitle: 'VERIFIED SUPPORT',
                          textDetails:
                              _authenticationController.unverifiedUserCount),
                      MyBox(
                          color: Colors.purpleAccent,
                          icon: Icons.pending,
                          textTitle: 'UNVERIFIED SUPPORT',
                          textDetails:
                              _authenticationController.unverifiedUserCount)
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // list of previous days
                  Expanded(
                    child: Obx(() {
                      return _disasterController.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : const DisastersDataTableWidget();
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

  //Date Picker
  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _selectedDate.toString().split(' ')[0];
      });
    }
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);

      setState(() {
        imageFile = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to select image: $e');
    }
  }

  Widget submitButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Colors.grey[900] /*Colors.deepPurpleAccent*/),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          onPressed: () async {
            _disasterController.createDisaster(
                title: _titleController.text.trim(),
                date: _dateController.text.trim(),
                disasterType: _disasterTypeController.text.trim(),
                location: _locationController.text.trim(),
                information: _informationController.text.trim(),
                imagePath: imageFile!.path.toString().trim());
            _titleController.clear();
            _dateController.clear();
            _disasterTypeController.clear();
            _locationController.clear();
            _informationController.clear();
            imageFile = null;
          },
          child: const Text('SUBMIT'),
        ),
      ),
    );
  }
}
