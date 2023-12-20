import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:donite/constants/constants.dart';
import 'package:donite/model/donation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class DonationController extends GetxController {
  Map<String, dynamic>? paymentIntent;
  Rx<List<DonationModel>> donations = Rx<List<DonationModel>>([]);
  final isLoading = false.obs;
  final box = GetStorage();
  String donationCount = '';
  List<dynamic> donationsPerUser = [].obs;

  @override
  void onInit() {
    donations.value.clear();
    //getAllDonations();
    super.onInit();
  }

  Future getAllDonations() async {
    try {
      donations.value.clear();
      isLoading.value = true;
      var response = await http.get(Uri.parse('${baseUrl}donation'), headers: {
        'Authorization':
            'Bearer ${box.read('token')?.toString().replaceAll('"', '')}',
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json'
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        final content = json.decode(response.body)['data'];
        final donations_count = json.decode(response.body)['total_donations'];
        donationCount = donations_count.toString();
        for (var item in content) {
          donations.value.add(DonationModel.fromJson(item));
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

  Future<void> fetchDonationsPerUser(String userId) async {
    isLoading.value = true;

    var response = await http.get(
      Uri.parse('${baseUrl}donation/user/$userId'),
      headers: {
        'Authorization':
            'Bearer ${box.read('token')?.toString().replaceAll('"', '')}',
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      isLoading.value = false;

      var data = json.decode(response.body);
      donationsPerUser = data['donation_of_user'];
    } else {
      isLoading.value = false;
      throw Exception('Failed to fetch donations per user');
    }
  }

  Future<void> createDonation({
    required String disasterId,
    required String name,
    required String age,
    required String contactNumber,
    required String email,
    required String donationType,
    required String donationInfo,
    required String goods_type,
    required BuildContext context,
  }) async {
    final url = Uri.parse('${baseUrl}donation/store');
    final headers = {
      'Authorization':
          'Bearer ${box.read('token')?.toString().replaceAll('"', '')}',
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json'
    };

    try {
      isLoading.value = true;
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);
      request.fields['disaster_id'] = disasterId;
      request.fields['name'] = name;
      request.fields['age'] = age;
      request.fields['contact_number'] = contactNumber;
      request.fields['email'] = email;
      request.fields['donation_type'] = donationType;
      request.fields['donation_info'] = donationInfo;
      request.fields['goods_type'] = goods_type;

      final response = await request.send();
      var jsonResponse = await response.stream.bytesToString();
      isLoading.value = false;
      if (response.statusCode == 201) {
        debugPrint('The donation successful');
        if (donationType != 'Cash donation') {
          // ignore: use_build_context_synchronously
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            text: "Your support is greatly appreciated!",
            // ignore: use_build_context_synchronously
            width: MediaQuery.of(context).size.width * .18,
            onConfirmBtnTap: () {
              Navigator.pop(context);
            },
          );
        }
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
      isLoading.value = false;
      debugPrint('Error occurred during the API request: $e');
    }
  }

  Future<void> payment(
      {required String amount, required BuildContext context}) async {
    //step 1 payment intent
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount).toString(),
        'currency': 'PHP',
      };

      final isconnected = await checkInternetConnectivity();
      debugPrint(isconnected.toString());
      if (isconnected) {
        var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          headers: {
            'Authorization':
                'Bearer sk_test_51NTT8ZHNNwXyy25HOUcd6OBlcvN9c3X5p7EAJUkznWsyYmovGZb1AsLWT9ych8D0RqaqKQLyXb4HjWvqz1JFoX5w00dgetEZyi',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: body,
        );
        paymentIntent = json.decode(response.body);
      }
    } catch (err) {
      throw Exception(err);
    }

    //step 2 payment sheet
    await Stripe.instance
        .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntent!['client_secret'],
                style: ThemeMode.light,
                merchantDisplayName: 'DONITE'))
        .then((value) => {});

    //step 3 display payment sheet
    try {
      await Stripe.instance.presentPaymentSheet().then((value) => {
            //success
            debugPrint('payment success')
          });
      // ignore: use_build_context_synchronously
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "Your donation was successful!",
        // ignore: use_build_context_synchronously
        width: MediaQuery.of(context).size.width * .18,
        onConfirmBtnTap: () {
          Navigator.pop(context);
        },
      );
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> updateDonation({
    required String id,
    required bool verified,
  }) async {
    final token = box.read('token');
    final url = Uri.parse('${baseUrl}donation/update/$id');
    final headers = {
      'Authorization':
          'Bearer ${box.read('token')?.toString().replaceAll('"', '')}',
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
        debugPrint('The donation was updated successfully');
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
    getAllDonations();
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  //test
  Future<void> processGCashPayment(BuildContext context) async {
    // Construct the API endpoint URL
    final apiUrl = Uri.parse('https://api.paymongo.com/v1/payment_intents');

    // Prepare the request body with GCash payment details
    final requestBody = jsonEncode({
      'data': {
        'attributes': {
          'payment_method_allowed': ['gcash'],
          'payment_method_options': {
            'gcash': {
              'redirect': {
                'success': 'yourapp://payment/success',
                'failed': 'yourapp://payment/failed',
              },
            },
          },
          'amount': 1000, // Amount in cents
          'currency': 'PHP',
          'description': 'Example GCash Payment',
          'statement_descriptor': 'Your Descriptor',
        },
      },
    });

    // Encode the API key using Base64
    final apiKey = 'sk_test_rmP3tM2QUytiMyBLwrb2aTdL';
    final encodedApiKey = base64.encode(utf8.encode('$apiKey:'));
    debugPrint(apiKey);

    // Send the POST request to create a payment intent
    final response = await http.post(
      apiUrl,
      headers: {
        'Authorization': 'Basic $encodedApiKey',
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Process the payment response
      // ...
    } else {
      print(
          'Payment intent creation failed. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
//end test
}
