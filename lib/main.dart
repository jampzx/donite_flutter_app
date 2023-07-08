import 'package:donite/views/admin_view/admin_home_view.dart';
import 'package:donite/views/login_view.dart';
import 'package:donite/views/user_view/forgot_password_view.dart';
import 'package:donite/views/user_view/not_verified_view.dart';
import 'package:donite/views/user_view/reset_password_success_view.dart';
import 'package:donite/views/user_view/user_home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  //Initialize Flutter Binding
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51NMQupJMTi5c9Xd0ctcdFTKJWkBoN78QKszz9ZSOZQiV9H6Wk7sGUveRe1YhSD59nPjWJZHFtu4Xzk731BJV5NMT00Y5lAufwF";

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final token = box.read('token')?.toString().replaceAll('"', "");
    final userType = box.read('userType')?.toString().replaceAll('"', "");
    debugPrint(token);
    debugPrint(userType);

    Widget homeWidget;
    if (token != null && userType == 'user') {
      homeWidget = const UserHomeView();
    } else if (token != null && userType == 'admin') {
      homeWidget = const AdminHomeView();
    } else {
      homeWidget = const LoginView();
    }

    debugPrint(token.toString());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginView(),
    );
  }
}
