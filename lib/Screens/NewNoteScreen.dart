import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bottom/Models/DataModel.dart';
import 'package:bottom/Providers/DataBaseProvider.dart';
import 'package:bottom/widgets/notifysnackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewNote extends ConsumerStatefulWidget {
  final DataModel? Note;
  final Color? color;
  NewNote({
    this.Note,
    this.color,
    super.key,
  });

  @override
  ConsumerState<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends ConsumerState<NewNote> {
  @override
  Widget build(BuildContext context) {
    final _islight =
        Theme.of(context).brightness == Brightness.light ? true : false;
    final noteController = widget.Note == null
        ? TextEditingController()
        : TextEditingController(text: widget.Note!.note);
    final titleController = widget.Note == null
        ? TextEditingController()
        : TextEditingController(text: widget.Note!.title);
    bool _isSaved = false;
    void _dialoge() {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
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
      if (noteController.text.isEmpty || titleController.text.isEmpty) {
        _dialoge();
      }
      if (noteController.text.isNotEmpty && titleController.text.isNotEmpty) {
        if (widget.Note == null) {
          ref.read(DataBaseProvider.notifier).addNote(
                DataModel(
                    id: uuid.v4(),
                    date: DateTime.now(),
                    title: titleController.text,
                    note: noteController.text),
              );
        }
        if (widget.Note != null) {
          if (widget.Note!.note != noteController.text ||
              widget.Note!.title != titleController.text) {
            ref.read(DataBaseProvider.notifier).update(
                  DataModel(
                      id: widget.Note!.id,
                      date: DateTime.now(),
                      title: titleController.text,
                      note: noteController.text),
                );
          }
        }
        _isSaved = true;
        return;
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
                            titleController.text.isNotEmpty) {
                          save();
                          Navigator.pop(context);
                          return;
                        }
                        Navigator.pop(context);
                      }

                      if (widget.Note != null) {
                        if (noteController.text.isEmpty ||
                            titleController.text.isEmpty) {
                          _dialoge();
                          return;
                        }
                        Navigator.pop(context);
                        save();
                        return;
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: widget.Note == null
                                ? _islight
                                    ? Colors.black
                                    : Colors.white
                                : widget.color,
                            borderRadius: BorderRadius.circular(50)),
                        child: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: _islight ? Colors.white : Colors.black,
                        )),
                  ),
                  Spacer(),
                  Text(
                    widget.Note != null ? "Notes" : "New Note",
                    style: TextStyle(
                        fontSize: 30,
                        color: widget.color == null
                            ? _islight
                                ? Colors.black
                                : Colors.white
                            : widget.color),
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
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _islight ? Colors.black : Colors.white,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Notes Title',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: TextField(
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 18,
                      color: _islight ? Colors.black : Colors.white,
                    ),
                    controller: noteController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Note",
                        hintStyle: TextStyle(color: Colors.grey)),
                    scrollPadding: EdgeInsets.all(20.0),
                    keyboardType: TextInputType.multiline,
                    autofocus: true,
                  ),
                ),
              ],
            ))
          ],
        ),
        floatingActionButton: ElevatedButton.icon(
            style: ButtonStyle(

                // foregroundColor: MaterialStatePropertyAll(),
                backgroundColor: widget.color == null
                    ? _islight
                        ? MaterialStatePropertyAll(Colors.black)
                        : MaterialStatePropertyAll(Colors.white)
                    : MaterialStatePropertyAll(widget.color!),
                foregroundColor: widget.color == null
                    ? _islight
                        ? MaterialStatePropertyAll(Colors.white)
                        : MaterialStatePropertyAll(Colors.black)
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
    //               maxLines: null,
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
