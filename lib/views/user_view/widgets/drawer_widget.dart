import 'package:donite/controller/authentication_controller.dart';
import 'package:donite/views/user_view/about_us_view.dart';
import 'package:donite/views/user_view/disasters_view.dart';
import 'package:donite/views/user_view/forgot_password_view.dart';
import 'package:donite/views/user_view/user_home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                Text(
                  _authenticationController.userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _authenticationController.userEmail,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Get.offAll(() => const UserHomeView());
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle),
            title: const Text("Donations"),
            onTap: () {
              Get.offAll(() => const UserHomeView());
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Change password"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => ForgotPasswordView()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text("About us"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => const AboutUsView()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Log out"),
            onTap: () {
              _authenticationController.logout();
            },
          ),
        ],
      ),
    );
  }
}
