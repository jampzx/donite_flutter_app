// import 'package:donite/constants/constants.dart';
// import 'package:donite/model/disaster_model.dart';
// import 'package:donite/views/admin_view/widgets/alert_dialog_widget.dart';
// import 'package:flutter/material.dart';

// class MyTile extends StatelessWidget {
//   MyTile({super.key, required this.disaster});

//   final DisasterModel disaster;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8), color: Colors.grey[200]),
//         child: Column(children: [
//           Text(disaster.title!),
//           Text(disaster.date!),
//           Text(disaster.disasterType!),
//           Text(disaster.location!),
//           Text(disaster.information!),
//           Text(disaster.path!),
//           Text(disaster.filename!),
//           AlertDialogWidget(
//               id: disaster.id!,
//               title: disaster.title!,
//               date: disaster.date!,
//               disasterType: disaster.disasterType!,
//               location: disaster.location!,
//               information: disaster.information!,
//               path: disaster.path!),
//           Image.network('${baseImageUrl}storage/${disaster.path!}')
//         ]),
//       ),
//     );
//   }
// }

import 'package:donite/constants/constants.dart';
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
        ),
        child: Column(
          children: [
            Text(widget.disaster.title!),
            Text(widget.disaster.date!),
            Text(widget.disaster.disasterType!),
            Text(widget.disaster.location!),
            Text(widget.disaster.information!),
            Text(widget.disaster.path!),
            Text(widget.disaster.filename!),
            AlertDialogWidget(
              id: widget.disaster.id!,
              title: widget.disaster.title!,
              date: widget.disaster.date!,
              disasterType: widget.disaster.disasterType!,
              location: widget.disaster.location!,
              information: widget.disaster.information!,
              path: widget.disaster.path!,
            ),
            Image.network('${baseImageUrl}storage/${widget.disaster.path!}'),
          ],
        ),
      ),
    );
  }
}
