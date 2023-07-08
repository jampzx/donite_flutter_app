import 'package:donite/constants/constants.dart';
import 'package:donite/controller/disaster_controller.dart';
import 'package:donite/controller/donation_controller.dart';
import 'package:donite/model/disaster_model.dart';
import 'package:donite/model/donation_model.dart';
import 'package:donite/views/user_view/donation_form_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryTileWidget extends StatefulWidget {
  const HistoryTileWidget({Key? key, required this.donation}) : super(key: key);

  final DonationModel donation;

  @override
  // ignore: library_private_types_in_public_api
  _HistoryTileWidgetState createState() => _HistoryTileWidgetState();
}

class _HistoryTileWidgetState extends State<HistoryTileWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.donation.donationType.toString()),
      subtitle: Text(widget.donation.createdAt.toString()),
      trailing: const Icon(Icons.more_horiz),
    );
  }
}
