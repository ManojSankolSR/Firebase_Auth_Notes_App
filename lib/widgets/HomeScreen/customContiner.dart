import 'package:animations/animations.dart';
import 'package:bottom/Models/DataModel.dart';
import 'package:bottom/Notification.dart';
import 'package:bottom/Screens/HomeScreen.dart';
import 'package:bottom/Screens/NotesScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:bottom/Notification.dart';

class customContainer extends StatelessWidget {
  final destination;
  final int len;
  // final String image;
  final List<Color> color;
  final List<Color> Barcolor;
  final String title;

  customContainer(
      {super.key,
      required this.destination,
      required this.color,
      required this.Barcolor,
      // required this.image,
      required this.len,
      required this.title});

  @override
  Widget build(BuildContext context) {
    final _islight =
        Theme.of(context).brightness == Brightness.light ? true : false;
    // TODO: implement build
    return Material(
      borderRadius: BorderRadius.circular(15),
      color: _islight ? Colors.black : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => destination,
              ));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              //   boxShadow: [
              //   BoxShadow(
              //     color: Colors.black,
              //     spreadRadius: -8,
              //     blurRadius: 15,
              //     offset: Offset(10, 10),
              //   ),
              // ]

              // color: _islight ? Colors.black : Colors.white,
              // gradient: LinearGradient(
              //   colors: Barcolor,
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              //   stops: [.2, .8],
              // ),

              // color: Colors.grey[350],
              ),
          width: MediaQuery.of(context).size.width * .46,
          height: 60,
          child: Row(
            children: [
              Text("${title}",
                  style: TextStyle(
                      color: _islight ? Colors.white : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              Spacer(),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //     colors: Barcolor,
                    //     begin: Alignment.topLeft,
                    //     end: Alignment.bottomRight),
                    color: _islight
                        ? Colors.white.withOpacity(0.2)
                        : Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: _islight ? Colors.white : Colors.black,
                  size: 20,
                ),
              )
            ],
          ),
        ),
      ),
    );

    // InkWell(
    //   splashColor: Colors.grey,
    //   onTap: () {
    //     Navigator.push(
    //         context,
    //         // PageTransition(
    //         //     child: destination, type: PageTransitionType.rightToLeft)
    //         CupertinoPageRoute(
    //           builder: (context) => destination,
    //         ));
    //   },
    //   child: Container(
    //     padding: EdgeInsets.symmetric(horizontal: 15),
    //     decoration: BoxDecoration(
    //         color: _islight ? Colors.black : Colors.white,
    //         // gradient: LinearGradient(
    //         //   colors: Barcolor,
    //         //   begin: Alignment.topLeft,
    //         //   end: Alignment.bottomRight,
    //         //   stops: [.2, .8],
    //         // ),

    //         // color: Colors.grey[350],
    //         borderRadius: BorderRadius.circular(15)),
    //     width: MediaQuery.of(context).size.width * .46,
    //     height: 60,
    //     child: Row(
    //       children: [
    //         Text("${title}",
    //             style: TextStyle(
    //                 color: _islight ? Colors.white : Colors.black,
    //                 fontSize: 20,
    //                 fontWeight: FontWeight.bold)),
    //         Spacer(),
    //         Container(
    //           padding: EdgeInsets.all(5),
    //           decoration: BoxDecoration(
    //               // gradient: LinearGradient(
    //               //     colors: Barcolor,
    //               //     begin: Alignment.topLeft,
    //               //     end: Alignment.bottomRight),
    //               color: _islight
    //                   ? Colors.white.withOpacity(0.2)
    //                   : Colors.black.withOpacity(0.2),
    //               borderRadius: BorderRadius.circular(50)),
    //           child: Icon(
    //             Icons.arrow_forward_ios_rounded,
    //             color: _islight ? Colors.white : Colors.black,
    //             size: 20,
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    //   // child: Column(
    //   //   crossAxisAlignment: CrossAxisAlignment.start,
    //   //   children: [
    //   //     Material(
    //   //       shadowColor: color[0],
    //   //       borderRadius: BorderRadius.circular(15),
    //   //       elevation: 2,
    //   //       child: Container(
    //   //         width: MediaQuery.of(context).size.width * .45,
    //   //         height: MediaQuery.of(context).size.height * .28,
    //   // decoration: BoxDecoration(
    //   //     gradient: LinearGradient(
    //   //         colors: color,
    //   //         begin: Alignment.topLeft,
    //   //         end: Alignment.bottomRight),

    //   //     // color: Colors.grey[350],
    //   //     borderRadius: BorderRadius.circular(15)),
    //   //         child: Row(
    //   //           children: [
    //   //             Container(
    //   //               margin: EdgeInsets.all(12),
    //   //               width: 10,
    //   //               decoration: BoxDecoration(
    //   //                 borderRadius: BorderRadius.circular(20),
    //   //                 gradient: LinearGradient(
    //   //                     colors: Barcolor,
    //   //                     begin: Alignment.topLeft,
    //   //                     end: Alignment.bottomRight),
    //   //               ),
    //   //             )
    //   //           ],
    //   //         ),
    //   //         // child: ClipRRect(
    //   //         //   borderRadius: BorderRadius.circular(15),
    //   //         //   child: Image.asset(
    //   //         //     image,
    //   //         //     fit: BoxFit.cover,
    //   //         //   ),
    //   //         // ),
    //   //       ),
    //   //     ),
    //   //     Container(
    //   //       margin: EdgeInsets.only(left: 10, top: 10),
    //   //       child: Row(
    //   //         mainAxisAlignment: MainAxisAlignment.start,
    //   //         children: [
    //   //           Text(
    //   //             title,
    //   //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    //   //           ),
    //   //           GradientText(
    //   //             "(${len})",
    //   //             gradientDirection: GradientDirection.ttb,
    //   //             colors: Barcolor,
    //   //             // colors: [
    //   //             //   const Color.fromARGB(255, 239, 104, 80),
    //   //             //   Color.fromARGB(255, 127, 7, 135),
    //   //             // ],
    //   //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    //   //           )
    //   //         ],
    //   //       ),
    //   //     )
    //   //   ],
    //   // ),
    // );
  }
}
