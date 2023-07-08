import 'package:donite/controller/authentication_controller.dart';
import 'package:donite/views/constants.dart';
import 'package:donite/views/login_view.dart';
import 'package:donite/views/user_view/reset_password_view.dart';
import 'package:donite/views/user_view/user_constants.dart';
import 'package:donite/views/user_view/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ResetPasswordSuccessView extends StatefulWidget {
  ResetPasswordSuccessView({Key? key}) : super(key: key);

  @override
  _ResetPasswordSuccessViewState createState() =>
      _ResetPasswordSuccessViewState();
}

class _ResetPasswordSuccessViewState extends State<ResetPasswordSuccessView> {
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
                      'assets/successful.json',
                      height: size.width * 0.30,
                      width: size.width * 0.30,
                      fit: BoxFit.fill,
                    ),
                  ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Password Updated',
              style: kForgotStyle(size),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13, right: 13),
              child: Text(
                'Your password was updated successfully',
                style: kLoginTermsAndPrivacyStyle(size),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            loginButton()
          ],
        ),
      ),
    );
  }

  Widget loginButton() {
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
            Get.offAll(() => const LoginView());
          },
          child: const Text('LOGIN'),
        ),
      ),
    );
  }
}
