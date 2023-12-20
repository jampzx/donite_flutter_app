import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:donite/constants/constants.dart';
import 'package:donite/model/disaster_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DisasterController extends GetxController {
  Rx<List<DisasterModel>> disasters = Rx<List<DisasterModel>>([]);
  Rx<List<DisasterModel>> disastersActive = Rx<List<DisasterModel>>([]);
  Rx<List<DisasterModel>> disastersInactive = Rx<List<DisasterModel>>([]);
  final isLoading = false.obs;
  final box = GetStorage();
  String disasterCount = '';

  @override
  void onInit() {
    disasters.value.clear();
    disastersActive.value.clear();
    disastersInactive.value.clear();
    // getAllDisasters();
    // getActiveDisasters();
    // getInactiveDisasters();
    super.onInit();
  }

  Future getAllDisasters() async {
    try {
      disasters.value.clear();
      isLoading.value = true;
      var response = await http.get(Uri.parse('${baseUrl}disaster'), headers: {
        'Authorization':
            'Bearer ${box.read('token')?.toString().replaceAll('"', '')}',
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json'
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        final content = json.decode(response.body)['data'];
        final disaster_count = json.decode(response.body)['total_disasters'];
        disasterCount = disaster_count.toString();
        debugPrint(json.encode(json.decode(response.body)));
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
      debugPrint(e.toString());
    }
  }

  Future createDisaster({
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
      'Authorization':
          'Bearer ${box.read('token')?.toString().replaceAll('"', '')}',
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

  Future updateDisaster({
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
      'Authorization':
          'Bearer ${box.read('token')?.toString().replaceAll('"', '')}',
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
          'Authorization':
              'Bearer ${box.read('token')?.toString().replaceAll('"', '')}',
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

  Future getActiveDisasters() async {
    try {
      disastersActive.value.clear();
      isLoading.value = true;
      var response =
          await http.get(Uri.parse('${baseUrl}disaster/active'), headers: {
        'Authorization':
            'Bearer ${box.read('token')?.toString().replaceAll('"', '')}',
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json'
      });
      debugPrint(
          'Active Disasters Response: ${json.encode(json.decode(response.body))}');
      if (response.statusCode == 200) {
        isLoading.value = false;
        final content = json.decode(response.body)['data'];
        debugPrint(
            'Active Disasters Response: ${json.encode(json.decode(response.body))}');
        for (var item in content) {
          disastersActive.value.add(DisasterModel.fromJson(item));
        }
        debugPrint('Active Disasters Count: ${disastersActive.value.length}');
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
      debugPrint('Error fetching active disasters: $e');
    }
  }

  Future getInactiveDisasters() async {
    try {
      disastersInactive.value.clear();
      isLoading.value = true;
      var response =
          await http.get(Uri.parse('${baseUrl}disaster/inactive'), headers: {
        'Authorization':
            'Bearer ${box.read('token')?.toString().replaceAll('"', '')}',
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json'
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        final content = json.decode(response.body)['data'];
        debugPrint(json.encode(json.decode(response.body)));
        for (var item in content) {
          disastersInactive.value.add(DisasterModel.fromJson(item));
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

  Future<void> updateActiveDisaster({
    required String id,
    required bool active,
  }) async {
    final token = box.read('token');
    final url = Uri.parse('${baseUrl}disaster/updateActive/$id');
    final headers = {
      'Authorization':
          'Bearer ${box.read('token')?.toString().replaceAll('"', '')}',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    final body = {
      'active': active == true ? 1 : 0,
    };

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        var jsonResponse = utf8.decode(response.bodyBytes);
        debugPrint('The post was updated successfully');
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
    getAllDisasters();
  }

// OFFLINE MODE

// Function to check internet connectivity
  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

// Function to save localy
  Future saveLocally({
    required String title,
    required String date,
    required String disasterType,
    required String location,
    required String information,
    required String imagePath,
  }) async {
    final isConnected = await checkInternetConnectivity();
    if (!isConnected) {
      sqfliteFfiInit();
      final databaseFactory = databaseFactoryFfi;

      final databasePath = await databaseFactory.getDatabasesPath();
      final database =
          await databaseFactory.openDatabase('$databasePath/my_database.db');
      debugPrint(databasePath);

      // Create the "disasters" table if it doesn't exist
      await database.execute('''
    CREATE TABLE IF NOT EXISTS disasters (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      date TEXT,
      disasterType TEXT,
      location TEXT,
      information TEXT,
      image TEXT
    )
  ''');

      final disasterMap = {
        'title': title,
        'date': date,
        'disasterType': disasterType,
        'location': location,
        'information': information,
        'image': imagePath,
      };

      await database.insert('disasters', disasterMap);
      await database.close();
      Get.snackbar(
        'Success',
        'The post was stored locally',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      createDisaster(
          title: title,
          date: date,
          disasterType: disasterType,
          location: location,
          information: information,
          imagePath: imagePath);
      getAllDisasters();
      Get.snackbar(
        'Warning',
        'You have internet connection available, the post was posted online',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color.fromARGB(255, 228, 205, 0),
        colorText: Colors.white,
      );
    }
  }

// Function to upload locally saved data to the server
  Future<void> uploadDataToServer() async {
    final isConnected = await checkInternetConnectivity();

    if (isConnected) {
      sqfliteFfiInit();
      final databaseFactory = databaseFactoryFfi;

      final databasePath = await databaseFactory.getDatabasesPath();
      final database =
          await databaseFactory.openDatabase('$databasePath/my_database.db');

      final List<Map<String, dynamic>> results =
          await database.query('disasters');

      for (final result in results) {
        final url = Uri.parse('${baseUrl}disaster/store');
        final headers = {
          'Authorization':
              'Bearer ${box.read('token')?.toString().replaceAll('"', '')}',
          'Content-Type': 'multipart/form-data',
          'Accept': 'application/json'
        };

        try {
          var request = http.MultipartRequest('POST', url);
          request.headers.addAll(headers);
          request.fields['title'] = result['title'];
          request.fields['date'] = result['date'];
          request.fields['disasterType'] = result['disasterType'];
          request.fields['location'] = result['location'];
          request.fields['information'] = result['information'];
          request.fields['image'] = result['image'];
          request.files
              .add(await http.MultipartFile.fromPath('image', result['image']));

          final response = await request.send();
          var jsonResponse = await response.stream.bytesToString();

          if (response.statusCode == 201) {
            Get.snackbar(
              'Success',
              'The local files sync successfully',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            getAllDisasters();
            // Optionally, you can remove the uploaded data from the local database
            await database.delete('disasters',
                where: 'id = ?', whereArgs: [result['id']]);
          } else {
            Get.snackbar(
              'Error',
              'An error occured syncing the files',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } catch (e) {
          debugPrint('Error occurred during the API request: $e');
        }
      }

      await database.close();
    } else {
      Get.snackbar(
        'Error',
        'No internet connection available. Please retry later.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
