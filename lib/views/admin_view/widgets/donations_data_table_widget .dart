import 'package:cool_alert/cool_alert.dart';
import 'package:donite/controller/donation_controller.dart';
import 'package:donite/model/donation_model.dart';
import 'package:donite/views/user_view/donation_form_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DonationsDataTableWidget extends StatefulWidget {
  final void Function() updateVerificationCountsCallback;

  const DonationsDataTableWidget({
    Key? key,
    required this.updateVerificationCountsCallback,
  }) : super(key: key);
  @override
  State<DonationsDataTableWidget> createState() =>
      _DonationsDataTableWidgetState();
}

class _DonationsDataTableWidgetState extends State<DonationsDataTableWidget> {
  bool sort = true;
  Rx<List<DonationModel>> filterDonations = Rx<List<DonationModel>>([]);
  final DonationController _donationController = Get.put(DonationController());
  TextEditingController controller = TextEditingController();

  List<String> combinedFilterOptions = [
    'All',
    'Verified',
    'Unverified',
    'Declined',
    'Cash donation',
    'Goods donation',
    'Volunteer'
  ];
  String selectedFilter = 'All'; // Default value

  @override
  void initState() {
    filterDonations.value = _donationController.donations.value;
    filterData();

    super.initState();
  }

  void filterData() {
    setState(() {
      if (selectedFilter == 'All') {
        filterDonations.value = _donationController.donations.value;
      } else {
        filterDonations.value = _donationController.donations.value
            .where((donation) =>
                getDonationStatus(donation) == selectedFilter ||
                donation.donationType == selectedFilter)
            .toList();
      }
    });
  }

  String getDonationStatus(DonationModel donation) {
    if (donation.verified == 0) {
      return 'Unverified';
    } else if (donation.verified == 1) {
      return 'Verified';
    } else if (donation.verified == 2) {
      return 'Declined';
    } else {
      return 'Unknown Status';
    }
  }

  void searchDonations(String keyword) {
    setState(() {
      if (_donationController.donations.value.isEmpty) {
        filterDonations.value =
            _donationController.donations.value; // Revert to the original list
      } else if (keyword.isEmpty) {
        filterDonations.value = _donationController.donations.value;
      } else {
        filterDonations.value = _donationController.donations.value
            .where((donation) =>
                donation.name!.toLowerCase().contains(keyword.toLowerCase()))
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
                                    hintText: "Type name...",
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
                                  onChanged: searchDonations,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 200,
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
                                  backgroundColor: Colors.orangeAccent,
                                ),
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                label: const Text(
                                  "ADD",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (ctx) => DonationFormView(
                                            disaster_id: 010.toString())),
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
                                        const Color.fromARGB(255, 77, 234, 82)),
                                icon: const Icon(
                                  Icons.save,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                label: const Text(
                                  "EXPORT",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.confirm,
                                    text: "Export to excel",
                                    confirmBtnText: 'Yes',
                                    cancelBtnText: 'No',
                                    confirmBtnColor:
                                        Color.fromARGB(255, 80, 206, 2),
                                    width:
                                        MediaQuery.of(context).size.width * .18,
                                    lottieAsset: "assets/question-mark.json",
                                    onConfirmBtnTap: () {
                                      exportToExcel(
                                          _donationController.donations.value,
                                          context);
                                    },
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
                                        const Color.fromARGB(255, 77, 93, 234)),
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
                                  _donationController.getAllDonations();
                                },
                              ),
                            ],
                          ),
                        )),
                    source: RowSource(
                        context: context,
                        myData:
                            filterDonations.value, // Use the filtered list here
                        count: filterDonations.value.length,
                        updateVerificationCountsCallback:
                            widget.updateVerificationCountsCallback
                        // Update the count accordingly
                        ),
                    rowsPerPage: 10,
                    columnSpacing: 5,
                    columns: [
                      DataColumn(
                        label: const Text(
                          "Name",
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
                          "Support Type",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          "Quantity/Info",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          "Support Name",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          "Email",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          "Contact Number",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          "Age",
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
                      // const DataColumn(
                      //   label: Text(
                      //     "User ID",
                      //     style: TextStyle(
                      //       fontWeight: FontWeight.w600,
                      //       fontSize: 14,
                      //     ),
                      //   ),
                      // ),
                      const DataColumn(
                        label: Text(
                          "Status",
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
          filterDonations.value.sort((a, b) => a.name!.compareTo(b.name!));
        } else {
          filterDonations.value.sort((a, b) => b.name!.compareTo(a.name!));
        }
      });
    }
  }
}

class RowSource extends DataTableSource {
  final List<DonationModel> myData;
  final int count;
  final BuildContext context;
  final void Function() updateVerificationCountsCallback;

  RowSource({
    required this.myData,
    required this.count,
    required this.context,
    required this.updateVerificationCountsCallback,
  });

  @override
  DataRow? getRow(int index) {
    if (index < count) {
      return recentFileDataRow(
        myData[index],
        context,
        updateVerificationCountsCallback,
      );
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

DataRow recentFileDataRow(DonationModel data, BuildContext context,
    void Function() updateVerificationCountsCallback) {
  final DonationController _donationController = Get.put(DonationController());
  final String verified = data.verified.toString();

  return DataRow(
    cells: [
      DataCell(Text(data.name.toString())),

      DataCell(Text(data.donationType.toString())),
      DataCell(Text(data.donationInfo.toString())),
      DataCell(Text(data.goodsType.toString())),
      DataCell(Text(data.email.toString())),
      DataCell(Text(data.contactNumber.toString())),
      DataCell(Text(data.age.toString())),
      // DataCell(Text(data.id.toString())),
      // DataCell(Text(data.userId.toString())),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextButton.icon(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: data.verified == 1
                      ? Colors.white
                      : (data.verified == 0
                          ? Color.fromARGB(255, 77, 234, 82)
                          : Color.fromARGB(255, 77, 234, 82)),
                  width: 1.0,
                ),
              ),
              foregroundColor: data.verified == 1
                  ? Color.fromARGB(255, 77, 234, 82)
                  : (data.verified == 0 ? Colors.white : Colors.white),
              backgroundColor: data.verified == 1
                  ? Color.fromARGB(255, 77, 234, 82)
                  : (data.verified == 0 ? Colors.white : Colors.white),
            ),
            icon: Icon(
              Icons.check_circle,
              color: data.verified == 1
                  ? Colors.white
                  : (data.verified == 0
                      ? Color.fromARGB(255, 77, 234, 82)
                      : Color.fromARGB(255, 77, 234, 82)),
              size: 12,
            ),
            label: Text(
              "Verified",
              style: TextStyle(
                color: data.verified == 1
                    ? Colors.white
                    : (data.verified == 0
                        ? Color.fromARGB(255, 77, 234, 82)
                        : Color.fromARGB(255, 77, 234, 82)),
                fontSize: 12,
              ),
            ),
            onPressed: () {
              if (data.verified != 1) {
                CoolAlert.show(
                  context: context,
                  type: CoolAlertType.confirm,
                  text: "Verify this donation",
                  confirmBtnText: 'Yes',
                  cancelBtnText: 'No',
                  confirmBtnColor: const Color.fromARGB(255, 77, 234, 82),
                  width: MediaQuery.of(context).size.width * .18,
                  lottieAsset: "assets/question-mark.json",
                  onConfirmBtnTap: () {
                    _donationController.updateDonation(
                      id: data.id.toString(),
                      verified: 1,
                    );
                    updateVerificationCountsCallback(); // Call the callback function
                  },
                );
              }
            },
          ),
          SizedBox(width: 5),
          TextButton.icon(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: data.verified == 0
                      ? Colors.white
                      : (data.verified == 1
                          ? Colors.orangeAccent
                          : Colors.orangeAccent),
                  width: 1.0,
                ),
              ),
              foregroundColor: data.verified == 0
                  ? Colors.orangeAccent
                  : (data.verified == 1 ? Colors.white : Colors.white),
              backgroundColor: data.verified == 0
                  ? Colors.orangeAccent
                  : (data.verified == 1 ? Colors.white : Colors.white),
            ),
            icon: Icon(
              Icons.question_mark_rounded,
              color: data.verified == 0
                  ? Colors.white
                  : (data.verified == 1
                      ? Colors.orangeAccent
                      : Colors.orangeAccent),
              size: 12,
            ),
            label: Text(
              "Unverified",
              style: TextStyle(
                color: data.verified == 0
                    ? Colors.white
                    : (data.verified == 1
                        ? Colors.orangeAccent
                        : Colors.orangeAccent),
                fontSize: 12,
              ),
            ),
            onPressed: () {},
          ),
          SizedBox(width: 5),
          TextButton.icon(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: data.verified == 2
                      ? Colors.white
                      : (data.verified == 1
                          ? Colors.redAccent
                          : Colors.redAccent),
                  width: 1.0,
                ),
              ),
              foregroundColor: data.verified == 2
                  ? Colors.white
                  : (data.verified == 1 ? Colors.redAccent : Colors.redAccent),
              backgroundColor: data.verified == 2
                  ? Colors.redAccent
                  : (data.verified == 1 ? Colors.white : Colors.white),
            ),
            icon: Icon(
              Icons.cancel,
              color: data.verified == 2
                  ? Colors.white
                  : (data.verified == 1 ? Colors.redAccent : Colors.redAccent),
              size: 12,
            ),
            label: Text(
              "Declined",
              style: TextStyle(
                color: data.verified == 2
                    ? Colors.white
                    : (data.verified == 1
                        ? Colors.redAccent
                        : Colors.redAccent),
                fontSize: 12,
              ),
            ),
            onPressed: () {
              if (data.verified != 2) {
                CoolAlert.show(
                  context: context,
                  type: CoolAlertType.confirm,
                  text: "Decline this donation",
                  confirmBtnText: 'Yes',
                  cancelBtnText: 'No',
                  confirmBtnColor: const Color.fromARGB(255, 77, 234, 82),
                  width: MediaQuery.of(context).size.width * .18,
                  lottieAsset: "assets/question-mark.json",
                  onConfirmBtnTap: () {
                    _donationController.updateDonation(
                      id: data.id.toString(),
                      verified: 2,
                    );
                    updateVerificationCountsCallback(); // Call the callback function
                  },
                );
              }
            },
          ),
          //   IconButton(
          //     icon: const Icon(
          //       Icons.check_circle,
          //       color: Color.fromARGB(255, 77, 234, 82),
          //       size: 22,
          //     ),
          //     onPressed: () {
          //       CoolAlert.show(
          //         context: context,
          //         type: CoolAlertType.confirm,
          //         text: "Verify this donation",
          //         confirmBtnText: 'Yes',
          //         cancelBtnText: 'No',
          //         confirmBtnColor: const Color.fromARGB(255, 77, 234, 82),
          //         width: MediaQuery.of(context).size.width * .18,
          //         lottieAsset: "assets/question-mark.json",
          //         onConfirmBtnTap: () {
          //           _donationController.updateDonation(
          //               id: data.id.toString(), verified: 1);

          //           updateVerificationCountsCallback(); // Call the callback function
          //         },
          //       );
          //     },
          //   ),
          //   IconButton(
          //     icon: const Icon(
          //       Icons.cancel,
          //       color: Colors.redAccent,
          //       size: 22,
          //     ),
          //     onPressed: () {
          //       CoolAlert.show(
          //         context: context,
          //         type: CoolAlertType.confirm,
          //         text: "Decline this donation",
          //         confirmBtnText: 'Yes',
          //         cancelBtnText: 'No',
          //         confirmBtnColor: const Color.fromARGB(255, 77, 234, 82),
          //         width: MediaQuery.of(context).size.width * .18,
          //         lottieAsset: "assets/question-mark.json",
          //         onConfirmBtnTap: () {
          //           _donationController.updateDonation(
          //               id: data.id.toString(), verified: 2);

          //           updateVerificationCountsCallback(); // Call the callback function
          //         },
          //       );
          //     },
          //   ),
          //
        ],
      ))
    ],
  );
}

void exportToExcel(List<DonationModel> donations, BuildContext context) async {
  try {
    final Excel excel = Excel.createExcel();
    final Sheet sheet = excel['Donations'];

    // Add header row
    sheet.appendRow([
      'Name',
      'Status',
      'Support Type',
      'Quantity/Info',
      'Support Name',
      'Email',
      'Contact Number',
      'Age',
      'ID',
      'User ID',
    ]);

    // Add data rows
    for (DonationModel donation in donations) {
      sheet.appendRow([
        donation.name.toString(),
        donation.verified == 0 ? 'Unverified' : 'Verified',
        donation.donationType.toString(),
        donation.donationInfo.toString(),
        donation.goodsType.toString(),
        donation.email.toString(),
        donation.contactNumber.toString(),
        donation.age.toString(),
        donation.id.toString(),
        donation.userId.toString(),
      ]);
    }

    // Format the current date
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Define the file name
    String fileName = 'donations-$formattedDate.xlsx';

    // Get the directory for storing the Excel file
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/$fileName';

    // Save the Excel file
    File(path).writeAsBytesSync(excel.encode()!);

    // ignore: use_build_context_synchronously
    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      text: 'Excel file saved at $path',
      confirmBtnColor: const Color.fromARGB(255, 77, 234, 82),
      // ignore: use_build_context_synchronously
      width: MediaQuery.of(context).size.width * .18,
      lottieAsset: "assets/successful.json",
    );
  } catch (e) {
    print('Error in exportToExcel: $e');
  }
}
