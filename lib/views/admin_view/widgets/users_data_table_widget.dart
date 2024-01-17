import 'package:cool_alert/cool_alert.dart';
import 'package:donite/constants/constants.dart';
import 'package:donite/controller/authentication_controller.dart';
import 'package:donite/model/authentication_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UsersDataTableWidget extends StatefulWidget {
  final void Function() updateUserCountsCallback;

  const UsersDataTableWidget({
    Key? key,
    required this.updateUserCountsCallback,
  }) : super(key: key);

  @override
  State<UsersDataTableWidget> createState() => _UsersDataTableWidgetState();
}

class _UsersDataTableWidgetState extends State<UsersDataTableWidget> {
  bool sort = true;
  Rx<List<AuthenticationModel>> filterUsers = Rx<List<AuthenticationModel>>([]);
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());
  TextEditingController controller = TextEditingController();

  List<String> combinedFilterOptions = [
    'All',
    'Verified',
    'Unverified',
    'Declined',
  ];
  String selectedFilter = 'All'; // Default value

  @override
  void initState() {
    filterUsers.value = _authenticationController.users.value;
    super.initState();
  }

  void filterData() {
    setState(() {
      if (selectedFilter == 'All') {
        filterUsers.value = _authenticationController.users.value;
      } else {
        filterUsers.value = _authenticationController.users.value
            .where((user) => getDonationStatus(user) == selectedFilter)
            .toList();
      }
    });
  }

  String getDonationStatus(AuthenticationModel user) {
    if (user.verified == 0) {
      return 'Unverified';
    } else if (user.verified == 1) {
      return 'Verified';
    } else if (user.verified == 2) {
      return 'Declined';
    } else {
      return 'Unknown Status';
    }
  }

  void searchUsers(String keyword) {
    setState(() {
      if (_authenticationController.users.value.isEmpty) {
        filterUsers.value = _authenticationController
            .users.value; // Revert to the original list
      } else if (keyword.isEmpty) {
        filterUsers.value = _authenticationController.users.value;
      } else {
        filterUsers.value = _authenticationController.users.value
            .where((disaster) =>
                disaster.name!.toLowerCase().contains(keyword.toLowerCase()))
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
                                  onChanged: searchUsers,
                                ),
                              ),
                              //const Spacer(),
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
                                  _authenticationController.getAllUsers();
                                },
                              ),
                            ],
                          ),
                        )),
                    source: RowSource(
                      context: context,
                      myData: filterUsers.value, // Use the filtered list here
                      count: filterUsers.value.length,
                      updateUserCountsCallback: widget.updateUserCountsCallback,
                      // Update the count accordingly
                    ),
                    rowsPerPage: 10,
                    columnSpacing: 5,
                    columns: [
                      const DataColumn(
                        label: Text(
                          "Control Number",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
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
                          "Date Registered",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          "Status",
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
                          "Identfication Card",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
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
          filterUsers.value.sort((a, b) => a.name!.compareTo(b.name!));
        } else {
          filterUsers.value.sort((a, b) => b.name!.compareTo(a.name!));
        }
      });
    }
  }
}

class RowSource extends DataTableSource {
  final List<AuthenticationModel> myData;
  final int count;
  final BuildContext context;
  final void Function() updateUserCountsCallback;

  RowSource({
    required this.myData,
    required this.count,
    required this.context,
    required this.updateUserCountsCallback,
  });

  @override
  DataRow? getRow(int index) {
    if (index < count) {
      return recentFileDataRow(
          myData[index], context, updateUserCountsCallback);
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

DataRow recentFileDataRow(AuthenticationModel data, BuildContext context,
    void Function() updateUserCountsCallback) {
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());
  final String verified = data.verified.toString();
  final formattedDate = DateFormat('yyyy-MM-dd').format(data.createdAt!);

  return DataRow(
    cells: [
      DataCell(Text(data.id.toString())),
      DataCell(Text(data.name.toString())),
      DataCell(Text(formattedDate.toString())),
      DataCell(
        verified == '0'
            ? const Text(
                'Unverified',
                style: TextStyle(color: Colors.orange),
              )
            : verified == '1'
                ? const Text(
                    'Verified',
                    style: TextStyle(color: Color.fromARGB(255, 77, 234, 82)),
                  )
                : verified == '2'
                    ? const Text(
                        'Declined',
                        style: TextStyle(color: Color(0xFFFF5252)),
                      )
                    : const Text('Unknown Status'),
      ),
      DataCell(Text(data.email.toString())),
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
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // IconButton(
          //   icon: const Icon(
          //     Icons.check_circle,
          //     color: Color.fromARGB(255, 77, 234, 82),
          //     size: 22,
          //   ),
          //   onPressed: () {
          //     CoolAlert.show(
          //       context: context,
          //       type: CoolAlertType.confirm,
          //       text: "Verify this user",
          //       confirmBtnText: 'Yes',
          //       cancelBtnText: 'No',
          //       confirmBtnColor: const Color.fromARGB(255, 77, 234, 82),
          //       width: MediaQuery.of(context).size.width * .18,
          //       lottieAsset: "assets/question-mark.json",
          //       onConfirmBtnTap: () {
          //         _authenticationController.updateUser(
          //             id: data.id.toString(), verified: 1);
          //       },
          //     );
          //   },
          // ),
          // IconButton(
          //   icon: const Icon(
          //     Icons.cancel,
          //     color: Colors.redAccent,
          //     size: 22,
          //   ),
          //   onPressed: () {
          //     CoolAlert.show(
          //       context: context,
          //       type: CoolAlertType.confirm,
          //       text: "Decline verification",
          //       confirmBtnText: 'Yes',
          //       cancelBtnText: 'No',
          //       confirmBtnColor: const Color.fromARGB(255, 77, 234, 82),
          //       width: MediaQuery.of(context).size.width * .18,
          //       lottieAsset: "assets/question-mark.json",
          //       onConfirmBtnTap: () {
          //         _authenticationController.updateUser(
          //             id: data.id.toString(), verified: 2);
          //       },
          //     );
          //   },
          // ),

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
                  text: "Verify this user",
                  confirmBtnText: 'Yes',
                  cancelBtnText: 'No',
                  confirmBtnColor: const Color.fromARGB(255, 77, 234, 82),
                  width: MediaQuery.of(context).size.width * .18,
                  lottieAsset: "assets/question-mark.json",
                  onConfirmBtnTap: () {
                    _authenticationController.updateUser(
                        id: data.id.toString(), verified: 1);
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
                  text: "Decline verification",
                  confirmBtnText: 'Yes',
                  cancelBtnText: 'No',
                  confirmBtnColor: const Color.fromARGB(255, 77, 234, 82),
                  width: MediaQuery.of(context).size.width * .18,
                  lottieAsset: "assets/question-mark.json",
                  onConfirmBtnTap: () {
                    _authenticationController.updateUser(
                        id: data.id.toString(), verified: 2);
                  },
                );
              }
            },
          ),
        ],
      ))
    ],
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
