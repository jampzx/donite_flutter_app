import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class UserHomeView extends StatefulWidget {
  const UserHomeView({super.key});

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    var token = box.read('token');
    return Scaffold(
      body: Center(child: Text(token)),
    );
  }
}
