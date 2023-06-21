import 'package:donite/views/constants.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  const InputWidget({
    super.key,
    required this.controller,
    required this.hintext,
    required this.isObscure,
    required this.prefixicon,
  });

  final String hintext;
  final TextEditingController controller;
  final bool isObscure;
  final Icon prefixicon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: kTextFormFieldStyle(),
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        prefixIcon: prefixicon,
        hintText: hintext,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
