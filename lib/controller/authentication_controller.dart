import 'dart:convert';

import 'package:donite/constants/constants.dart';
import 'package:donite/views/admin_view/admin_home_view.dart';
import 'package:donite/views/user_view/user_home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class AuthenticationController extends GetxController {
  final isLoading = false.obs;
  final token = ''.obs;

  final box = GetStorage();

  Future register(
      {required String name,
      required String email,
      required String imagePath,
      required String password}) async {
    try {
      isLoading.value = true;

      var url = Uri.parse(baseUrl + 'register');
      var request = http.MultipartRequest('POST', url);
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      var response = await request.send();

      if (response.statusCode == 201) {
        isLoading.value = false;
        var jsonResponse = await response.stream.bytesToString();
        token.value = json.encode(json.decode(jsonResponse)['token']);
        box.write('token', token.value);
        Get.offAll(() => const UserHomeView());
      } else {
        isLoading.value = false;
        var jsonResponse = await response.stream.bytesToString();
        Get.snackbar('Error', json.encode(json.decode(jsonResponse)['message']),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }

  Future login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      var data = {'email': email, 'password': password};

      var response = await http.post(
        Uri.parse(baseUrl + 'login'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        isLoading.value = false;

        final responseData = json.decode(response.body);
        int isVerified = responseData['user']['verified'];

        if (isVerified == 1) {
          debugPrint(isVerified.toString());
          debugPrint(json.encode(json.decode(response.body)['token']));
          token.value = json.encode(json.decode(response.body)['token']);
          box.write('token', token.value);
          Get.offAll(() => const AdminHomeView());
        } else {
          debugPrint(isVerified.toString());

          Get.snackbar('Error', 'Your account is not yet verified',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      } else {
        isLoading.value = false;
        Get.snackbar(
            'Error', json.encode(json.decode(response.body)['message']),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }
}
