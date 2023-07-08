import 'package:cool_alert/cool_alert.dart';
import 'package:donite/controller/authentication_controller.dart';
import 'package:donite/controller/donation_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DonationHistoryView extends StatefulWidget {
  final String userId;

  DonationHistoryView({required this.userId});

  @override
  _DonationHistoryViewState createState() => _DonationHistoryViewState();
}

class _DonationHistoryViewState extends State<DonationHistoryView> {
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());
  final DonationController _donationController = Get.put(DonationController());

  @override
  void initState() {
    super.initState();
    _donationController.fetchDonationsPerUser(_authenticationController.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return _donationController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _donationController.donationsPerUser.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  // Return a title container for the first index
                  final currentDate =
                      DateFormat('MMMM d, y').format(DateTime.now());
                  return Card(
                    elevation: 3,
                    child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Donations History as of $currentDate',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.history,
                              color: Colors.blueAccent,
                            )
                          ],
                        )),
                  );
                } else {
                  final donation =
                      _donationController.donationsPerUser[index - 1];
                  String dateString = donation['created_at'];
                  DateTime dateTime = DateTime.parse(dateString);
                  String formattedDateTime =
                      DateFormat('MMMM d, y H:mm').format(dateTime).toString();

                  // Use the donation data to build the list item
                  return InkWell(
                    child: Card(
                      elevation: 3,
                      child: ListTile(
                        title: Text(
                          donation['donation_type'],
                          style: const TextStyle(fontSize: 12),
                        ),
                        subtitle: Text(formattedDateTime,
                            style: const TextStyle(fontSize: 12)),
                        trailing: GestureDetector(
                          child: const Icon(Icons.more_horiz),
                          onTap: () {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.info,
                              text:
                                  '${donation['name']} at age ${donation['age']} contributes ${donation['donation_info']}\n\n${donation['email']}\n${donation['contact_number']}\n \nDonation ID:${donation['id']}',
                              confirmBtnText: 'CONFIRM',
                              confirmBtnColor: const Color(0xFF448AFF),
                              lottieAsset: "assets/successful.json",
                              title: '${donation['donation_type']}',
                            );
                          },
                        ),
                      ),
                    ),
                    onTap: () {},
                  );
                }
              },
            );
    });
  }
}
