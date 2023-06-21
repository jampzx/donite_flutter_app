import 'package:donite/views/constants.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.hintext,
    required this.pickImage,
    required this.prefixicon,
  });

  final String hintext;
  final Icon prefixicon;
  final Function pickImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
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
          pickImage();
        },
      ),
    );
  }
}
