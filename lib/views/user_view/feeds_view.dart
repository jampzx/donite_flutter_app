import 'package:donite/controller/authentication_controller.dart';
import 'package:donite/controller/disaster_controller.dart';
import 'package:donite/controller/feed_controller.dart';
import 'package:donite/views/constants.dart';
import 'package:donite/views/user_view/user_constants.dart';
import 'package:donite/views/user_view/widgets/feed_tile_widget.dart';
import 'package:donite/views/user_view/widgets/active_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedView extends StatefulWidget {
  const FeedView({Key? key}) : super(key: key);

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  final FeedController _feedController = Get.put(FeedController());

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
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, right: 10.0, left: 10.0),
                    child: Text(
                      'Welcome to news section',
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
                      'Get updated with the latest donite activities',
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
                      'latest news',
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
                return _feedController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _feedController.feeds.value.length,
                        itemBuilder: (context, index) {
                          return FeedTileWidget(
                            feed: _feedController.feeds.value[index],
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
