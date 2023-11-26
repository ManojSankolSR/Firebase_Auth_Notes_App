import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bottom/Models/DataModel.dart';
import 'package:bottom/Models/RemainderModel.dart';
import 'package:bottom/Providers/BinProvider.dart';
import 'package:bottom/Providers/RemainderProvider.dart';
import 'package:bottom/Remainders/NewNoteScreen.dart';
import 'package:bottom/Screens/NewNoteScreen.dart';
import 'package:bottom/Screens/BinScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bottom/Screens/NotesScreen.dart';
import 'package:animations/animations.dart';
import 'package:bottom/Providers/NotesProvider.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class showListView extends ConsumerStatefulWidget {
  final List notes;
  final bool isReminder;
  showListView({
    required this.isReminder,
    required this.notes,
    super.key,
  });

  @override
  ConsumerState<showListView> createState() => _showListViewState();
}

class _showListViewState extends ConsumerState<showListView>
    with TickerProviderStateMixin {
  late AnimationController _rotateanimationController;
  late AnimationController _scaleanimationController;
  late Animation<double> rotateandfadeanimation;
  late Animation<double> scaleanimation;
  @override
  void initState() {
    // TODO: implement initState
    _scaleanimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _rotateanimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    scaleanimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _scaleanimationController, curve: Curves.linear));
    rotateandfadeanimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _rotateanimationController, curve: Curves.linear));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _rotateanimationController.dispose();
    _scaleanimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return widget.notes.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LottieBuilder.asset('lib/Assets/images/animation_lltd0cpg.json',
                  height: 500, frameRate: FrameRate.max),
              GradientText(
                gradientDirection: GradientDirection.ltr,
                gradientType: GradientType.linear,
                "Hi There Try adding Some Notes",
                colors: [
                  const Color.fromARGB(255, 239, 104, 80),
                  Color.fromARGB(255, 127, 7, 135),
                ],
                style: TextStyle(fontSize: 15),
              ),
            ],
          )
        : ListView.builder(
            itemCount: widget.notes.length,
            itemBuilder: (context, index) {
              bool isRemainded = widget.isReminder
                  ? widget.notes[index].rdate.isBefore(DateTime.now())
                      ? true
                      : false
                  : false;

              return Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 7, left: 5, right: 5),
                  child: Dismissible(
                    direction: isRemainded
                        ? DismissDirection.startToEnd
                        : DismissDirection.horizontal,
                    secondaryBackground: Container(
                      // padding: EdgeInsets.only(right: 30),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      alignment: Alignment.centerRight,
                      child: FadeScaleTransition(
                        animation: rotateandfadeanimation,
                        child: RotationTransition(
                            turns: rotateandfadeanimation,
                            child: Icon(Icons.first_page_sharp)),
                      ),
                    ),
                    background: Container(
                      // padding: EdgeInsets.only(left: 30),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      alignment: Alignment.centerLeft,
                      child: FadeTransition(
                        opacity: rotateandfadeanimation,
                        child: ScaleTransition(
                            scale: scaleanimation,
                            child: Icon(Icons.delete_outline)),
                      ),
                    ),
                    key: Key(widget.notes[index].id),
                    onUpdate: (details) {
                      if (details.progress <= .5 &&
                          details.direction == DismissDirection.endToStart) {
                        _rotateanimationController.value = details.progress;
                      }
                      if (details.progress <= .5 &&
                          details.direction == DismissDirection.startToEnd) {
                        _scaleanimationController.value = details.progress * 4;
                        _rotateanimationController.value =
                            details.progress * 1.5;
                      }
                    },
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => widget.isReminder
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
                            ));
                        return false;
                      } else {
                        return true;
                      }
                    },
                    onDismissed: (direction) async {
                      if (!widget.isReminder) {
                        final DelNote = await ref
                            .read(NotesProvider.notifier)
                            .delete(widget.notes[index]);
                        await ref
                            .read(BinNoteProvider.notifier)
                            .addNote(DelNote);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 2),
                            content: Row(
                              children: [
                                const Text("Note added to Bin"),
                                const Spacer(),
                                TextButton(
                                    onPressed: () async {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .clearSnackBars();
                                      }
                                      ref
                                          .read(NotesProvider.notifier)
                                          .addNote(DelNote);
                                      ref
                                          .read(BinNoteProvider.notifier)
                                          .delNote(DelNote);
                                    },
                                    child: const Text('Undo...'))
                              ],
                            )));
                      }
                      if (widget.isReminder) {
                        final DelNote = await ref
                            .read(RemainderProvider.notifier)
                            .delete(widget.notes[index]);
                        ref
                            .read(BinRemainderProvider.notifier)
                            .addRemainder(DelNote);

                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 2),
                            content: Row(
                              children: [
                                const Text("Reaminder added to Bin"),
                                const Spacer(),
                                TextButton(
                                    onPressed: () async {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .clearSnackBars();
                                      }
                                      ref
                                          .read(RemainderProvider.notifier)
                                          .addRemainder(DelNote);
                                      ref
                                          .read(BinRemainderProvider.notifier)
                                          .delRemainder(DelNote);
                                    },
                                    child: const Text('Undo...'))
                              ],
                            )));
                      }
                    },
                    child: Material(
                      borderRadius: BorderRadius.circular(13),
                      color: Colors
                          .primaries[index % Colors.primaries.length].shade100,
                      child: InkWell(
                        splashColor: Colors
                            .primaries[index % Colors.primaries.length]
                            .shade300,
                        borderRadius: BorderRadius.circular(13),
                        onTap: isRemainded
                            ? null
                            : () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => widget.isReminder
                                          ? NewNoteR(
                                              Note: widget.notes[index],
                                              color: Colors.primaries[index %
                                                  Colors.primaries.length],
                                            )
                                          : NewNote(
                                              Note: widget.notes[index],
                                              color: Colors.primaries[index %
                                                  Colors.primaries.length],
                                            ),
                                    ));
                              },
                        child: Container(
                          decoration: BoxDecoration(
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
                                        if (isRemainded)
                                          Icon(
                                            Icons.check_circle_sharp,
                                            color: Colors.green,
                                            size: 20,
                                          ),
                                        Spacer(),
                                        Text(
                                          isRemainded
                                              ? "Remainded on"
                                              : "Remainder on",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Colors.primaries[index %
                                                Colors.primaries.length],
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
                                            color: Colors.primaries[index %
                                                Colors.primaries.length],
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
                                            color: Colors.primaries[index %
                                                Colors.primaries.length],
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
                    ),
                  ));
            },
          );
  }
}
