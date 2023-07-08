import 'package:donite/controller/donation_controller.dart';
import 'package:donite/views/user_view/user_constants.dart';
import 'package:donite/views/constants.dart';
import 'package:donite/views/user_view/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class DonationFormView extends StatefulWidget {
  const DonationFormView({Key? key, required this.disaster_id})
      : super(key: key);

  final String disaster_id;

  @override
  _DonationFormViewState createState() => _DonationFormViewState();
}

class _DonationFormViewState extends State<DonationFormView> {
  final TextEditingController _donationTypeController = TextEditingController();
  final TextEditingController _donationInformationController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  List<String> dropdownItems = ['Cash donation', 'Goods donation', 'Volunteer'];
  final DonationController _donationController = Get.put(DonationController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: size.width > 600
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            size.width > 600
                ? Container()
                : Center(
                    child: Lottie.asset(
                      'assets/donation-box.json',
                      height: size.height * 0.1,
                      width: size.width * .35,
                      fit: BoxFit.fill,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Form(
                child: Column(
                  children: [
                    dropDownWidget(),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    _donationTypeController.text == ''
                        ? Container()
                        : donationInformationContainer(
                            _donationTypeController.text.toString()),
                    _donationInformationController.text == ''
                        ? Container()
                        : formContainer()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateControllerValue(String newValue) {
    _donationTypeController.text = newValue;
  }

  Widget dropDownWidget() {
    String selectedValue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Donation type',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DropdownButtonFormField<String>(
          style: kTextFormFieldStyle(),
          //value: selectedValue,
          onChanged: (newValue) {
            setState(() {
              selectedValue = newValue!;
              updateControllerValue(newValue);
            });
          },
          items: dropdownItems.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          hint: const Text('Please select donation type'),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.info_rounded),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget donationInformationContainer(String donationType) {
    var size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: donationType == 'Cash donation'
              ? const Text(
                  'Amount',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              : const Text(
                  'Donation information',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
        InputWidget(
            keyboardType: donationType == 'Cash donation'
                ? TextInputType.number
                : TextInputType.text,
            controller: _donationInformationController,
            hintext: donationType == 'Cash donation'
                ? '₱0.00'
                : 'Goods, cloths, man power...',
            isObscure: false,
            prefixicon: donationType == 'Cash donation'
                ? const Icon(
                    Icons.attach_money,
                    color: Colors.grey,
                  )
                : const Icon(
                    Icons.fastfood,
                    color: Colors.grey,
                  )),
        SizedBox(
          height: size.height * 0.01,
        ),
      ],
    );
  }

  Widget formContainer() {
    var size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Donation form',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        /// name
        InputWidget(
            keyboardType: TextInputType.text,
            controller: _nameController,
            hintext: 'name',
            isObscure: false,
            prefixicon: const Icon(
              Icons.person,
              color: Colors.grey,
            )),
        SizedBox(
          height: size.height * 0.01,
        ),

        /// age
        InputWidget(
            keyboardType: TextInputType.number,
            controller: _ageController,
            hintext: 'age',
            isObscure: false,
            prefixicon: const Icon(
              Icons.calendar_month,
              color: Colors.grey,
            )),
        SizedBox(
          height: size.height * 0.01,
        ),

        /// phone
        InputWidget(
            keyboardType: TextInputType.number,
            controller: _contactNumberController,
            hintext: 'contact number',
            isObscure: false,
            prefixicon: const Icon(
              Icons.phone,
              color: Colors.grey,
            )),
        SizedBox(
          height: size.height * 0.01,
        ),

        /// email
        InputWidget(
            keyboardType: TextInputType.text,
            controller: _emailController,
            hintext: 'email',
            isObscure: false,
            prefixicon: const Icon(
              Icons.email,
              color: Colors.grey,
            )),
        SizedBox(
          height: size.height * 0.02,
        ),
        confirmButton(_donationTypeController.text.trim())
      ],
    );
  }

  Widget confirmButton(String donationType) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: Obx(() {
        return _donationController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                onPressed: () async {
                  donationType == 'Cash donation'
                      ? (
                          _donationController.createDonation(
                              disasterId: widget.disaster_id,
                              name: _nameController.text.trim(),
                              age: _ageController.text.trim(),
                              contactNumber:
                                  _contactNumberController.text.trim(),
                              email: _emailController.text.trim(),
                              donationType: _donationTypeController.text.trim(),
                              donationInfo:
                                  _donationInformationController.text.trim(),
                              context: context),
                          _donationController.payment(
                              amount: _donationInformationController.text
                                  .toString(),
                              context: context)
                        )
                      : _donationController.createDonation(
                          disasterId: widget.disaster_id,
                          name: _nameController.text.trim(),
                          age: _ageController.text.trim(),
                          contactNumber: _contactNumberController.text.trim(),
                          email: _emailController.text.trim(),
                          donationType: _donationTypeController.text.trim(),
                          donationInfo:
                              _donationInformationController.text.trim(),
                          context: context);
                },
                child: const Text('COMPLETE'),
              );
      }),
    );
  }
}
