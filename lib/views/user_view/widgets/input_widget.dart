import 'package:donite/views/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputWidget extends StatefulWidget {
  const InputWidget(
      {super.key,
      required this.controller,
      required this.hintext,
      required this.isObscure,
      required this.prefixicon,
      required this.keyboardType});

  final String hintext;
  final TextEditingController controller;
  final bool isObscure;
  final Icon prefixicon;
  final TextInputType keyboardType;

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType,
      style: kTextFormFieldStyle(),
      controller: widget.controller,
      obscureText: widget.isObscure,
      decoration: InputDecoration(
          prefixIcon: widget.prefixicon,
          hintText: widget.hintext,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          prefixIconColor: foregroundColor()),
    );
  }
}
