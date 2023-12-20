import 'package:donite/controller/authentication_controller.dart';
import 'package:donite/views/constants.dart';
import 'package:donite/views/login_view.dart';
import 'package:donite/views/user_view/reset_password_view.dart';
import 'package:donite/views/user_view/user_constants.dart';
import 'package:donite/views/user_view/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class DeclinedView extends StatefulWidget {
  DeclinedView({Key? key}) : super(key: key);

  @override
  _DeclinedViewState createState() => _DeclinedViewState();
}

class _DeclinedViewState extends State<DeclinedView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar,
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: size.width > 600
          //     ? MainAxisAlignment.center
          //     : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            size.width > 600
                ? Container()
                : Center(
                    child: Lottie.asset(
                      'assets/declined.json',
                      height: size.width * 0.45,
                      width: size.width * 0.45,
                      fit: BoxFit.fill,
                    ),
                  ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'DECLINED',
              style: kWaitingVerificationStyle(size),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13, right: 13),
              child: Text(
                'Your account was declined due to insufficient details provided\n Please register again and provide correct information',
                style: kLoginTermsAndPrivacyStyle(size),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            understandButton()
          ],
        ),
      ),
    );
  }

  Widget understandButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          onPressed: () async {
            Navigator.push(
                context, MaterialPageRoute(builder: (ctx) => LoginView()));
          },
          child: const Text('CONFIRM'),
        ),
      ),
    );
  }
}
