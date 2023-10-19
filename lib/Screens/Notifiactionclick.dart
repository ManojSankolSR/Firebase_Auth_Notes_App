import 'package:bottom/Models/RemainderModel.dart';
import 'package:bottom/Screens/NotesScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NotifcationClick extends StatelessWidget {
  final RemainderModel remainder;
  NotifcationClick({super.key, required this.remainder});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Remainder",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              offset: Offset(0, 15),
              blurRadius: 22,
              color: Colors.black.withOpacity(.22)),
          BoxShadow(
              offset: Offset(-15, -15), blurRadius: 20, color: Colors.white)
        ], borderRadius: BorderRadius.circular(20), color: Colors.black),
        height: MediaQuery.of(context).size.height * .7,
        width: MediaQuery.of(context).size.height * 1,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Center(
                //   child:
                // ),

                // Text(
                //   "ADDED ON ",
                //   style: TextStyle(
                //       fontSize: 20,
                //       color: Colors.white,
                //       fontWeight: FontWeight.bold),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    print(constraints.maxWidth);
                    return Row(
                      children: [
                        // Spacer(),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                size: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                formatterForDate.format(remainder.date),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.alarm,
                                size: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                formatterForTime.format(remainder.date),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        // Spacer()
                      ],
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Divider(
                    thickness: .5,
                    color: Colors.white,
                  ),
                ),
                Text(remainder.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25)),
                SizedBox(
                  height: 30,
                ),
                Text(remainder.note,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
