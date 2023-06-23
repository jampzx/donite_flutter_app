import 'package:cool_alert/cool_alert.dart';
import 'package:donite/constants/constants.dart';
import 'package:donite/controller/disaster_controller.dart';
import 'package:donite/model/disaster_model.dart';
import 'package:donite/views/admin_view/widgets/alert_dialog_widget.dart';
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
          Image.network('${baseImageUrl}storage/${widget.disaster.path!}'),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.disaster.title!,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey[800],
                  ),
                ),
                Container(height: 10),
                // Display the card's text using a font size of 15 and a light grey color
                Text(
                  widget.disaster.information!,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                Row(
                  children: <Widget>[
                    Row(
                      children: [
                        Text('${widget.disaster.disasterType!} -'),
                        const SizedBox(
                          width: 5,
                        ),
                        Text('${widget.disaster.location!} -'),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(widget.disaster.date!),
                      ],
                    ),
                    const Spacer(),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.transparent,
                      ),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                        size: 16,
                      ),
                      label: const Text(
                        "DELETE",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      onPressed: () {
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.confirm,
                          text: "Delete this post",
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'No',
                          confirmBtnColor: const Color(0xFFFF5252),
                          width: MediaQuery.of(context).size.width * .18,
                          lottieAsset: "assets/delete2.json",
                          onConfirmBtnTap: () {
                            _disasterController.deleteDisaster(
                                id: widget.disaster.id.toString());
                          },
                        );
                      },
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.transparent,
                      ),
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.lightGreenAccent,
                        size: 16,
                      ),
                      label: const Text(
                        "EDIT",
                        style: TextStyle(color: Colors.lightGreenAccent),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialogWidget(
                            id: widget.disaster.id!,
                            title: widget.disaster.title!,
                            date: widget.disaster.date!,
                            disasterType: widget.disaster.disasterType!,
                            location: widget.disaster.location!,
                            information: widget.disaster.information!,
                            path: widget.disaster.path!,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Add a small space between the card and the next widget
          Container(height: 5),
        ],
      ),
    );
  }
}
