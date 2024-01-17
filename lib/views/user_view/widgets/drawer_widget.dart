import 'package:donite/controller/authentication_controller.dart';
import 'package:donite/views/constants.dart';
import 'package:donite/views/user_view/about_us_view.dart';
import 'package:donite/views/user_view/disaster_inactive_view.dart';
import 'package:donite/views/user_view/disasters_view.dart';
import 'package:donite/views/user_view/donation_history_view.dart';
import 'package:donite/views/user_view/feeds_view.dart';
import 'package:donite/views/user_view/forgot_password_view.dart';
import 'package:donite/views/user_view/user_home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: foregroundColor(),
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
                  box.read('userName')!.toString().replaceAll('"', ''),
                  // _authenticationController.userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  // _authenticationController.userEmail,
                  box.read('userEmail')!.toString().replaceAll('"', ''),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          // ListTile(
          //   leading: const Icon(Icons.home),
          //   title: const Text("Home"),
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.newspaper),
          //   title: const Text("News"),
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.history),
          //   title: const Text("History"),
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.check_circle),
          //   title: const Text("Supports"),
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // ),
          // const Divider(),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Change password"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => ForgotPasswordView()));
            },
          ),
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
          const Divider(),
        ],
      ),
    );
  }
}
