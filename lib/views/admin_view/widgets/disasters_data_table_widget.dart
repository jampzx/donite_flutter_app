import 'package:cool_alert/cool_alert.dart';
import 'package:donite/constants/constants.dart';
import 'package:donite/controller/disaster_controller.dart';
import 'package:donite/model/disaster_model.dart';
import 'package:donite/views/admin_view/widgets/alert_create_dialog_widget.dart';
import 'package:donite/views/admin_view/widgets/alert_offline_create_dialog_widget.dart';
import 'package:donite/views/admin_view/widgets/alert_update_dialog_widget.dart';
import 'package:donite/views/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show ByteData, rootBundle;

class DisastersDataTableWidget extends StatefulWidget {
  const DisastersDataTableWidget({Key? key}) : super(key: key);

  @override
  State<DisastersDataTableWidget> createState() =>
      _DisastersDataTableWidgetState();
}

class _DisastersDataTableWidgetState extends State<DisastersDataTableWidget> {
  bool sort = true;
  Rx<List<DisasterModel>> filterDisasters = Rx<List<DisasterModel>>([]);
  final DisasterController _disasterController = Get.put(DisasterController());
  TextEditingController controller = TextEditingController();

  List<String> combinedFilterOptions = [
    'All',
    'Active',
    'Inactive',
    'Ashfall',
    'Earthquake',
    'El Nino',
    'Flash floods',
    'Flood',
    'Flood due to heavy rainfall',
    'Heatwaves',
    'Landslide',
    'Lava Flow',
    'La Nina',
    'Mudflow/Rockfall',
    'Thunderstorm',
    'Tornado',
    'Tropical Cyclone',
    'Tropical Depressions',
    'Tropical Storms',
    'Tsunami',
    'Typhoon',
    'Volcanic ashfall',
    'Volcanic eruption',
    'Wave/surge',
    'Wind storm',
    'Wildfire',
  ];
  String selectedFilter = 'All'; // Default value

  @override
  void initState() {
    filterDisasters.value = _disasterController.disasters.value;
    super.initState();
  }

  void filterData() {
    setState(() {
      if (selectedFilter == 'All') {
        filterDisasters.value = _disasterController.disasters.value;
      } else {
        filterDisasters.value = _disasterController.disasters.value
            .where((disaster) =>
                getDisasterStatus(disaster) == selectedFilter ||
                disaster.disasterType == selectedFilter)
            .toList();
      }
    });
  }

  String getDisasterStatus(DisasterModel disaster) {
    if (disaster.active == 1) {
      return 'Active';
    } else if (disaster.active == 0) {
      return 'Inactive';
    } else {
      return 'Unknown Status';
    }
  }

  void searchDisasters(String keyword) {
    setState(() {
      if (_disasterController.disasters.value.isEmpty) {
        filterDisasters.value =
            _disasterController.disasters.value; // Revert to the original list
      } else if (keyword.isEmpty) {
        filterDisasters.value = _disasterController.disasters.value;
      } else {
        filterDisasters.value = _disasterController.disasters.value
            .where((disaster) =>
                disaster.title!.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Theme(
                  data: ThemeData.light().copyWith(
                    cardColor: Theme.of(context).canvasColor,
                  ),
                  child: PaginatedDataTable(
                    sortColumnIndex: 0,
                    sortAscending: sort,
                    header: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 300.0,
                                child: TextField(
                                  decoration: const InputDecoration(
                                    hintText: "Type title...",
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.black26,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black26,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6)),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical:
                                            10), // Adjust the vertical padding
                                  ),
                                  onChanged: searchDisasters,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 250,
                                child: DropdownButtonFormField<String>(
                                  value: selectedFilter,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedFilter = newValue!;
                                      filterData();
                                    });
                                  },
                                  items: combinedFilterOptions
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 40,
                              ),
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        const Color.fromARGB(255, 77, 234, 82)),
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                label: const Text(
                                  "POST",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        const AlertCreateDialogWidget(
                                      alertFor: 'disaster',
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color.fromARGB(
                                        255, 86, 118, 247)),
                                icon: const Icon(
                                  Icons.sync,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                label: const Text(
                                  "SYNC",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  _disasterController.uploadDataToServer();
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        const Color.fromARGB(255, 211, 226, 4)),
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                label: const Text(
                                  "REFRESH",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  _disasterController.getAllDisasters();
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        const Color.fromARGB(255, 57, 56, 59)),
                                icon: const Icon(
                                  Icons
                                      .signal_wifi_connected_no_internet_4_outlined,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                label: const Text(
                                  "OFFLINE POST",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        const AlertOfflineCreateDialogWidget(
                                      alertFor: 'disaster',
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        )),
                    source: RowSource(
                      context: context,
                      myData:
                          filterDisasters.value, // Use the filtered list here
                      count: filterDisasters
                          .value.length, // Update the count accordingly
                    ),
                    rowsPerPage: 10,
                    columnSpacing: 5,
                    columns: [
                      DataColumn(
                        label: const Text(
                          "Title",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            sort = !sort;
                          });
                          onSortColumn(columnIndex, ascending);
                        },
                      ),
                      const DataColumn(
                        label: Text(
                          "Date",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          "Information",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          "Location",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          "Type",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          "Image",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      // const DataColumn(
                      //   label: Text(
                      //     "ID",
                      //     style: TextStyle(
                      //       fontWeight: FontWeight.w600,
                      //       fontSize: 14,
                      //     ),
                      //   ),
                      // ),
                      const DataColumn(
                        label: Text(
                          "Function",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      const DataColumn(
                        label: Text(
                          "Modify Status",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          "Download",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void onSortColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      setState(() {
        if (ascending) {
          filterDisasters.value.sort((a, b) => a.title!.compareTo(b.title!));
        } else {
          filterDisasters.value.sort((a, b) => b.title!.compareTo(a.title!));
        }
      });
    }
  }
}

class RowSource extends DataTableSource {
  final List<DisasterModel> myData;
  final int count;
  final BuildContext context;

  RowSource({required this.myData, required this.count, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index < count) {
      return recentFileDataRow(myData[index], context);
    } else {
      return null;
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}

DataRow recentFileDataRow(DisasterModel data, BuildContext context) {
  final DisasterController _disasterController = Get.put(DisasterController());

  String info = data.information!.toString();

  return DataRow(
    cells: [
      DataCell(Text(data.title.toString())),
      DataCell(Text(data.date.toString())),
      DataCell(InformationTrimmed(info)),
      DataCell(Text(data.location.toString())),
      DataCell(Text(data.disasterType.toString())),
      DataCell(data.path != 'none'
          ? GestureDetector(
              onTap: () {
                showFullSizeImage(
                    '${baseImageUrl}storage/${data.path}', context);
              },
              child: Image.network(
                '${baseImageUrl}storage/${data.path}',
                width: 30,
                height: 30,
              ),
            )
          : const Text('No Image')),
      // ignore: unrelated_type_equality_checks
      //DataCell(Text(data.id.toString())),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // IconButton(
          //   icon: const Icon(
          //     Icons.edit,
          //     color: Color.fromARGB(255, 77, 234, 82),
          //     size: 18,
          //   ),
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       builder: (BuildContext context) => AlertUpdateDialogWidget(
          //         id: data.id!,
          //         title: data.title!,
          //         date: data.date!,
          //         disasterType: data.disasterType!,
          //         location: data.location!,
          //         information: data.information!,
          //         path: data.path!,
          //         alertFor: 'disaster',
          //       ),
          //     );
          //   },
          // ),
          TextButton.icon(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20), // Adjust the value as needed
              ),
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 77, 234, 82),
            ),
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 12,
            ),
            label: const Text(
              "Edit",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertUpdateDialogWidget(
                  id: data.id!,
                  title: data.title!,
                  date: data.date!,
                  disasterType: data.disasterType!,
                  location: data.location!,
                  information: data.information!,
                  path: data.path!,
                  alertFor: 'disaster',
                ),
              );
            },
          ),

          // IconButton(
          //   icon: const Icon(
          //     Icons.delete,
          //     color: Colors.redAccent,
          //     size: 18,
          //   ),
          //   onPressed: () {
          //     CoolAlert.show(
          //       context: context,
          //       type: CoolAlertType.confirm,
          //       text: "Delete this post",
          //       confirmBtnText: 'Yes',
          //       cancelBtnText: 'No',
          //       confirmBtnColor: const Color(0xFFFF5252),
          //       width: MediaQuery.of(context).size.width * .18,
          //       lottieAsset: "assets/delete2.json",
          //       onConfirmBtnTap: () {
          //         _disasterController.deleteDisaster(id: data.id.toString());
          //       },
          //     );
          //   },
          // ),
          const SizedBox(
            width: 10,
          ),
          TextButton.icon(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20), // Adjust the value as needed
              ),
              foregroundColor: Colors.white,
              backgroundColor: Colors.redAccent,
            ),
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 12,
            ),
            label: const Text(
              "Delete",
              style: TextStyle(color: Colors.white, fontSize: 12),
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
                  _disasterController.deleteDisaster(id: data.id.toString());
                },
              );
            },
          ),
        ],
      )),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // IconButton(
          //   icon: const Icon(
          //     Icons.check_circle,
          //     color: Color.fromARGB(255, 77, 234, 82),
          //     size: 18,
          //   ),
          //   onPressed: () {
          //     CoolAlert.show(
          //       context: context,
          //       type: CoolAlertType.confirm,
          //       text: "Mark this disaster as active",
          //       confirmBtnText: 'Yes',
          //       cancelBtnText: 'No',
          //       confirmBtnColor: const Color.fromARGB(255, 77, 234, 82),
          //       width: MediaQuery.of(context).size.width * .18,
          //       lottieAsset: "assets/question-mark.json",
          //       onConfirmBtnTap: () {
          //         _disasterController.updateActiveDisaster(
          //             id: data.id.toString(), active: true);
          //       },
          //     );
          //   },
          // ),
          TextButton.icon(
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: data.active == 0
                        ? Color.fromARGB(255, 77, 234, 82)
                        : Colors.white,
                    width: 1.0,
                  ),
                  // Adjust the value as needed
                ),
                foregroundColor: data.active == 0
                    ? Color.fromARGB(255, 77, 234, 82)
                    : Colors.white,
                backgroundColor: data.active == 0
                    ? Colors.white
                    : Color.fromARGB(255, 77, 234, 82)),
            icon: Icon(
              Icons.check_circle,
              color: data.active == 0
                  ? Color.fromARGB(255, 77, 234, 82)
                  : Colors.white,
              size: 12,
            ),
            label: Text(
              "Active",
              style: TextStyle(
                  color: data.active == 0
                      ? Color.fromARGB(255, 77, 234, 82)
                      : Colors.white,
                  fontSize: 12),
            ),
            onPressed: () {
              data.active == 0
                  ? CoolAlert.show(
                      context: context,
                      type: CoolAlertType.confirm,
                      text: "Mark this disaster as active",
                      confirmBtnText: 'Yes',
                      cancelBtnText: 'No',
                      confirmBtnColor: const Color.fromARGB(255, 77, 234, 82),
                      width: MediaQuery.of(context).size.width * .18,
                      lottieAsset: "assets/question-mark.json",
                      onConfirmBtnTap: () {
                        _disasterController.updateActiveDisaster(
                            id: data.id.toString(), active: true);
                      },
                    )
                  : null;
            },
          ),
          SizedBox(
            width: 5,
          ),
          TextButton.icon(
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: data.active == 1 ? Colors.redAccent : Colors.white,
                    width: 1.0,
                  ),
                  // Adjust the value as needed
                ),
                foregroundColor:
                    data.active == 1 ? Colors.redAccent : Colors.white,
                backgroundColor:
                    data.active == 1 ? Colors.white : Colors.redAccent),
            icon: Icon(
              Icons.cancel,
              color: data.active == 1 ? Colors.redAccent : Colors.white,
              size: 12,
            ),
            label: Text(
              "Inactive",
              style: TextStyle(
                  color: data.active == 1 ? Colors.redAccent : Colors.white,
                  fontSize: 12),
            ),
            onPressed: () {
              data.active == 1
                  ? CoolAlert.show(
                      context: context,
                      type: CoolAlertType.confirm,
                      text: "Mark this disaster as inactive",
                      confirmBtnText: 'Yes',
                      cancelBtnText: 'No',
                      confirmBtnColor: Colors.redAccent,
                      width: MediaQuery.of(context).size.width * .18,
                      lottieAsset: "assets/question-mark.json",
                      onConfirmBtnTap: () {
                        _disasterController.updateActiveDisaster(
                            id: data.id.toString(), active: false);
                      },
                    )
                  : null;
            },
          ),

          // IconButton(
          //   icon: const Icon(
          //     Icons.cancel,
          //     color: Colors.redAccent,
          //     size: 18,
          //   ),
          //   onPressed: () {
          //     CoolAlert.show(
          //       context: context,
          //       type: CoolAlertType.confirm,
          //       text: "Mark this disaster as inactive",
          //       confirmBtnText: 'Yes',
          //       cancelBtnText: 'No',
          //       confirmBtnColor: const Color.fromARGB(255, 77, 234, 82),
          //       width: MediaQuery.of(context).size.width * .18,
          //       lottieAsset: "assets/question-mark.json",
          //       onConfirmBtnTap: () {
          //         _disasterController.updateActiveDisaster(
          //             id: data.id.toString(), active: false);
          //       },
          //     );
          //   },
          // ),
        ],
      )),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(
              Icons.download,
              color: foregroundColor(),
              size: 18,
            ),
            onPressed: () {
              CoolAlert.show(
                context: context,
                type: CoolAlertType.confirm,
                text: "Download PDF",
                confirmBtnText: 'Yes',
                cancelBtnText: 'No',
                confirmBtnColor: const Color.fromARGB(255, 77, 234, 82),
                width: MediaQuery.of(context).size.width * .18,
                lottieAsset: "assets/question-mark.json",
                onConfirmBtnTap: () {
                  generatePDF(data);
                },
              );
            },
          ),
        ],
      )),
    ],
  );
}

// ignore: non_constant_identifier_names
Text InformationTrimmed(String text) {
  // Extract the first three words from the text
  RegExp regex = RegExp(r'^(\w+\s+\w+\s+\w+)');
  String trimmedText = regex.firstMatch(text)?.group(0) ?? '';

  if (trimmedText.length < text.length) {
    trimmedText += '...';
  }
  return Text(
    trimmedText,
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
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

Future<void> generatePDF(DisasterModel data) async {
  final pdf = pdfLib.Document();

  // Fetch the image bytes if path is not 'none'
  Uint8List? imageBytes;
  if (data.path != 'none') {
    imageBytes = await _getImageBytes('${baseImageUrl}storage/${data.path!}');
  }

  final Uint8List imageLogo1 = await _getAssetImageBytes('assets/mdrrmo.png');
  final Uint8List imageLogo2 =
      await _getAssetImageBytes('assets/donitelogo.jpeg');

  pdf.addPage(
    pdfLib.Page(
      build: (context) {
        return pdfLib.Column(
          crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
          children: [
            pdfLib.Row(
              mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
              children: [
                pdfLib.Image(pdfLib.MemoryImage(imageLogo1),
                    width: 60, height: 60),
                pdfLib.Text(
                  'DONITE: Donation & Volunteerism',
                  style: pdfLib.TextStyle(
                      fontWeight: pdfLib.FontWeight.bold, fontSize: 16),
                ),
                pdfLib.Image(pdfLib.MemoryImage(imageLogo2),
                    width: 60, height: 60),
              ],
            ),
            pdfLib.SizedBox(height: 40),

            pdfLib.Row(
              mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
              children: [
                pdfLib.Text('Title: ${data.title ?? ''}'),
                pdfLib.Text('Location: ${data.location ?? ''}'),
              ],
            ),
            pdfLib.SizedBox(height: 10),

            // Location and Date
            pdfLib.Row(
              mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
              children: [
                pdfLib.Text('Date: ${data.date ?? ''}'),
                pdfLib.Text('Type: ${data.disasterType ?? ''}'),
              ],
            ),
            pdfLib.SizedBox(height: 10),

            // Image (conditionally)
            if (imageBytes != null)
              pdfLib.Center(
                child: pdfLib.Image(
                  pdfLib.MemoryImage(imageBytes),
                ),
              ),
            pdfLib.SizedBox(height: 10),

            // Information
            pdfLib.Text('Information: ${data.information ?? ''}'),

            pdfLib.SizedBox(height: 30),

            // Contact Information
            pdfLib.Text(
              'Contact Information',
              style: pdfLib.TextStyle(
                fontWeight: pdfLib.FontWeight.bold,
                fontSize: 12,
              ),
            ),
            pdfLib.SizedBox(height: 10),

            pdfLib.Text(
              'Email: donitemanagementsystem@gmail.com',
              style: const pdfLib.TextStyle(
                fontSize: 12,
              ),
            ),
            pdfLib.Text(
              'Facebook: www.facebook.com/donite',
              style: const pdfLib.TextStyle(
                fontSize: 12,
              ),
            ),
            pdfLib.Text(
              'Address: Bauang La Union',
              style: const pdfLib.TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        );
      },
    ),
  );

  // Get the application documents directory
  final directory = await getApplicationDocumentsDirectory();
  final String path = '${directory.path}/disasters_report.pdf';

  // Save the PDF file
  final File file = File(path);
  await file.writeAsBytes(await pdf.save());

  // Open the PDF file
  OpenFile.open(file.path);
}

// Future<void> generatePDF(DisasterModel data) async {
//   final pdf = pdfLib.Document();

//   // Fetch the image bytes
//   final Uint8List imageBytes =
//       await _getImageBytes('${baseImageUrl}storage/${data.path!}');

//   final Uint8List imageLogo1 = await _getAssetImageBytes('assets/mdrrmo.png');
//   final Uint8List imageLogo2 =
//       await _getAssetImageBytes('assets/donitelogo.jpeg');

//   pdf.addPage(
//     pdfLib.Page(
//       build: (context) {
//         return pdfLib.Column(
//           crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
//           children: [
//             pdfLib.Row(
//               mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
//               children: [
//                 pdfLib.Image(pdfLib.MemoryImage(imageLogo1),
//                     width: 60, height: 60),
//                 pdfLib.Text(
//                   'DONITE: Donation & Volunteerism',
//                   style: pdfLib.TextStyle(
//                       fontWeight: pdfLib.FontWeight.bold, fontSize: 16),
//                 ),
//                 pdfLib.Image(pdfLib.MemoryImage(imageLogo2),
//                     width: 60, height: 60),
//               ],
//             ),
//             pdfLib.SizedBox(height: 40),

//             pdfLib.Row(
//               mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
//               children: [
//                 pdfLib.Text('Title: ${data.title ?? ''}'),
//                 pdfLib.Text('Location: ${data.location ?? ''}'),
//               ],
//             ),
//             pdfLib.SizedBox(height: 10),

//             // Location and Date
//             pdfLib.Row(
//               mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
//               children: [
//                 pdfLib.Text('Date: ${data.date ?? ''}'),
//                 pdfLib.Text('Type: ${data.disasterType ?? ''}'),
//               ],
//             ),
//             pdfLib.SizedBox(height: 10),

//             // Image
//             pdfLib.Center(
//               child: pdfLib.Image(
//                 pdfLib.MemoryImage(imageBytes),
//               ),
//             ),
//             pdfLib.SizedBox(height: 10),

//             // Information
//             pdfLib.Text('Information: ${data.information ?? ''}'),

//             pdfLib.SizedBox(height: 30),

//             // Contact Information
//             pdfLib.Text(
//               'Contact Information',
//               style: pdfLib.TextStyle(
//                 fontWeight: pdfLib.FontWeight.bold,
//                 fontSize: 12,
//               ),
//             ),
//             pdfLib.SizedBox(height: 10),

//             pdfLib.Text(
//               'Email: donitemanagementsystem@gmail.com',
//               style: const pdfLib.TextStyle(
//                 fontSize: 12,
//               ),
//             ),
//             pdfLib.Text(
//               'Facebook: www.facebook.com/donite',
//               style: const pdfLib.TextStyle(
//                 fontSize: 12,
//               ),
//             ),
//             pdfLib.Text(
//               'Address: Bauang La Union',
//               style: const pdfLib.TextStyle(
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         );
//       },
//     ),
//   );

//   // Get the application documents directory
//   final directory = await getApplicationDocumentsDirectory();
//   final String path = '${directory.path}/disasters_report.pdf';

//   // Save the PDF file
//   final File file = File(path);
//   await file.writeAsBytes(await pdf.save());

//   // Open the PDF file
//   OpenFile.open(file.path);
// }

// Helper function to fetch image bytes from a URL
Future<Uint8List> _getImageBytes(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load image');
  }
}

Future<Uint8List> _getAssetImageBytes(String assetPath) async {
  final ByteData data = await rootBundle.load(assetPath);
  return data.buffer.asUint8List();
}
