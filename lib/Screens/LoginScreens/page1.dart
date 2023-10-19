import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class page1 extends StatelessWidget {
  page1({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: GradientText("Hi There..!",
                style: TextStyle(fontSize: 40),
                colors: [
                  const Color.fromARGB(255, 239, 104, 80),
                  Color.fromARGB(255, 127, 7, 135),
                ],
                gradientType: GradientType.linear),
            // child: Text(
            //   "Hi There!",
            //   style: TextStyle(
            //       fontSize: 40, color: Color.fromARGB(255, 212, 117, 252)),
            // ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Let's\nGet\nStarted",
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Cloud Based Notes Application Made By Using Flutter And Firesbase",
            style: TextStyle(
                color: Color.fromARGB(255, 107, 107, 107), fontSize: 17),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
