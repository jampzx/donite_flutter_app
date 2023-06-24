import 'package:cool_alert/cool_alert.dart';
import 'package:donite/constants/constants.dart';
import 'package:donite/controller/disaster_controller.dart';
import 'package:donite/model/disaster_model.dart';
import 'package:donite/views/admin_view/widgets/alert_update_dialog_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTile extends StatefulWidget {
  MyTile({Key? key, required this.disaster}) : super(key: key);

  final DisasterModel disaster;

  @override
  _MyTileState createState() => _MyTileState();
}

class _MyTileState extends State<MyTile> {
  final DisasterController _disasterController = Get.put(DisasterController());
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                widget.disaster.title!,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text(
                  widget.disaster.information!,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                  maxLines: isExpanded ? 100 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(),
              Row(
                children: <Widget>[
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            color: Color(0xFF7C4DFF),
                            size: 13,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            widget.disaster.date!,
                            style: const TextStyle(
                              color: Color(0xFF7C4DFF),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_pin,
                            color: Color(0xFF7C4DFF),
                            size: 13,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            widget.disaster.location!,
                            style: const TextStyle(
                              color: Color(0xFF7C4DFF),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ]),
          ),
          GestureDetector(
            onTap: () {
              showFullSizeImage(
                  '${baseImageUrl}storage/${widget.disaster.path!}', context);
            },
            child: Image.network(
                '${baseImageUrl}storage/${widget.disaster.path!}'),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.transparent,
              ),
              icon: const Icon(
                Icons.volunteer_activism,
                color: Colors.deepPurpleAccent,
                size: 16,
              ),
              label: const Text(
                "HELP",
                style: TextStyle(color: Colors.deepPurpleAccent),
              ),
              onPressed: () {
                // Navigator.push(
                //     context,
                //     CupertinoPageRoute(
                //         builder: (ctx) => StripePaymentScreen()));
              },
            ),
          ),

          // Add a small space between the card and the next widget
        ],
      ),
    );
  }
}

void showFullSizeImage(String imageUrl, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Image.network(imageUrl),
      );
    },
  );
}
