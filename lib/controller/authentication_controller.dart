import 'dart:convert';

import 'package:donite/constants/constants.dart';
import 'package:donite/model/authentication_model.dart';
import 'package:donite/views/admin_view/admin_home_view.dart';
import 'package:donite/views/login_view.dart';
import 'package:donite/views/user_view/not_verified_view.dart';
import 'package:donite/views/user_view/reset_password_success_view.dart';
import 'package:donite/views/user_view/reset_password_view.dart';
import 'package:donite/views/user_view/user_home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class AuthenticationController extends GetxController {
  Rx<List<AuthenticationModel>> users = Rx<List<AuthenticationModel>>([]);
  final isLoading = false.obs;
  final token = ''.obs;
  final userType = ''.obs;
  final box = GetStorage();
  String verifiedUser = '';
  String unverifiedUser = '';
  String userId = '';
  String userName = '';
  String userEmail = '';

  @override
  void onInit() {
    users.value.clear();
    getAllUsers();
    super.onInit();
  }

  Future getAllUsers() async {
    try {
      users.value.clear();
      isLoading.value = true;
      var response = await http.get(Uri.parse('${baseUrl}users'), headers: {
        'Authorization': 'Bearer ${box.read('token').replaceAll('"', '')}',
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json'
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        final content = json.decode(response.body)['data'];
        final verified = json.decode(response.body)['verified_users'];
        final unverified = json.decode(response.body)['unverified_users'];

        verifiedUser = verified.toString();
        unverifiedUser = unverified.toString();

        for (var item in content) {
          users.value.add(AuthenticationModel.fromJson(item));
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
      debugPrint(e.toString());
    }
  }

  Future<void> updateUser({
    required String id,
    required bool verified,
  }) async {
    final token = box.read('token');
    final url = Uri.parse('${baseUrl}user/update/$id');
    final headers = {
      'Authorization': 'Bearer ${box.read('token').replaceAll('"', '')}',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    final body = {
      'verified': verified == true ? 1 : 0,
    };

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        var jsonResponse = utf8.decode(response.bodyBytes);
        debugPrint('The user was updated successfully');
        Get.snackbar(
          'Success',
          json.encode(json.decode(jsonResponse)['message']),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        var jsonResponse = utf8.decode(response.bodyBytes);
        debugPrint(json.encode(json.decode(jsonResponse)['message']));
        Get.snackbar(
          'Error',
          json.encode(json.decode(jsonResponse)['message']),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error occurred during the API request: $e');
    }
    getAllUsers();
  }

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
        Get.offAll(() => NotYetVerifiedView());
        Get.snackbar('Success', 'Your account was created successfully!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white);
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
        Uri.parse('${baseUrl}login'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        isLoading.value = false;

        final responseData = json.decode(response.body);
        debugPrint(responseData['user']['user_type']);
        int isVerified = responseData['user']['verified'];

        final userid = json.decode(response.body)['user']['id'];
        userId = userid.toString();

        final username = json.decode(response.body)['user']['name'];
        userName = username.toString();

        final useremail = json.decode(response.body)['user']['email'];
        userEmail = useremail.toString();

        if (isVerified == 1 && responseData['user']['user_type'] == null) {
          debugPrint(isVerified.toString());
          debugPrint(json.encode(json.decode(response.body)['token']));
          token.value = json.encode(json.decode(response.body)['token']);
          box.write('token', token.value);
          userType.value = 'user';
          box.write('userType', userType.value);
          Get.offAll(() => const UserHomeView());
        } else if (responseData['user']['user_type'] == 'admin') {
          token.value = json.encode(json.decode(response.body)['token']);
          box.write('token', token.value);
          userType.value = 'admin';
          box.write('userType', userType.value);
          Get.offAll(() => const AdminHomeView());
        } else {
          debugPrint(isVerified.toString());

          Get.snackbar('Error', 'Your account is not yet verified',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white);
          Get.offAll(() => NotYetVerifiedView());
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
      debugPrint(e.toString());
    }
  }

  Future<void> logout() async {
    var response = await http.post(Uri.parse('${baseUrl}logout'), headers: {
      'Authorization': 'Bearer ${box.read('token').replaceAll('"', '')}',
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json'
    });

    if (response.statusCode == 200) {
      box.remove('token');
      Get.snackbar('Success', 'Log out successful',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white);
      Get.offAll(() => const LoginView());
    } else {
      Get.snackbar('Success', 'Failed to log out',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    }
  }

  Future sendResetEmail(
      {required String email, required BuildContext context}) async {
    try {
      isLoading.value = true;
      var data = {'email': email};

      var response = await http.post(
        Uri.parse('${baseUrl}forgot'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      debugPrint(response.statusCode.toString());
      if (response.statusCode == 201) {
        isLoading.value = false;
        // Get.offAll(() => ResetPasswordView(
        //       email: email,
        //     ));
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => ResetPasswordView(
                      email: email,
                    )));
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
      debugPrint(e.toString());
    }
  }

  Future resetPassword(
      {required String token,
      required String email,
      required String password,
      required String confirmPassword}) async {
    try {
      isLoading.value = true;
      var data = {'token': token, 'email': email, 'password': password};

      var response = await http.post(
        Uri.parse('${baseUrl}reset'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if (password != confirmPassword) {
        isLoading.value = false;
        Get.snackbar('Error', 'Password do not match!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      } else {
        debugPrint(response.statusCode.toString());
        if (response.statusCode == 201) {
          isLoading.value = false;
          Get.offAll(() => ResetPasswordSuccessView());
        } else {
          isLoading.value = false;
          Get.snackbar(
              'Error', json.encode(json.decode(response.body)['message']),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }
}
