import 'package:animations/animations.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bottom/Models/DataModel.dart';
import 'package:bottom/Models/RemainderModel.dart';
import 'package:bottom/Providers/NotesProvider.dart';
import 'package:bottom/Providers/EmailPassProvider.dart';
import 'package:bottom/Providers/RemainderProvider.dart';
import 'package:bottom/Remainders/NewNoteScreen.dart';
import 'package:bottom/Screens/NewNoteScreen.dart';
import 'package:bottom/Screens/searchScreen.dart';
import 'package:bottom/widgets/showGridView.dart';
import 'package:bottom/widgets/showListView.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

final formatterForDate = DateFormat.yMd();
final formatterForTime = DateFormat('h:mm a');

class NoteScreen extends ConsumerStatefulWidget {
  final bool isRemainder;
  NoteScreen({
    required this.isRemainder,
    super.key,
  });

  @override
  ConsumerState<NoteScreen> createState() => _NoteScreen();
}

class _NoteScreen extends ConsumerState<NoteScreen>
    with TickerProviderStateMixin {
  ScrollController? _scrollController;
  double kExpandedHeight = 180;

  bool _isListView = true;
  late AnimationController _animationController;
  late Animation<double> fadeanimation;

  @override
  void initState() {
    super.initState();
    ref.read(NotesProvider.notifier).getData();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    fadeanimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
    _animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _islight =
        Theme.of(context).brightness == Brightness.light ? true : false;
    final List<DataModel> Notes = ref.watch(NotesProvider);
    final List<RemainderModel> remainders = ref.watch(RemainderProvider);
    final _load = ref.watch(idustateprovider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(left: 20, top: 5),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: _islight ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(50)),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: _islight ? Colors.white : Colors.black,
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 0, top: 5),
            child: GradientText(
              gradientDirection: GradientDirection.ttb,
              gradientType: GradientType.linear,
              widget.isRemainder ? "Remainders" : "Notes",
              colors: _islight
                  ? [
                      Colors.black,
                      Colors.black
                      // const Color.fromARGB(255, 239, 104, 80),
                      // Color.fromARGB(255, 127, 7, 135),
                    ]
                  : [Colors.white, Colors.white],
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
            ),
          ),
          Spacer(),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: search(),
                        type: PageTransitionType.scale,
                        alignment: Alignment.topRight));
              },
              icon: SvgPicture.asset(
                'lib/Assets/images/IOS_search.svg',
                height: 28,
                width: 28,
              )),
          IconButton(
              onPressed: () {
                setState(() {
                  _isListView = !_isListView;
                  print(_animationController.status);
                  _animationController.reset();
                  _animationController.forward();

                  // _animationController.forward();
                });
              },
              icon: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: FadeTransition(
                  opacity: fadeanimation,
                  child: Icon(
                    _isListView
                        ? Icons.grid_view_rounded
                        : Icons.format_list_bulleted,
                    size: 34,
                    color: _islight ? Colors.black : Colors.white,
                  ),
                ),
              )),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: _load
              ? Center(
                  child: LoadingAnimationWidget.dotsTriangle(
                      color: Colors.black, size: 50),
                )
              : _isListView
                  ? FadeTransition(
                      opacity: fadeanimation,
                      child: showListView(
                        notes: widget.isRemainder ? remainders : Notes,
                        isReminder: widget.isRemainder,
                      ),
                    )
                  : FadeTransition(
                      opacity: fadeanimation,
                      child: showGridView(
                        isItUsedInBin: false,
                        isRemainder: widget.isRemainder,
                        Notes: widget.isRemainder ? remainders : Notes,
                      ),
                    ),
        ),
      ),
      floatingActionButton: OpenContainer(
        // closedColor: Colors.black,
        // openColor: Colors.black,
        closedElevation: 5,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        transitionType: ContainerTransitionType.fade,
        closedBuilder: (context, action) => FloatingActionButton(
          backgroundColor: _islight ? Colors.black : Colors.white,
          onPressed: action,
          child: Icon(
            Icons.add,
            color: _islight ? Colors.white : Colors.black,
          ),
        ),
        openBuilder: (context, action) =>
            widget.isRemainder ? NewNoteR() : NewNote(),
        tappable: true,
      ),
    );
  }
}
