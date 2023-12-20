import 'package:cool_alert/cool_alert.dart';
import 'package:donite/controller/authentication_controller.dart';
import 'package:donite/controller/donation_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
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
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    // _donationController.fetchDonationsPerUser(_authenticationController.userId);
    _donationController.fetchDonationsPerUser(
        box.read('userId').toString().replaceAll('"', ''));
  }

  @override
  Widget build(BuildContext context) {
    // _donationController.fetchDonationsPerUser(_authenticationController.userId);
    return Obx(() {
      return _donationController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : _donationController.donationsPerUser.isEmpty
              ? const Center(
                  child: Text('No current donation yet'),
                )
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
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
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
                      String formattedDateTime = DateFormat('MMMM d, y H:mm')
                          .format(dateTime)
                          .toString();

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
                                  text: '''
Date & time: ${formattedDateTime}
Disaster: ${donation['disaster_info']['title']}
Location: ${donation['disaster_info']['location']}

Support Form
Support Type: ${donation['donation_type']}
Support Status: ${donation['verified'] == 0 ? 'Pending' : 'Verified'}
Category: ${donation['goods_type']}
Amount/Info: ${donation['donation_info']}

Name: ${donation['name']}
Age: ${donation['age']}
Contact number: ${donation['contact_number']}
Email: ${donation['email']}
''',
                                  confirmBtnText: 'CONFIRM',
                                  confirmBtnColor: const Color(0xFF448AFF),
                                  lottieAsset: "assets/successful.json",
                                  title: 'Goods Donation',
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
