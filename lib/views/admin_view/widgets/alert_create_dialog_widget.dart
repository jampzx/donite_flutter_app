import 'dart:io';
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

class AlertCreateDialogWidget extends StatefulWidget {
  const AlertCreateDialogWidget({
    super.key,
    required this.alertFor,
  });

  @override
  State<AlertCreateDialogWidget> createState() =>
      _AlertCreateDialogWidgetState();

  final String alertFor;
}

class _AlertCreateDialogWidgetState extends State<AlertCreateDialogWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _disasterTypeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _informationController = TextEditingController();
  late DateTime _selectedDate = DateTime.now();
  File? imageFile;
  List<String> disasterDropDown = [
    'Ashfall',
    'Earthquake',
    'El Nino',
    'Flash floods',
    'Flood',
    'Flood due to heavy rainfall',
    'Heatwaves',
    'Landslide',
    'Lava Flow',
    'La Nina',
    'Mudflow/Rockfall',
    'Thunderstorm',
    'Tornado',
    'Tropical Cyclone',
    'Tropical Depressions',
    'Tropical Storms',
    'Tsunami',
    'Typhoon',
    'Volcanic ashfall',
    'Volcanic eruption',
    'Wave/surge',
    'Wind storm',
    'Wildfire',
  ];
  List<String> locationDropDown = [
    'Acao',
    'Baccuit Norte',
    'Baccuit Sur',
    'Bagbag',
    'Ballay',
    'Bawanta',
    'Boy-utan',
    'Bucayab',
    'Cabalayangan',
    'Cabisilan',
    'Calumbaya',
    'Carmay',
    'Casilagan',
    'Center East',
    'Center West',
    'Dili',
    'Disso-or',
    'Guerrero',
    'Lower San Agustin',
    'Nagrebcan',
    'Pagdalagan Sur',
    'Palintucang',
    'Palugsi-Lummansangan',
    'Parian Este',
    'Parian Oeste',
    'Paringao',
    'Payocpoc Norte Este',
    'Payocpoc Norte Oeste',
    'Payocpoc Sur',
    'Pilar',
    'Pottot',
    'Pugo',
    'Quinavite',
    'Santa Monica',
    'Santiago',
    'Taberna',
    'Upper San Agustin',
    'Urayong',
    'Other Municipalities'
  ];

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
            "POST DISASTER",
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
                    // InputWidget(
                    //   controller: _disasterTypeController,
                    //   //initialValue: disasterType,
                    //   hintext: "Disaster Type",
                    //   prefixicon:
                    //       const Icon(Icons.category, color: Colors.grey),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        style: kTextFormFieldStyle().copyWith(
                          color: Colors.black,
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            updateDisasterTypeControllerValue(newValue!);
                          });
                        },
                        items: disasterDropDown.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: const Text('Disaster Type'),
                        decoration: InputDecoration(
                          fillColor: Colors.grey[300],
                          filled: true,
                          prefixIcon: const Icon(Icons.info_rounded),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    // InputWidget(
                    //   controller: _locationController,
                    //   //initialValue: location,
                    //   hintext: "Location",
                    //   prefixicon:
                    //       const Icon(Icons.location_on, color: Colors.grey),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        style: kTextFormFieldStyle().copyWith(
                          color: Colors.black,
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            updateLocationControllerValue(newValue!);
                          });
                        },
                        items: locationDropDown.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: const Text('Location'),
                        decoration: InputDecoration(
                          fillColor: Colors.grey[300],
                          filled: true,
                          prefixIcon: const Icon(Icons.info_rounded),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
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
                            if (
                                //imageFile == null ||
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
                                      await _disasterController.createDisaster(
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
                                          imagePath: imageFile == null
                                              ? 'none'
                                              : imageFile!.path
                                                  .toString()
                                                  .trim()),
                                      _disasterController.getAllDisasters(),
                                      // ignore: use_build_context_synchronously
                                    )
                                  : (
                                      await _feedController.createFeed(
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
                                          imagePath: imageFile == null
                                              ? 'none'
                                              : imageFile!.path
                                                  .toString()
                                                  .trim()),
                                      _feedController.getAllFeeds(),
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

  void updateDisasterTypeControllerValue(String newValue) {
    _disasterTypeController.text = newValue;
  }

  void updateLocationControllerValue(String newValue) {
    _locationController.text = newValue;
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
