import 'dart:io';
import 'package:donite/constants/constants.dart';
import 'package:donite/controller/disaster_controller.dart';
import 'package:donite/controller/feed_controller.dart';
import 'package:donite/views/admin_view/widgets/date_widget.dart';
import 'package:donite/views/admin_view/widgets/image_widget.dart';
import 'package:donite/views/admin_view/widgets/input_widget.dart';
import 'package:donite/views/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AlertOfflineCreateDialogWidget extends StatefulWidget {
  const AlertOfflineCreateDialogWidget({
    super.key,
    required this.alertFor,
  });

  @override
  State<AlertOfflineCreateDialogWidget> createState() =>
      _AlertOfflineCreateDialogWidgetState();
  final String alertFor;
}

class _AlertOfflineCreateDialogWidgetState
    extends State<AlertOfflineCreateDialogWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _disasterTypeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _informationController = TextEditingController();
  late DateTime _selectedDate = DateTime.now();
  File? imageFile;
  final DisasterController _disasterController = Get.put(DisasterController());
  final FeedController _feedController = Get.put(FeedController());

  @override
  Widget build(BuildContext context) {
    String alertType = widget.alertFor;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double dialogWidth = screenWidth * 0.3;
    double dialogHeight = screenHeight * 0.55;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                5.0,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.only(
            top: 8.0,
          ),
          title: const Text(
            "POSTS MANAGEMENT",
            style: TextStyle(fontSize: 18.0),
          ),
          content: SizedBox(
            width: dialogWidth,
            height: dialogHeight,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: imageFile != null
                            ? Image.file(
                                imageFile!,
                              )
                            : Image.asset('assets/gallery.png')),
                    InputWidget(
                      controller: _titleController,
                      //initialValue: title,
                      hintext: "Title",
                      prefixicon: const Icon(
                        Icons.text_format,
                        color: Colors.grey,
                      ),
                    ),
                    DateWidget(
                      controller: _dateController,
                      //initialValue: date,
                      hintext: "Date",
                      showDatePicker: _showDatePicker,
                      prefixicon:
                          const Icon(Icons.calendar_month, color: Colors.grey),
                    ),
                    InputWidget(
                      controller: _disasterTypeController,
                      //initialValue: disasterType,
                      hintext: "Disaster Type",
                      prefixicon:
                          const Icon(Icons.category, color: Colors.grey),
                    ),
                    InputWidget(
                      controller: _locationController,
                      //initialValue: location,
                      hintext: "Location",
                      prefixicon:
                          const Icon(Icons.location_on, color: Colors.grey),
                    ),
                    ImageWidget(
                      hintext:
                          imageFile != null ? 'Image Selected' : 'Select Image',
                      pickImage: () {
                        pickImage().then((pickedImage) {
                          setState(() {
                            imageFile = pickedImage;
                          });
                        });
                      },
                      prefixicon: imageFile != null
                          ? const Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.upload,
                              color: Colors.grey,
                            ),
                    ),
                    InputWidget(
                      controller: _informationController,
                      //initialValue: information,
                      hintext: "Information",
                      prefixicon: const Icon(Icons.info, color: Colors.grey),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                foregroundColor() /*Colors.deepPurpleAccent*/),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (imageFile == null ||
                                _titleController.text == '' ||
                                _dateController.text == '' ||
                                _disasterTypeController.text == '' ||
                                _disasterTypeController.text == '' ||
                                _informationController.text == '') {
                              Get.snackbar('Error', 'Please fill all fields',
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                            } else {
                              alertType == 'disaster'
                                  ? (
                                      await _disasterController.saveLocally(
                                          title: _titleController.text.trim(),
                                          date: _dateController.text.trim(),
                                          disasterType: _disasterTypeController
                                              .text
                                              .trim(),
                                          location:
                                              _locationController.text.trim(),
                                          information: _informationController
                                              .text
                                              .trim(),
                                          imagePath: imageFile!.path
                                              .toString()
                                              .trim()),
                                    )
                                  : (
                                      await _feedController.saveLocally(
                                          title: _titleController.text.trim(),
                                          date: _dateController.text.trim(),
                                          disasterType: _disasterTypeController
                                              .text
                                              .trim(),
                                          location:
                                              _locationController.text.trim(),
                                          information: _informationController
                                              .text
                                              .trim(),
                                          imagePath: imageFile!.path
                                              .toString()
                                              .trim()),
                                    );
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('SUBMIT'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<File?> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      final imageTemporary = File(image.path);
      return imageTemporary;
    } on PlatformException catch (e) {
      print('Failed to select image: $e');
      return null;
    }
  }

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
}
