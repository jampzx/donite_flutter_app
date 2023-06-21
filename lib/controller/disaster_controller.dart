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
    getAllDisasters();
    super.onInit();
  }

  Future getAllDisasters() async {
    try {
      disasters.value.clear();
      isLoading.value = true;
      var response = await http.get(Uri.parse('${baseUrl}disaster'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
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
        debugPrint(json.encode(json.decode(response.body)));
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
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
    final url = Uri.parse('http://192.168.1.4:80/api/disaster/update/$id');
    final headers = {
      'Authorization': 'Bearer $token',
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

      if (response.statusCode == 201) {
        print('The post was updated successfully');
      } else {
        print('Failed to update the post. Error code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred during the API request: $e');
    }
  }

  void updateWidget() {
    update(['title']);
  }
  // Future updateDisaster(
  //     String id,
  //     String title,
  //     String date,
  //     String disasterType,
  //     String location,
  //     String information,
  //     File image) async {
  //   var uri = Uri.parse(baseUrl + 'disaster/update/' + id.toString());
  //   debugPrint(id);
  //   debugPrint(title);
  //   debugPrint(date);
  //   debugPrint(disasterType);
  //   debugPrint(location);
  //   debugPrint(information);

  //   // Create multipart request
  //   var request = http.MultipartRequest('POST', uri);

  //   // Attach text data
  //   request.fields['title'] = title;
  //   request.fields['date'] = date;
  //   request.fields['disasterType'] = disasterType;
  //   request.fields['location'] = location;
  //   request.fields['information'] = information;

  //   // Attach image file if provided
  //   if (image != null) {
  //     var stream = http.ByteStream(image.openRead());
  //     var length = await image.length();

  //     var multipartFile = http.MultipartFile('image', stream, length,
  //         filename: image.path.split('/').last);
  //     request.files.add(multipartFile);
  //   }

  //   // Send the request
  //   var response = await request.send();

  //   // Check the response status code
  //   if (response.statusCode == 201) {
  //     print('The post was updated successfully');
  //   } else {
  //     print('Failed to update the post. Status code: ${response.statusCode}');
  //   }
  // }

  // Future<void> updateDisaster({
  //   required int id,
  //   required String title,
  //   required String date,
  //   required String disasterType,
  //   required String location,
  //   required String information,
  //   required String imagePath,
  // }) async {
  //   try {
  //     isLoading.value = true;

  //     var url = Uri.parse(baseUrl + 'disaster/update/' + id.toString());
  //     var request = http.MultipartRequest('POST', url);
  //     debugPrint(id.toString());
  //     debugPrint(title);
  //     debugPrint(date);
  //     debugPrint(disasterType);
  //     debugPrint(location);
  //     debugPrint(information);
  //     debugPrint(request.fields['title']);
  //     request.fields['title'] = title;
  //     request.fields['date'] = date;
  //     request.fields['disasterType'] = disasterType;
  //     request.fields['location'] = location;
  //     request.fields['information'] = information;
  //     request.files.add(await http.MultipartFile.fromPath('image', imagePath));

  //     var response = await request.send();
  //     debugPrint(url.toString());
  //     debugPrint(response.statusCode.toString());

  //     if (response.statusCode == 201) {
  //       isLoading.value = false;
  //       var jsonResponse = await response.stream.bytesToString();

  //       json.encode(json.decode(jsonResponse)['message']);
  //       debugPrint('Disaster updated successfully!');
  //     } else {
  //       isLoading.value = false;
  //       var jsonResponse = await response.stream.bytesToString();
  //       var errorMessage = json.encode(json.decode(jsonResponse)['message']);
  //       Get.snackbar(
  //         'Error',
  //         errorMessage,
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //       );
  //     }
  //   } catch (e) {
  //     isLoading.value = false;
  //     print(e.toString());
  //   }
  // }
}
