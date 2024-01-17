import 'package:donite/constants/constants.dart';
import 'package:donite/controller/feed_controller.dart';
import 'package:donite/model/feed_model.dart';
import 'package:donite/views/constants.dart';
import 'package:donite/views/user_view/donation_form_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FeedTileWidget extends StatefulWidget {
  FeedTileWidget({Key? key, required this.feed}) : super(key: key);

  final FeedModel feed;

  @override
  _FeedTileWidgetState createState() => _FeedTileWidgetState();
}

class _FeedTileWidgetState extends State<FeedTileWidget> {
  final FeedController _feedController = Get.put(FeedController());
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(widget.feed.createdAt.toString());
    String formattedTime = DateFormat('h:mm:ss a').format(dateTime);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widget.feed.path != 'none'
                ? GestureDetector(
                    child: Stack(
                      children: [
                        Image.network(
                            '${baseImageUrl}storage/${widget.feed.path!}'),
                        Positioned(
                          bottom: 10,
                          left: 5,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.black.withOpacity(0.1),
                            child: Text(
                              widget.feed.title!,
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
                          '${baseImageUrl}storage/${widget.feed.path!}',
                          context);
                    },
                  )
                : Container(),
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
                                Icon(
                                  Icons.calendar_month,
                                  color: foregroundColor(),
                                  size: 13,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  widget.feed.date!,
                                  style: TextStyle(
                                    color: foregroundColor(),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.timer,
                                  color: foregroundColor(),
                                  size: 13,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  formattedTime,
                                  style: TextStyle(
                                    color: foregroundColor(),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: foregroundColor(),
                                  size: 13,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  widget.feed.location!,
                                  style: TextStyle(
                                    color: foregroundColor(),
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
                        widget.feed.information!,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                        ),
                        maxLines: isExpanded ? 100 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ]),
            ),
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
