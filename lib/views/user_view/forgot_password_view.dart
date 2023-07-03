import 'package:donite/controller/authentication_controller.dart';
import 'package:donite/views/constants.dart';
import 'package:donite/views/user_view/reset_password_view.dart';
import 'package:donite/views/user_view/user_constants.dart';
import 'package:donite/views/user_view/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ForgotPasswordView extends StatefulWidget {
  ForgotPasswordView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController emailController = TextEditingController();
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());
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
                      'assets/forgot-password2.json',
                      height: size.height * 0.2,
                      width: size.width * .4,
                      fit: BoxFit.fill,
                    ),
                  ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Forgot Password',
              style: kForgotStyle(size),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13, right: 13),
              child: Text(
                'In order to reset your password, you must provide the email you used to register yourself at Donite',
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
                    TextFormField(
                      keyboardType: TextInputType.text,
                      style: kTextFormFieldStyle(),
                      controller: emailController,
                      obscureText: false,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: 'email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    nextButton()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget nextButton() {
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
                  _authenticationController.sendResetEmail(
                      email: emailController.text.trim());
                },
                child: const Text('NEXT'),
              );
      }),
    );
  }
}
