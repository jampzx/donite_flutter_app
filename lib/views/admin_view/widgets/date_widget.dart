import 'package:donite/views/constants.dart';
import 'package:flutter/material.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({
    super.key,
    required this.controller,
    required this.hintext,
    required this.showDatePicker,
    required this.prefixicon,
    //required this.initialValue,
  });

  final String hintext;
  final TextEditingController controller;
  final Icon prefixicon;
  final Function showDatePicker;
  //final String initialValue;

  @override
  Widget build(BuildContext context) {
    //controller.text = initialValue;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        style: kTextFormFieldStyle(),
        decoration: InputDecoration(
            prefixIcon: prefixicon,
            hintText: hintext,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            enabledBorder:
                const OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            filled: true,
            fillColor: Colors.grey[300]),
        readOnly: true,
        onTap: () {
          showDatePicker();
        },
      ),
    );
  }
}
