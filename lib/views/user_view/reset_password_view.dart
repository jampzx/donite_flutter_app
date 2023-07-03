import 'package:donite/controller/authentication_controller.dart';
import 'package:donite/views/constants.dart';
import 'package:donite/views/user_view/user_constants.dart';
import 'package:donite/views/user_view/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ResetPasswordView extends StatefulWidget {
  ResetPasswordView({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  _ResetPasswordViewState createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());

  bool passwordMatchError = false;

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
              height: 10,
            ),
            size.width > 600
                ? Container()
                : Center(
                    child: Lottie.asset(
                      'assets/change-passwords.json',
                      height: size.height * 0.2,
                      width: size.width * .4,
                      fit: BoxFit.fill,
                    ),
                  ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Reset Password',
              style: kForgotStyle(size),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13, right: 13),
              child: Text(
                'In order to reset your password, you must provide the 4 digit code sent to your registered email',
                style: kLoginTermsAndPrivacyStyle(size),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Form(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    InputWidget(
                        controller: codeController,
                        hintext: 'Code',
                        isObscure: false,
                        prefixicon: const Icon(Icons.security),
                        keyboardType: TextInputType.number),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    InputWidget(
                        controller: passwordController,
                        hintext: 'New password',
                        isObscure: false,
                        prefixicon: const Icon(Icons.lock_outline),
                        keyboardType: TextInputType.text),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    InputWidget(
                        controller: confirmPasswordController,
                        hintext: 'Confirm new password',
                        isObscure: false,
                        prefixicon: const Icon(Icons.lock),
                        keyboardType: TextInputType.text),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    resetButton()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget resetButton() {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: Obx(() {
        return _authenticationController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.deepPurpleAccent),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                onPressed: () async {
                  _authenticationController.resetPassword(
                      token: codeController.text.trim(),
                      email: widget.email,
                      password: passwordController.text.trim(),
                      confirmPassword: confirmPasswordController.text.trim());
                },
                child: const Text('NEXT'),
              );
      }),
    );
  }
}
