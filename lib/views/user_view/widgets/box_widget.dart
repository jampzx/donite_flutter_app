import 'package:flutter/material.dart';

class MyBox extends StatelessWidget {
  const MyBox({
    Key? key,
    required this.textTitle,
    required this.color,
    required this.assetImage,
  }) : super(key: key);

  final String textTitle;
  final Color color;
  final AssetImage assetImage;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: color,
      child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: assetImage,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                textTitle,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              )
            ],
          )),
    );
  }
}
