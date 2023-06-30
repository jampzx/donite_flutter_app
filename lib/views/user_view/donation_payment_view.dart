import 'package:donite/controller/donation_controller.dart';
import 'package:donite/views/admin_view/admin_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DonationPaymentView extends StatefulWidget {
  const DonationPaymentView({Key? key}) : super(key: key);

  @override
  _DonationPaymentViewState createState() => _DonationPaymentViewState();
}

class _DonationPaymentViewState extends State<DonationPaymentView> {
  final DonationController _donationController = Get.put(DonationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: const Text('Buy Now'),
              onPressed: () {
                //_donationController.payment();
              },
            ),
          ],
        ),
      ),
    );
  }
}
