import 'package:cool_alert/cool_alert.dart';
import 'package:donite/constants/constants.dart';
import 'package:donite/controller/disaster_controller.dart';
import 'package:donite/model/disaster_model.dart';
import 'package:donite/views/admin_view/widgets/alert_create_dialog_widget.dart';
import 'package:donite/views/admin_view/widgets/alert_offline_create_dialog_widget.dart';
import 'package:donite/views/admin_view/widgets/alert_update_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataTableWidget extends StatefulWidget {
  const DataTableWidget({Key? key}) : super(key: key);

  @override
  State<DataTableWidget> createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  bool sort = true;
  Rx<List<DisasterModel>> filterDisasters = Rx<List<DisasterModel>>([]);
  final DisasterController _disasterController = Get.put(DisasterController());
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    filterDisasters.value = _disasterController.disasters.value;
    super.initState();
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
    return Container(
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 300.0,
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: "Type Article Title",
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
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical:
                                        10), // Adjust the vertical padding
                              ),
                              onChanged: searchDisasters,
                            ),
                          ),
                          const Spacer(),
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
                                    const AlertCreateDialogWidget(),
                              );
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromARGB(255, 86, 118, 247)),
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
                                    const AlertOfflineCreateDialogWidget(),
                              );
                            },
                          ),
                        ],
                      )),
                  source: RowSource(
                    context: context,
                    myData: filterDisasters.value, // Use the filtered list here
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
                    const DataColumn(
                      label: Text(
                        "ID",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const DataColumn(
                      label: Text(
                        "Function",
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
      DataCell(
        GestureDetector(
          onTap: () {
            showFullSizeImage('${baseImageUrl}storage/${data.path}', context);
          },
          child: Image.network(
            '${baseImageUrl}storage/${data.path}',
            width: 30,
            height: 30,
          ),
        ),
      ),
      DataCell(Text(data.id.toString())),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Color.fromARGB(255, 77, 234, 82),
              size: 16,
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
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.redAccent,
              size: 16,
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
      ))
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