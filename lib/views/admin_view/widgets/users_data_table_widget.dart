import 'package:cool_alert/cool_alert.dart';
import 'package:donite/constants/constants.dart';
import 'package:donite/controller/authentication_controller.dart';
import 'package:donite/model/authentication_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersDataTableWidget extends StatefulWidget {
  const UsersDataTableWidget({Key? key}) : super(key: key);

  @override
  State<UsersDataTableWidget> createState() => _UsersDataTableWidgetState();
}

class _UsersDataTableWidgetState extends State<UsersDataTableWidget> {
  bool sort = true;
  Rx<List<AuthenticationModel>> filterUsers = Rx<List<AuthenticationModel>>([]);
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    filterUsers.value = _authenticationController.users.value;
    super.initState();
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
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical:
                                          10), // Adjust the vertical padding
                                ),
                                onChanged: searchUsers,
                              ),
                            ),
                            const Spacer(),
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
                        )),
                    source: RowSource(
                      context: context,
                      myData: filterUsers.value, // Use the filtered list here
                      count: filterUsers
                          .value.length, // Update the count accordingly
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

DataRow recentFileDataRow(AuthenticationModel data, BuildContext context) {
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());
  final String verified = data.verified.toString();
  return DataRow(
    cells: [
      DataCell(Text(data.name.toString())),
      DataCell(
        verified == '0'
            ? const Text(
                'Unverified',
                style: TextStyle(color: Color(0xFFFF5252)),
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
      DataCell(Text(data.id.toString())),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(
              Icons.check_circle,
              color: Color.fromARGB(255, 77, 234, 82),
              size: 22,
            ),
            onPressed: () {
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
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.cancel,
              color: Colors.redAccent,
              size: 22,
            ),
            onPressed: () {
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
