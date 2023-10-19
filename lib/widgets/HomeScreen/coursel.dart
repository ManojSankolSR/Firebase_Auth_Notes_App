import 'package:bottom/Screens/NotesScreen.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class customcoursel extends StatelessWidget {
  final List notes;
  customcoursel({super.key, required this.notes});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CarouselSlider.builder(
      itemCount: notes.length,
      itemBuilder: (context, index, realIndex) => LayoutBuilder(
        builder: (context, constraints) => Stack(children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: 20),
            height: 200,
            width: 400,
            decoration: BoxDecoration(
                color:
                    Colors.primaries[index % Colors.primaries.length].shade100,
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notes[index].title.length > 20
                      ? "${notes[index].title.characters.take(20)}.."
                      : notes[index].title,
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.primaries[index % Colors.primaries.length],
                      fontWeight: FontWeight.w500),
                ),
                Divider(
                  color: Colors.primaries[index % Colors.primaries.length],
                  thickness: .5,
                ),
                Text(
                  notes[index].note.length > 100
                      ? "${notes[index].note.characters.take(100)}.."
                      : notes[index].note,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.primaries[index % Colors.primaries.length],
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 25,
            child: Container(
              decoration: BoxDecoration(
                  // color: Colors.blue[200],
                  borderRadius: BorderRadius.circular(15)),
              height: constraints.maxHeight * .25,
              width: constraints.maxWidth * .85,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors
                          .primaries[index % Colors.primaries.length].shade100,
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 25,
                          color:
                              Colors.primaries[index % Colors.primaries.length],
                        ),
                        Text(
                          formatterForDate.format(notes[index].date),
                          style: TextStyle(
                              color: Colors
                                  .accents[index % Colors.primaries.length],
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius:
                  //         BorderRadius.circular(15),
                  //     color: Colors
                  //         .primaries[index %
                  //             Colors.primaries.length]
                  //         .shade200,
                  //   ),
                  //   padding: EdgeInsets.all(10),
                  //   child: Row(
                  //     children: [
                  //       Icon(
                  //         Icons.alarm,
                  //         size: 30,
                  //       ),
                  //       Text(
                  //         formatterForTime
                  //             .format(notes[index].date),
                  //         style: TextStyle(
                  //             color: Colors.primaries[
                  //                 index %
                  //                     Colors.primaries
                  //                         .length],
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 17),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Spacer(),
                ],
              ),
            ),
          ),
        ]),
      ),
      options: CarouselOptions(
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 10),
        height: MediaQuery.of(context).size.height * .26,
      ),
    );
  }
}
