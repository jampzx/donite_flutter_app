import 'package:donite/views/admin_view/admin_home_view.dart';
import 'package:donite/views/login_view.dart';
import 'package:donite/views/user_view/user_home_view.dart';
import 'package:donite/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controller/authentication_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final token = box.read('token');

    debugPrint(token.toString());
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // home: token == null
      //     ? const LoginView()
      //     : const AdminHomeView(), //remove constant after doing admin view
      home: AdminHomeView(),
    );
  }
}
