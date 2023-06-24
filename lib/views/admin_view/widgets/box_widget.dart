import 'package:flutter/material.dart';

class MyBox extends StatelessWidget {
  const MyBox({
    super.key,
    required this.color,
    required this.icon,
    required this.textTitle,
    required this.textDetails,

    //required this.initialValue,
  });
  final Color color;
  final IconData icon;
  final String textTitle;
  final String textDetails;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 26.0,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    textTitle,
                    style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255)),
                  )
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                textDetails,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
