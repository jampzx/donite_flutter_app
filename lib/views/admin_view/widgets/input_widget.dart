import 'package:donite/views/constants.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  const InputWidget({
    super.key,
    required this.controller,
    required this.hintext,
    required this.prefixicon,
    //required this.initialValue,
  });

  final TextEditingController controller;
  final String hintext;
  final Icon prefixicon;
  //final String initialValue;

  @override
  Widget build(BuildContext context) {
    //controller.text = initialValue;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: kTextFormFieldStyle(),
        controller: controller,
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
      ),
    );
  }
}
