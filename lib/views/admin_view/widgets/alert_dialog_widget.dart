import 'dart:io';
import 'package:donite/constants/constants.dart';
import 'package:donite/controller/disaster_controller.dart';
import 'package:donite/views/admin_view/widgets/date_widget.dart';
import 'package:donite/views/admin_view/widgets/image_widget.dart';
import 'package:donite/views/admin_view/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AlertDialogWidget extends StatefulWidget {
  final int id;
  final String title;
  final String date;
  final String disasterType;
  final String location;
  final String information;
  final String path;
  const AlertDialogWidget(
      {super.key,
      required this.id,
      required this.title,
      required this.date,
      required this.disasterType,
      required this.location,
      required this.information,
      required this.path});

  @override
  State<AlertDialogWidget> createState() => _AlertDialogWidgetState();
}

class _AlertDialogWidgetState extends State<AlertDialogWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _disasterTypeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _informationController = TextEditingController();
  late DateTime _selectedDate = DateTime.now();
  File? imageFile;

  // @override
  // void dispose() {
  //   _titleController.dispose();
  //   _dateController.dispose();
  //   _disasterTypeController.dispose();
  //   _locationController.dispose();
  //   _informationController.dispose();
  //   super.dispose();
  // }

  final DisasterController _disasterController = Get.put(DisasterController());
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        showDataAlert(
            context,
            _titleController,
            _dateController,
            _disasterTypeController,
            _locationController,
            _informationController,
            _selectedDate,
            imageFile,
            widget.id,
            widget.title,
            widget.date,
            widget.disasterType,
            widget.location,
            widget.information,
            widget.path);
      },
    );
  }

  showDataAlert(
    BuildContext context,
    TextEditingController titleController,
    TextEditingController dateController,
    TextEditingController disasterTypeController,
    TextEditingController locationController,
    TextEditingController informationController,
    DateTime selectedDate,
    File? imageFile,
    int id,
    String title,
    String date,
    String disasterType,
    String location,
    String information,
    String path,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;
        double dialogWidth = screenWidth * 0.5;
        double dialogHeight = screenHeight * 0.7;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    20.0,
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.only(
                top: 10.0,
              ),
              title: const Text(
                "EDIT DISASTER",
                style: TextStyle(fontSize: 24.0),
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
                                : Image.network(
                                    '${baseImageUrl}storage/${path}')),
                        InputWidget(
                          controller: titleController,
                          //initialValue: title,
                          hintext: title,
                          prefixicon: const Icon(
                            Icons.text_format,
                            color: Colors.grey,
                          ),
                        ),
                        DateWidget(
                          controller: _dateController,
                          //initialValue: date,
                          hintext: date,
                          showDatePicker: _showDatePicker,
                          prefixicon: const Icon(Icons.calendar_month,
                              color: Colors.grey),
                        ),
                        InputWidget(
                          controller: disasterTypeController,
                          //initialValue: disasterType,
                          hintext: disasterType,
                          prefixicon:
                              const Icon(Icons.category, color: Colors.grey),
                        ),
                        InputWidget(
                          controller: locationController,
                          //initialValue: location,
                          hintext: location,
                          prefixicon:
                              const Icon(Icons.location_on, color: Colors.grey),
                        ),
                        ImageWidget(
                          hintext: imageFile != null
                              ? 'Image Selected'
                              : 'Select Image',
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
                          controller: informationController,
                          //initialValue: information,
                          hintext: information,
                          prefixicon:
                              const Icon(Icons.info, color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors
                                        .grey[900] /*Colors.deepPurpleAccent*/),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                await _disasterController.updateDisaster(
                                    id: id.toString(),
                                    title: titleController.text.trim(),
                                    date: dateController.text.trim(),
                                    disasterType:
                                        disasterTypeController.text.trim(),
                                    location: locationController.text.trim(),
                                    information:
                                        informationController.text.trim(),
                                    imagePath: imageFile != null
                                        ? imageFile!.path.toString().trim()
                                        : '');
                                _disasterController.getAllDisasters();
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

  Widget submitButton(int id, String title, String date, String disasterType,
      String location, String information, File? imagePath) {
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
            // await _disasterController.updateDisaster(id.toString(), title, date,
            //     disasterType, location, information, imagePath!);
          },
          child: const Text('SUBMIT'),
        ),
      ),
    );
  }
}
