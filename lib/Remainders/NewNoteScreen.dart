import 'dart:math';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bottom/Models/DataModel.dart';
import 'package:bottom/Notification.dart';
import 'package:bottom/Models/RemainderModel.dart';

import 'package:bottom/Providers/RemainderProvider.dart';
import 'package:bottom/Screens/NotesScreen.dart';
import 'package:bottom/widgets/notifysnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class NewNoteR extends ConsumerStatefulWidget {
  final RemainderModel? Note;
  final Color? color;
  NewNoteR({
    this.Note,
    this.color,
    super.key,
  });

  @override
  ConsumerState<NewNoteR> createState() => _NewNoteState();
}

class _NewNoteState extends ConsumerState<NewNoteR> {
  final Notificationservice _notificationservice = Notificationservice();
  DateTime? datetime;
  late TextEditingController noteController;
  late TextEditingController titleController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noteController = widget.Note == null
        ? TextEditingController()
        : TextEditingController(text: widget.Note!.note);
    titleController = widget.Note == null
        ? TextEditingController()
        : TextEditingController(text: widget.Note!.title);
    datetime = widget.Note == null ? null : widget.Note!.rdate;
  }

  Future<DateTime?> pickdate() {
    return showDatePicker(
        context: context,
        initialDate: widget.Note == null ? DateTime.now() : datetime!,
        firstDate: DateTime.now(),
        lastDate: DateTime(2024));
  }

  Future<TimeOfDay?> pickTime() {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    noteController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool _isSaved = false;
    void _dialoge() {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                elevation: 0,
                title: Text("Warning"),
                actions: [
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Please Enter Some Text",
                        style: TextStyle(fontSize: 20),
                      ))
                ],
              ));
    }

    void save() async {
      if (noteController.text.isNotEmpty &&
          titleController.text.isNotEmpty &&
          datetime != null &&
          datetime!.isAfter(DateTime.now())) {
        if (widget.Note == null) {
          if (datetime != null) {
            ref.read(RemainderProvider.notifier).addRemainder(
                  RemainderModel(
                      rid: Random().nextInt(10000000),
                      id: uuid.v4(),
                      title: titleController.text,
                      note: noteController.text,
                      date: DateTime.now(),
                      rdate: datetime!),
                );
          }
        }
        if (widget.Note != null) {
          if (widget.Note!.note != noteController.text ||
              widget.Note!.title != titleController.text ||
              widget.Note!.rdate != datetime) {
            ref.read(RemainderProvider.notifier).update(
                  RemainderModel(
                      rid: widget.Note!.rid,
                      id: widget.Note!.id,
                      title: titleController.text,
                      note: noteController.text,
                      date: DateTime.now(),
                      rdate: datetime!),
                );
          }
        }
        _isSaved = true;
        return;
      } else {
        if (titleController.text.isEmpty || noteController.text.isEmpty) {
          Notify(
              "plesase Enter Some Text", "Error", context, ContentType.failure);
          return;
        }

        if (datetime == null) {
          Notify("Please Select Date", "Error", context, ContentType.failure);
          return;
        }
        if (datetime!.isBefore(DateTime.now())) {
          Notify("Entered time and date should be in Future", "Error", context,
              ContentType.failure);
        }
      }
    }

    @override
    void dispose() {
      super.dispose();
      noteController.dispose();
      titleController.dispose();
    }

    return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (widget.Note == null) {
                        if (noteController.text.isNotEmpty &&
                            titleController.text.isNotEmpty &&
                            datetime != null) {
                          save();
                          Navigator.pop(context);
                          return;
                        }
                        Navigator.pop(context);
                      }

                      if (widget.Note != null) {
                        if (noteController.text.isEmpty ||
                            titleController.text.isEmpty) {
                          save();
                          return;
                        }
                        Navigator.pop(context);
                        save();
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: widget.Note == null
                                ? Colors.black
                                : widget.color,
                            borderRadius: BorderRadius.circular(50)),
                        child: const Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Colors.white,
                        )),
                  ),
                  Spacer(),
                  Text(
                    widget.Note != null ? "Remainders" : "New Remainder",
                    style: TextStyle(fontSize: 30, color: widget.color),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),
            SliverList(
                delegate: SliverChildListDelegate(
              [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: TextField(
                    controller: titleController,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Notes Title',
                      hintStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: TextField(
                    maxLines: null,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    controller: noteController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Note",
                    ),
                    scrollPadding: EdgeInsets.all(20.0),
                    keyboardType: TextInputType.multiline,
                    autofocus: true,
                  ),
                ),
              ],
            )),
            SliverToBoxAdapter(
              child: InkWell(
                onTap: () async {
                  final date = await pickdate();
                  final time = await pickTime();
                  if (date != null && time != null) {
                    setState(() {
                      datetime = DateTime(date.year, date.month, date.day,
                          time.hour, time.minute);
                    });
                  }
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color:
                            widget.color == null ? Colors.black : widget.color,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      datetime == null
                          ? "No date Selecteed"
                          : "${formatterForDate.format(datetime!)} ${formatterForTime.format(datetime!)}",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: ElevatedButton.icon(
            style: ButtonStyle(

                // foregroundColor: MaterialStatePropertyAll(),
                backgroundColor: widget.color == null
                    ? null
                    : MaterialStatePropertyAll(widget.color!),
                foregroundColor: widget.color == null
                    ? null
                    : MaterialStatePropertyAll(Colors.white)),
            icon: const Icon(Icons.save),
            onPressed: () {
              save();
              if (_isSaved) {
                Navigator.pop(context);
              }
            },
            label: const Text('Save')));

    // return Scaffold(
    //     backgroundColor: Colors.white,
    //     appBar: AppBar(
    //       backgroundColor: widget.color,
    //       title: Text(
    //         widget.Note != null ? "Notes" : "Add Item",
    //         style: const TextStyle(fontSize: 20, color: Colors.black),
    //       ),
    //       leading: IconButton(
    //           onPressed: () {
    //             if (widget.Note == null) {
    //               if (noteController.text.isNotEmpty &&
    //                   titleController.text.isNotEmpty) {
    //                 save();
    //                 Navigator.pop(context);
    //                 return;
    //               }
    //               Navigator.pop(context);
    //             }

    //             if (widget.Note != null) {
    //               if (noteController.text.isEmpty ||
    //                   titleController.text.isEmpty) {
    //                 _dialoge();
    //                 return;
    //               }
    //               Navigator.pop(context);
    //               save();
    //               return;
    //             }
    //           },
    //           icon: const Icon(
    //             Icons.arrow_back_ios,
    //             color: Colors.black,
    //           )),
    //     ),
    //     body: SingleChildScrollView(
    //         padding: const EdgeInsets.all(20),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             TextField(
    //               controller: titleController,
    //               style: const TextStyle(
    //                   fontSize: 20, fontWeight: FontWeight.bold),
    //               decoration: const InputDecoration(
    //                 border: InputBorder.none,
    //                 hintText: 'Notes Title',
    //                 hintStyle:
    //                     TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    //               ),
    //             ),
    //             TextField(
    //               : null,
    //               style: const TextStyle(
    //                 fontSize: 18,
    //               ),
    //               controller: noteController,
    //               decoration: const InputDecoration(
    //                 border: InputBorder.none,
    //                 hintText: "Note",
    //               ),
    //               scrollPadding: EdgeInsets.all(20.0),
    //               keyboardType: TextInputType.multiline,
    //               autofocus: true,
    //             ),
    //           ],
    //         )),
    //     floatingActionButton: ElevatedButton.icon(
    //         style: ButtonStyle(

    //             // foregroundColor: MaterialStatePropertyAll(),
    //             backgroundColor: widget.color == null
    //                 ? null
    //                 : MaterialStatePropertyAll(widget.color!.withOpacity(.50)),
    //             foregroundColor: widget.color == null
    //                 ? null
    //                 : MaterialStatePropertyAll(widget.color!.withOpacity(.99))),
    //         icon: const Icon(Icons.save),
    //         onPressed: () {
    //           save();
    //           if (_isSaved) {
    //             Navigator.pop(context);
    //           }
    //         },
    //         label: const Text('Save')));
  }
}
