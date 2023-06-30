import 'package:donite/constants/constants.dart';
import 'package:donite/controller/disaster_controller.dart';
import 'package:donite/model/disaster_model.dart';
import 'package:donite/views/user_view/donation_form_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              child: Stack(
                children: [
                  Image.network(
                      '${baseImageUrl}storage/${widget.disaster.path!}'),
                  Positioned(
                    bottom: 10,
                    left: 5,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.black.withOpacity(0.1),
                      child: Text(
                        widget.disaster.title!,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFFFFFFF),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                showFullSizeImage(
                    '${baseImageUrl}storage/${widget.disaster.path!}', context);
              },
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      height: 15,
                    ),
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
                    const Divider(),
                  ]),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(left: 18, top: 0, right: 18, bottom: 8),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.transparent,
                    backgroundColor: const Color(0xFF7C4DFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    "Help now",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (ctx) => DonationFormView(
                              disaster_id: widget.disaster.id.toString())),
                    );
                  },
                ),
              ),
            ),

            // Add a small space between the card and the next widget
          ],
        ),
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
