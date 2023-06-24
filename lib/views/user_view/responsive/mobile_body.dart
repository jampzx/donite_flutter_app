import 'package:donite/controller/disaster_controller.dart';
import 'package:donite/views/admin_view/constants.dart';
import 'package:donite/views/admin_view/widgets/box_widget.dart';
import 'package:donite/views/user_view/widgets/tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileScaffold extends StatefulWidget {
  const MobileScaffold({Key? key}) : super(key: key);

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  final DisasterController _disasterController = Get.put(DisasterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: myAppBar,
      drawer: myDrawer,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                return _disasterController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _disasterController.disasters.value.length,
                        itemBuilder: (context, index) {
                          return MyTile(
                              disaster:
                                  _disasterController.disasters.value[index]);
                        });
              }),
            )
          ],
        ),
      ),
    );
  }
}
