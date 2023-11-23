import 'package:bottom/Models/DataModel.dart';
import 'package:bottom/Providers/RemainderProvider.dart';
import 'package:bottom/Remainders/NewNoteScreen.dart';
import 'package:bottom/Screens/NewNoteScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:bottom/Providers/DataBaseProvider.dart';
import 'package:bottom/Screens/NotesScreen.dart';
import 'package:animations/animations.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class showGridView extends ConsumerWidget {
  final List Notes;
  final bool isRemainder;
  showGridView({
    required this.isRemainder,
    required this.Notes,
    super.key,
  });
  void snack(BuildContext context) {}
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  = ref.watch(DataBaseProvider);
    return Notes.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
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
        : StaggeredGridView.countBuilder(
            itemCount: Notes.length,
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            itemBuilder: (context, index) {
              bool isRemainded = isRemainder
                  ? Notes[index].rdate.isBefore(DateTime.now())
                      ? true
                      : false
                  : false;
              return Dismissible(
                background: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                key: Key(Notes[index].id),
                onDismissed: (direction) async {
                  if (!isRemainder) {
                    final delnote = await ref
                        .read(DataBaseProvider.notifier)
                        .delete(Notes[index]);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Row(
                            children: [
                              const Text("Note Deleted"),
                              TextButton(
                                  onPressed: () async {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                    }
                                    ref
                                        .read(DataBaseProvider.notifier)
                                        .addNote(delnote);
                                  },
                                  child: const Text('Undo...'))
                            ],
                          )));
                    }
                  }
                  if (isRemainder) {
                    final DelNote = await ref
                        .read(RemainderProvider.notifier)
                        .delete(Notes[index]);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 2),
                        content: Row(
                          children: [
                            const Text("Note Deleted"),
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
                                },
                                child: const Text('Undo...'))
                          ],
                        )));
                  }
                },
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors
                      .primaries[index % Colors.primaries.length].shade100,
                  child: InkWell(
                    splashColor: Colors
                        .primaries[index % Colors.primaries.length].shade300,
                    borderRadius: BorderRadius.circular(12),
                    onTap: isRemainded
                        ? null
                        : () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: isRemainder
                                        ? NewNoteR(
                                            Note: Notes[index],
                                            color: Colors.primaries[index %
                                                Colors.primaries.length],
                                          )
                                        : NewNote(
                                            Note: Notes[index],
                                            color: Colors.primaries[index %
                                                Colors.primaries.length],
                                          ),
                                    type: PageTransitionType.rightToLeft));
                          },
                    child: Container(
                      // margin: EdgeInsets.all(5),

                      child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isRemainder)
                                Text(
                                  DateFormat('EEEE').format(Notes[index].date),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.primaries[
                                        index % Colors.primaries.length],
                                  ),
                                ),
                              if (isRemainder)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isRemainded
                                              ? "Remainded on"
                                              : "Remainder on",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.primaries[index %
                                                Colors.primaries.length],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_month_outlined,
                                              size: 20,
                                              color: Colors.primaries[index %
                                                  Colors.primaries.length],
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${formatterForDate.format(Notes[index].rdate)}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.primaries[index %
                                                    Colors.primaries.length],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.alarm,
                                              size: 20,
                                              color: Colors.primaries[index %
                                                  Colors.primaries.length],
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${formatterForTime.format(Notes[index].rdate)}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.primaries[index %
                                                    Colors.primaries.length],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 30,
                                    )
                                  ],
                                ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: .5,
                                color: Colors
                                    .primaries[index % Colors.primaries.length],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      Notes[index].title,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(child: Text(Notes[index].note)),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(formatterForTime
                                      .format(Notes[index].date)),
                                  const Spacer(),
                                  Text(formatterForDate
                                      .format(Notes[index].date)),
                                ],
                              )
                            ],
                          )),
                    ),
                  ),
                ),
                //OpenContainer(
                //   closedBuilder: (context, action) => InkWell(
                //     onTap: action,
                //     child: Container(
                //       color: _Gridcolor,
                //       child: Padding(
                //         padding: const EdgeInsets.all(15),
                //         child: Text(Notes[index].note),
                //       ),
                //     ),
                //   ),
                //   openBuilder: (context, action) =>
                //       NewItem(value: 'sdbhsbsbjdfbajkbfjabjsfj'),
                // );

                // openBuilder: (context, action) {
                //   return NewItem(
                //     Note: Notes[index],
                //     color: Colors.primaries[index % Colors.primaries.length],
                //   );
                // },
              );
            },
            staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
          );
  }
}
