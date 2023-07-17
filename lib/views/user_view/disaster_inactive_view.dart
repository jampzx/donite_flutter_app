import 'package:donite/controller/authentication_controller.dart';
import 'package:donite/controller/disaster_controller.dart';
import 'package:donite/views/constants.dart';
import 'package:donite/views/user_view/user_constants.dart';
import 'package:donite/views/user_view/widgets/active_tile_widget.dart';
import 'package:donite/views/user_view/widgets/inactive_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisasterInactiveView extends StatefulWidget {
  const DisasterInactiveView({Key? key}) : super(key: key);

  @override
  State<DisasterInactiveView> createState() => _DisasterInactiveViewState();
}

class _DisasterInactiveViewState extends State<DisasterInactiveView> {
  final DisasterController _disasterController = Get.put(DisasterController());
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    _disasterController.getInactiveDisasters();
    return Scaffold(
      // backgroundColor: defaultBackgroundColor,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, right: 10.0, left: 10.0),
                    child: Text(
                      'Events History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 15.0, left: 12.0),
                    child: Text(
                      'This page display all past disasters',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 18.0, right: 12.0, left: 12.0),
                    child: Text(
                      'Past events',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Obx(() {
                return _disasterController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount:
                            _disasterController.disastersInactive.value.length,
                        itemBuilder: (context, index) {
                          return InactiveTileWidget(
                            disaster: _disasterController
                                .disastersInactive.value[index],
                          );
                        },
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
