import 'dart:convert';
import 'dart:io';
import 'package:donite/constants/constants.dart';
import 'package:donite/model/disaster_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class DisasterController extends GetxController {
  Rx<List<DisasterModel>> disasters = Rx<List<DisasterModel>>([]);
  final isLoading = false.obs;
  final box = GetStorage();

  @override
  void onInit() {
    disasters.value.clear();
    getAllDisasters();
    super.onInit();
  }

  Future getAllDisasters() async {
    try {
      disasters.value.clear();
      isLoading.value = true;
      var response = await http.get(Uri.parse('${baseUrl}disaster'), headers: {
        //'Authorization': 'Bearer ${box.read('token').replaceAll('"', '')}',
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json'
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        final content = json.decode(response.body)['data'];
        // debugPrint(json.encode(json.decode(response.body)));
        for (var item in content) {
          disasters.value.add(DisasterModel.fromJson(item));
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

  Future<void> createDisaster({
    required String title,
    required String date,
    required String disasterType,
    required String location,
    required String information,
    required String imagePath,
  }) async {
    debugPrint(title);
    debugPrint(box.read('token'));
    debugPrint(imagePath);
    final url = Uri.parse('${baseUrl}disaster/store');
    final headers = {
      'Authorization': 'Bearer ${box.read('token').replaceAll('"', '')}',
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json'
    };

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);
      request.fields['title'] = title;
      request.fields['date'] = date;
      request.fields['disasterType'] = disasterType;
      request.fields['location'] = location;
      request.fields['information'] = information;
      request.fields['image'] = imagePath;
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      final response = await request.send();
      var jsonResponse = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        debugPrint('The post was created successfully');
        Get.snackbar(
            'Success', json.encode(json.decode(jsonResponse)['message']),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        getAllDisasters();
      } else {
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
  }

  Future<void> updateDisaster({
    required String id,
    required String title,
    required String date,
    required String disasterType,
    required String location,
    required String information,
    required String imagePath,
  }) async {
    final token = box.read('token');
    debugPrint(title);
    debugPrint(token.toString());
    debugPrint(imagePath);
    final url = Uri.parse('${baseUrl}disaster/update/$id');
    final headers = {
      'Authorization': 'Bearer ${box.read('token').replaceAll('"', '')}',
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json'
    };

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);
      request.fields['title'] = title;
      request.fields['date'] = date;
      request.fields['disasterType'] = disasterType;
      request.fields['location'] = location;
      request.fields['information'] = information;
      if (imagePath != '') {
        request.fields['image'] = imagePath;
        request.files
            .add(await http.MultipartFile.fromPath('image', imagePath));
      }

      final response = await request.send();
      var jsonResponse = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        debugPrint('The post was updated successfully');
        Get.snackbar(
            'Success', json.encode(json.decode(jsonResponse)['message']),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
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
  }

  Future<void> deleteDisaster({required String id}) async {
    try {
      isLoading.value = true;
      var response = await http.delete(
        Uri.parse('${baseUrl}disaster/delete/$id'),
        headers: {
          'Authorization': 'Bearer ${box.read('token').replaceAll('"', '')}',
          'Content-Type': 'application/json',
        },
      );
      isLoading.value = false;
      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'The post was deleted successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        getAllDisasters();
      } else if (response.statusCode == 404) {
        Get.snackbar(
          'Error',
          'Disaster not found',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete the post',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }
}
