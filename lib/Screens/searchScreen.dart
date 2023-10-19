import 'package:bottom/Screens/NotesScreen.dart';
import 'package:bottom/Models/DataModel.dart';
import 'package:bottom/Providers/DataBaseProvider.dart';
import 'package:bottom/Screens/NewNoteScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';

class search extends ConsumerStatefulWidget {
  search({super.key});

  @override
  ConsumerState<search> createState() => _searchState();
}

class _searchState extends ConsumerState<search> {
  List<DataModel> Notes = [];
  List<DataModel> notesList = [];
  int count = 0;
  bool searching = false;

  void update(String value) {
    setState(() {
      searching = true;
      notesList = Notes.where((e) =>
          (e.title.toLowerCase().contains(value.toLowerCase())) ||
          (e.note.toLowerCase().contains(value.toLowerCase()))).toList();
      count = notesList.length;
      searching = false;
    });
  }

  Widget lBuilder() {
    return searching
        ? Center(
            child: LoadingAnimationWidget.dotsTriangle(
                color: Colors.black, size: 50),
          )
        : notesList.isNotEmpty
            ? ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                              child: NewNote(
                                Note: notesList[index],
                                color: Colors
                                    .primaries[index % Colors.primaries.length],
                              ),
                              type: PageTransitionType.rightToLeft,
                            ));
                      },
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                child: NewNote(
                                  Note: notesList[index],
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
                                    Text(
                                      DateFormat('EEEE')
                                          .format(notesList[index].date),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.primaries[
                                            index % Colors.primaries.length],
                                      ),
                                    ),
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
                                              notesList[index].title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
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
                                              notesList[index].note,
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
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
                                          .format(notesList[index].date),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      formatterForTime
                                          .format(notesList[index].date),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              // Container(
                              //   height: 1,
                              //   color: Colors
                              //       .primaries[index % Colors.primaries.length],
                              // )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(child: Text("No Results Found..!"));
  }

  @override
  Widget build(BuildContext context) {
    Notes = ref.watch(DataBaseProvider);

    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                height: MediaQuery.of(context).size.height * .055,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(13)),
                child: TextField(
                  style: TextStyle(fontSize: 17),
                  onChanged: (value) {
                    update(value);
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Your Notes",
                  ),
                ),
              ),
            )
            // Expanded(
            //   child: TextField(
            //     onChanged: (value) {
            //       update(value);
            //     },
            //     decoration: InputDecoration(
            //       border: InputBorder.none,
            //       hintText: "Search Your Notes",
            //     ),
            //   ),
            // )
          ],
        ),
        body: lBuilder());
  }
}
