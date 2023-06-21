import 'dart:io';
import 'package:donite/controller/disaster_controller.dart';
import 'package:donite/views/admin_view/constants.dart';
import 'package:donite/views/admin_view/widgets/box_widget.dart';
import 'package:donite/views/admin_view/widgets/date_widget.dart';
import 'package:donite/views/admin_view/widgets/image_widget.dart';
import 'package:donite/views/admin_view/widgets/input_widget.dart';
import 'package:donite/views/admin_view/widgets/tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({Key? key}) : super(key: key);

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _disasterTypeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _informationController = TextEditingController();
  late DateTime _selectedDate = DateTime.now();
  File? imageFile;

  final DisasterController _disasterController = Get.put(DisasterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: myAppBar,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // open drawer
            myDrawer,

            // first half of page
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  // first 4 boxes in grid
                  AspectRatio(
                    aspectRatio: 4,
                    child: SizedBox(
                      width: double.infinity,
                      child: GridView.builder(
                        itemCount: 4,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4),
                        itemBuilder: (context, index) {
                          return MyBox();
                        },
                      ),
                    ),
                  ),

                  // list of previous days
                  Expanded(
                    child: Obx(() {
                      return _disasterController.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  _disasterController.disasters.value.length,
                              itemBuilder: (context, index) {
                                return MyTile(
                                    disaster: _disasterController
                                        .disasters.value[index]);
                              });
                    }),
                  ),
                ],
              ),
            ),
            // second half of page
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          //height: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: imageFile != null
                                    ? Image.file(
                                        imageFile!,
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.scaleDown,
                                      )
                                    : const FlutterLogo(
                                        size: 200,
                                      ),
                              ),
                              InputWidget(
                                controller: _titleController,
                                //initialValue: '',
                                hintext: 'Title',
                                prefixicon: const Icon(
                                  Icons.text_format,
                                  color: Colors.grey,
                                ),
                              ),
                              DateWidget(
                                controller: _dateController,
                                //initialValue: '',
                                hintext: 'Date',
                                showDatePicker: _showDatePicker,
                                prefixicon: const Icon(Icons.calendar_month,
                                    color: Colors.grey),
                              ),
                              InputWidget(
                                controller: _disasterTypeController,
                                //initialValue: '',
                                hintext: 'Disaster',
                                prefixicon: const Icon(Icons.category,
                                    color: Colors.grey),
                              ),
                              InputWidget(
                                controller: _locationController,
                                //initialValue: '',
                                hintext: 'Location',
                                prefixicon: const Icon(Icons.location_on,
                                    color: Colors.grey),
                              ),
                              ImageWidget(
                                hintext: imageFile != null
                                    ? 'Image Selected'
                                    : 'Select Image',
                                pickImage: pickImage,
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
                                //initialValue: '',
                                hintext: 'Information',
                                prefixicon:
                                    const Icon(Icons.info, color: Colors.grey),
                              ),
                              submitButton()
                            ],
                          )),
                    ),
                  ],
                ),
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
          onPressed: () async {},
          child: const Text('SUBMIT'),
        ),
      ),
    );
  }
}
