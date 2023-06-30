import 'dart:io';
import 'package:donite/controller/authentication_controller.dart';
import 'package:donite/views/user_view/widgets/input_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import '../views/login_view.dart';
import 'constants.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());

  File? imageFile;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return _buildLargeScreen(size, theme);
              } else {
                return _buildSmallScreen(size, theme);
              }
            },
          )),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(Size size, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: RotatedBox(
            quarterTurns: 4,
            child: Lottie.asset(
              'assets/welcome2.json',
              height: size.height * 0.5,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(size, theme),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(Size size, ThemeData theme) {
    return Center(
      child: _buildMainBody(size, theme),
    );
  }

  /// Main Body
  Widget _buildMainBody(Size size, ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: size.width > 600
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          size.width > 600
              ? Container()
              : Lottie.asset(
                  'assets/wave2.json',
                  height: size.height * 0.12,
                  width: size.width,
                  fit: BoxFit.fill,
                ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Register',
              style: kLoginTitleStyle(size),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Create Account',
              style: kLoginSubtitleStyle(size),
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Form(
              child: Column(
                children: [
                  /// name
                  InputWidget(
                      keyboardType: TextInputType.text,
                      controller: _nameController,
                      hintext: 'name',
                      isObscure: false,
                      prefixicon: const Icon(
                        Icons.person,
                        color: Colors.grey,
                      )),
                  SizedBox(
                    height: size.height * 0.02,
                  ),

                  /// email
                  InputWidget(
                      keyboardType: TextInputType.text,
                      controller: _emailController,
                      hintext: 'email',
                      isObscure: false,
                      prefixicon: const Icon(
                        Icons.email,
                        color: Colors.grey,
                      )),
                  SizedBox(
                    height: size.height * 0.02,
                  ),

                  /// password
                  InputWidget(
                      keyboardType: TextInputType.text,
                      controller: _passwordController,
                      hintext: 'password',
                      isObscure: true,
                      prefixicon: const Icon(
                        Icons.lock_open,
                        color: Colors.grey,
                      )),
                  SizedBox(
                    height: size.height * 0.02,
                  ),

                  ///image
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          side: MaterialStateProperty.all(const BorderSide(
                              color: Colors.grey, width: 1.0))),
                      child: Row(
                        children: [
                          imageFile != null
                              ? const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.upload,
                                  color: Colors.grey,
                                ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          imageFile != null
                              ? const Text(
                                  'image selected',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16.0),
                                )
                              : const Text(
                                  'identification card',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16.0),
                                )
                        ],
                      ),
                      onPressed: () async {
                        pickImage();
                      },
                    ),
                  ),

                  Text(
                    'Creating an account means you\'re okay with our Terms of Services and our Privacy Policy',
                    style: kLoginTermsAndPrivacyStyle(size),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),

                  /// Register Button
                  registerButton(theme),
                  SizedBox(
                    height: size.height * 0.03,
                  ),

                  /// Navigate To Login Screen
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (ctx) => const LoginView()));
                      _nameController.clear();
                      _emailController.clear();
                      _passwordController.clear();
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account?',
                        style: kHaveAnAccountStyle(size),
                        children: [
                          TextSpan(
                              text: " Login",
                              style: kLoginOrRegisterTextStyle(size)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Register Button
  Widget registerButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: Obx(() {
        return _authenticationController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.deepPurpleAccent),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                onPressed: () async {
                  if (imageFile == null) {
                    Get.snackbar(
                        'Error', 'Please select image of your valid ID!',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                  } else {
                    await _authenticationController.register(
                        name: _nameController.text.trim(),
                        email: _emailController.text.trim(),
                        imagePath: imageFile!.path.toString().trim(),
                        password: _passwordController.text.trim());
                  }
                },
                child: const Text('Register'),
              );
      }),
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);

      setState(() {
        imageFile = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to select image: $e');
    }
  }
}
