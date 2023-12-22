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
    double deviceWidth = MediaQuery.of(context).size.width;
    if (deviceWidth < 500) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.5,
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
                      size: 12.0,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      textTitle,
                      style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  textDetails,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255)),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width * 0.15,
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
                      size: 12.0,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      textTitle,
                      style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  textDetails,
                  style: const TextStyle(
                      fontSize: 14,
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
}
