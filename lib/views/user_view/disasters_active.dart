import 'package:donite/controller/authentication_controller.dart';
import 'package:donite/controller/disaster_controller.dart';
import 'package:donite/views/constants.dart';
import 'package:donite/views/user_view/user_constants.dart';
import 'package:donite/views/user_view/widgets/active_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisasterActiveView extends StatefulWidget {
  const DisasterActiveView({Key? key}) : super(key: key);

  @override
  State<DisasterActiveView> createState() => _DisasterActiveViewState();
}

class _DisasterActiveViewState extends State<DisasterActiveView> {
  final DisasterController _disasterController = Get.put(DisasterController());
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());
  @override
  void initState() {
    super.initState();
    _disasterController.getActiveDisasters();
  }

  @override
  Widget build(BuildContext context) {
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
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, right: 10.0, left: 10.0),
                    child: Text(
                      'Welcome ${_authenticationController.userName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 15.0, left: 12.0),
                    child: Text(
                      'Every help matters, extend your helping hand with Donite',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.only(top: 18.0, right: 12.0, left: 12.0),
                    child: Text(
                      'Featured posts',
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
                            _disasterController.disastersActive.value.length,
                        itemBuilder: (context, index) {
                          return ActiveTileWidget(
                            disaster: _disasterController
                                .disastersActive.value[index],
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
