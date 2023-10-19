import 'package:bottom/Models/DataModel.dart';
import 'package:bottom/Providers/DataBaseProvider.dart';
import 'package:bottom/Remainders/NewNoteScreen.dart';
import 'package:bottom/Screens/HomeScreen.dart';
import 'package:bottom/Screens/NewNoteScreen.dart';
import 'package:bottom/Screens/NotesScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class homelist extends ConsumerStatefulWidget {
  final List notes;
  final bool isReminder;

  homelist({
    super.key,
    required this.notes,
    required this.isReminder,
  });

  @override
  ConsumerState<homelist> createState() => _homelistState();
}

class _homelistState extends ConsumerState<homelist> {
  List sornotes = [];

  void listfetcher(DateTime date) {
    List sortNotes = widget.notes
        .where((element) => (element.date.year == date.year &&
            element.date.month == date.month &&
            element.date.day == date.day))
        .toList();
    setState(() {
      sornotes = sortNotes;
    });

    // print(widget.notes[0].date);
    // print(sortNotes);
    // print(date);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return widget.notes.isEmpty
        ? Center(
            child: GradientText(
              widget.isReminder ? "No Remainders Found" : "No Notes Found",
              colors: [
                const Color.fromARGB(255, 239, 104, 80),
                Color.fromARGB(255, 127, 7, 135),
              ],
              style: TextStyle(fontSize: 15),
            ),
          )
        : CustomScrollView(
            slivers: [
              SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                childCount: widget.notes.length < 5 ? widget.notes.length : 5,
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 7, left: 10, right: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                              child: widget.isReminder
                                  ? NewNoteR(
                                      Note: widget.notes[index],
                                      color: Colors.primaries[
                                          index % Colors.primaries.length],
                                    )
                                  : NewNote(
                                      Note: widget.notes[index],
                                      color: Colors.primaries[
                                          index % Colors.primaries.length],
                                    ),
                              type: PageTransitionType.rightToLeft,
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors
                              .primaries[index % Colors.primaries.length]
                              .shade100,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 10,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!widget.isReminder)
                                    Text(
                                      DateFormat('EEEE')
                                          .format(widget.notes[index].date),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.primaries[
                                            index % Colors.primaries.length],
                                      ),
                                    ),
                                  if (widget.isReminder)
                                    Row(children: [
                                      Spacer(),
                                      Text(
                                        "Remainder on",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.primaries[
                                              index % Colors.primaries.length],
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.calendar_month_outlined,
                                        size: 20,
                                        color: Colors.primaries[
                                            index % Colors.primaries.length],
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${formatterForDate.format(widget.notes[index].rdate)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.primaries[
                                              index % Colors.primaries.length],
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.alarm,
                                        size: 20,
                                        color: Colors.primaries[
                                            index % Colors.primaries.length],
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${formatterForTime.format(widget.notes[index].rdate)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.primaries[
                                              index % Colors.primaries.length],
                                        ),
                                      ),
                                      Spacer(),
                                    ]),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: .5,
                                    color: Colors.primaries[
                                        index % Colors.primaries.length],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, bottom: 5),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            widget.notes[index].title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            widget.notes[index].note,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 7),
                              child: Row(
                                children: [
                                  Text(
                                    formatterForDate
                                        .format(widget.notes[index].date),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                  const Spacer(),
                                  Text(
                                    formatterForTime
                                        .format(widget.notes[index].date),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ))
            ],
          );
  }
}
