import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bottom/Notification.dart';
import 'package:bottom/Models/RemainderModel.dart';
import 'package:bottom/Providers/RemainderProvider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bottom/Models/DataModel.dart';
import 'package:bottom/Remainders/NewNoteScreen.dart';
import 'package:bottom/Screens/NotesScreen.dart';
import 'package:bottom/Providers/DataBaseProvider.dart';
import 'package:bottom/Screens/NewNoteScreen.dart';
import 'package:bottom/widgets/HomeScreen/HomeScreenDrawer.dart';
import 'package:bottom/widgets/HomeScreen/Timelinecontainer.dart';
import 'package:bottom/widgets/HomeScreen/customContiner.dart';
import 'package:bottom/widgets/HomeScreen/homelist.dart';
import 'package:bottom/widgets/notifysnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

typedef MyBuilder = void Function(
    BuildContext context, void Function(DateTime dateTime) listfetcher);

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({
    super.key,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late TabController _tabController;
  DateTime _dateTime = DateTime.now();
  late void Function(DateTime dateTime) myMethod;

  List notes = [];
  List remainders = [];
  DateTime date = DateTime.now();
  bool isDarkMode = false;
  late AnimationController _animationController;
  bool _isForward = true;

  void initState() {
    super.initState();

    AwesomeNotifications().setListeners(
        onActionReceivedMethod: Notificationservice.onActionReceivedMethod,
        onNotificationDisplayedMethod:
            Notificationservice.onNotificationDisplayedMethod);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    ref.read(DataBaseProvider.notifier).getData();
    ref.read(RemainderProvider.notifier).getData();

    _tabController = TabController(length: 2, vsync: this);
  }

  void showBottom() {
    showModalBottomSheet(
      elevation: 0,
      showDragHandle: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => Container(
        margin: const EdgeInsets.only(bottom: 20, left: 15, right: 15, top: 0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              "Notes",
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 5),
              child: Divider(
                thickness: .5,
                color: Colors.black,
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                print(constraints.maxWidth);
                return constraints.maxWidth <= 250
                    ? Column(
                        children: [
                          Spacer(),
                          Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: NewNote(),
                                        type: PageTransitionType.bottomToTop));
                              },
                              child: Container(
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    Text(
                                      "Add Note",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: NewNoteR(),
                                        type: PageTransitionType.bottomToTop));
                              },
                              child: Container(
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    Text(
                                      "Add Remainder",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      )
                    : Row(
                        children: [
                          Spacer(),
                          Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: NewNote(),
                                        type: PageTransitionType.bottomToTop));
                              },
                              child: Container(
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    Text(
                                      "Add Note",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: NewNoteR(),
                                        type: PageTransitionType.bottomToTop));
                              },
                              child: Container(
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    Text(
                                      "Add Remainder",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      );
              },
            )
          ],
        ),
      ),
    ).then(
      (value) {
        if (!_isForward) {
          _animationController.reverse();
          _isForward = true;
        }
      },
    );
  }

  Future<void> _refresh() {
    // if (assing() == ConnectivityResult.none) {
    //   print(Connectivity().checkConnectivity());
    //   Notify("No Connection", "Offline", context, ContentType.failure);
    //   return Future.delayed(Duration.zero);
    // } else {
    //   print(Connectivity().checkConnectivity());

    // }
    ref.read(RemainderProvider.notifier).getData();
    return ref.read(DataBaseProvider.notifier).getData();
  }

  @override
  Widget build(BuildContext context) {
    final _islight =
        Theme.of(context).brightness == Brightness.light ? true : false;

    List<DataModel> notes = ref
        .watch(DataBaseProvider.select((value) => value.where((element) =>
            (element.date.year == date.year &&
                element.date.month == date.month &&
                element.date.day == date.day))))
        .toList();
    List<RemainderModel> remainders = ref
        .watch(RemainderProvider.select((value) => value.where((element) =>
            (element.rdate.year == date.year &&
                element.rdate.month == date.month &&
                element.rdate.day == date.day))))
        .toList();

    // TODO: implement build
    return ThemeSwitchingArea(
      child: Builder(builder: (context) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: HomeScreenDrawer(islight: _islight),
          // drawer: Drawer(
          //     width: MediaQuery.of(context).size.width * .7,
          //     child: Column(
          //       children: [
          //         SafeArea(
          //             child: LottieBuilder.asset(
          //           "lib/Assets/images/drnote.json",
          //         )),
          //         SizedBox(
          //           height: 30,
          //         ),
          //         // Container(
          //         //     decoration: BoxDecoration(
          //         //         gradient: LinearGradient(colors: [
          //         //       // Color.fromRGBO(0, 0, 0, 1),
          //         //       // Color.fromRGBO(146, 60, 181, 1),
          //         //       Colors.black87,
          //         //       Colors.black87
          //         //       // Color.fromRGBO(192, 72, 72, 1),
          //         //       // Color.fromRGBO(75, 18, 72, 1),
          //         //       // Color.fromRGBO(54, 0, 51, 1),
          //         //       // Color.fromRGBO(11, 135, 147, 1)
          //         //     ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          //         //     width: MediaQuery.of(context).size.width * .7,
          //         //     padding: EdgeInsets.only(top: 40),
          //         //     child:),
          // InkWell(
          //   onTap: () {
          //     showDialog(
          //       context: context,
          //       builder: (context) => AlertDialog(
          //         backgroundColor: Colors.white,
          //         title: Text("Do You Really Want To Log Out..?"),
          //         actions: [
          //           ElevatedButton(
          //               style: ButtonStyle(
          //                   shape: MaterialStatePropertyAll(
          //                       RoundedRectangleBorder(
          //                           borderRadius:
          //                               BorderRadius.circular(
          //                                   15))),
          //                   backgroundColor:
          //                       MaterialStatePropertyAll(
          //                           (Colors.black)),
          //                   foregroundColor:
          //                       MaterialStatePropertyAll(
          //                           Colors.white)),
          //               onPressed: () {
          //                 Navigator.pop(context);
          //               },
          //               child: Text("Cancel")),
          //           ElevatedButton(
          //               style: ButtonStyle(
          //                   shape: MaterialStatePropertyAll(
          //                       RoundedRectangleBorder(
          //                           borderRadius:
          //                               BorderRadius.circular(
          //                                   15))),
          //                   backgroundColor:
          //                       MaterialStatePropertyAll(
          //                           (Colors.black)),
          //                   foregroundColor:
          //                       MaterialStatePropertyAll(
          //                           Colors.white)),
          //               onPressed: () {
          //                 FirebaseAuth.instance.signOut();
          //                 Navigator.pop(context);
          //                 Notify("Thank You", "Logged Out",
          //                     context, ContentType.warning);
          //               },
          //               child: Text("Log out")),
          //         ],
          //       ),
          //     );
          //   },
          //   child: Container(
          //               // color: ,

          //               // width: MediaQuery.of(context).size.width * .7,
          //               padding: EdgeInsets.symmetric(
          //                   horizontal: 0, vertical: 23),
          //               child: Row(
          //                 children: [
          //                   SizedBox(
          //                     width: 20,
          //                   ),
          //                   GradientText(
          //                     "Log Out",
          //                     colors: [
          //                       Colors.black87,
          //                       Colors.black87
          //                       // Color.fromRGBO(54, 0, 51, 1),
          //                       // Color.fromRGBO(11, 135, 147, 1)
          //                     ],
          //                     style: TextStyle(
          //                         color: Colors.black,
          //                         fontSize: 25,
          //                         fontWeight: FontWeight.w500),
          //                   ),
          //                   SizedBox(
          //                     width: 20,
          //                   ),
          //                   Icon(
          //                     Icons.logout,
          //                     color: Colors.black,
          //                     size: 30,
          //                   ),
          //                   Spacer(),
          //                 ],
          //               )),
          //         )
          //       ],
          //     )),
          appBar: AppBar(
            toolbarHeight: 70,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,

            title: Row(
              children: [
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     // Text(
                //     //   "Hi",
                //     //   style: TextStyle(fontSize: 35),
                //     // ),
                //     GradientText(
                //       "Hi. \n${FirebaseAuth.instance.currentUser!.displayName == null ? "Mr Nobody" : FirebaseAuth.instance.currentUser!.displayName!.characters.take(8).toString()}..",
                //       colors: [
                //         Color.fromRGBO(54, 0, 51, 1),
                //         Color.fromRGBO(11, 135, 147, 1)
                //       ],
                //       style: TextStyle(
                //         fontSize: 35,
                //       ),
                //     )
                //   ],
                // ),

                Material(
                  borderRadius: BorderRadius.circular(15),
                  color: _islight ? Colors.black : Colors.white,
                  child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        height: 55,
                        decoration: BoxDecoration(
                          // gradient: LinearGradient(
                          //     colors: [
                          //       // Color.fromRGBO(192, 72, 72, 1),
                          //       // Color.fromRGBO(75, 18, 72, 1),
                          //       Colors.black,
                          //       Colors.black

                          //       // Color.fromRGBO(0, 0, 0, 1),
                          //       // Color.fromRGBO(146, 60, 181, 1),
                          //     ],
                          //     begin: Alignment.topLeft,
                          //     end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(
                          "lib/Assets/images/menu.png",
                          color: _islight ? Colors.white : Colors.black,
                        ),
                        // child: AnimatedIcon(
                        //     color: Colors.black,
                        //     size: 40,
                        //     icon: AnimatedIcons.menu_close,
                        //     progress: _animationController),
                      )),
                ),
                // Spacer(),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(
                //       "${DateFormat("MMMM\n dd, yyyy").format(DateTime.now())}",
                //       style: TextStyle(
                //         color: Colors.grey[400],
                //         fontSize: 25,
                //       ),
                //     )
                //   ],
                // ),
                Spacer(),
                Material(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(20),
                  color: _islight ? Colors.black : Colors.white,
                  child: InkWell(
                    onTap: () {
                      if (_isForward) {
                        _animationController.forward();
                        _isForward = false;
                      }
                      showBottom();
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          // Icon(
                          //   Icons.add,
                          //   color: _islight ? Colors.white : Colors.black,
                          // ),
                          AnimatedIcon(
                              color: Colors.white,
                              icon: AnimatedIcons.add_event,
                              progress: _animationController),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Add Tasks",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _islight ? Colors.white : Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // title: Row(
            //   children: [
            //     Expanded(
            //         child: InkWell(
            //       onTap: () {
            //         Navigator.push(
            //             context,
            //             PageTransition(
            //                 child: search(),
            //                 type: PageTransitionType.scale,
            //                 alignment: Alignment.topCenter));
            //       },
            //       child: Container(
            //         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            //         height: MediaQuery.of(context).size.height * .055,
            //         decoration: BoxDecoration(
            //             color: Colors.grey[200],
            //             borderRadius: BorderRadius.circular(13)),
            //         child: Row(
            //           children: [
            //             SvgPicture.asset(
            //               'lib/Assets/images/IOS_search.svg',
            //               height: 25,
            //               width: 25,
            //               color: Colors.grey[600],
            //             ),
            //             SizedBox(
            //               width: 14,
            //             ),
            //             Text(
            //               "Search Note",
            //               style: TextStyle(
            //                   fontSize: 17,
            //                   color: Colors.grey[600],
            //                   fontWeight: FontWeight.w400),
            //             ),
            //           ],
            //         ),
            //       ),
            //     )),
            //     IconButton(
            //         onPressed: () {
            //           showDialog(
            //             context: context,
            //             builder: (context) {
            //               return AlertDialog(
            //                 title: Text("Do You Really Want To Logout"),
            //                 actions: [
            //                   TextButton(
            //                       onPressed: () {
            //                         Navigator.pop(context);
            //                       },
            //                       child: Text("Cancel")),
            //                   TextButton(
            //                       onPressed: () {
            //                         Navigator.pop(context);
            //                         FirebaseAuth.instance.signOut();
            //                         Notify("Logged Out", "BYe...!", context,
            //                             ContentType.help);
            //                       },
            //                       child: Text("Log Out"))
            //                 ],
            //               );
            //             },
            //           );
            //           // FirebaseAuth.instance.signOut();
            //         },
            //         icon: const Padding(
            //           padding: const EdgeInsets.only(right: 0),
            //           child: Icon(Icons.logout),
            //         )),
            //   ],
            // ),
          ),
          body: OfflineBuilder(
            connectivityBuilder: (context, value, child) {
              final bool connected = value != ConnectivityResult.none;
              Connectivity()
                  .onConnectivityChanged
                  .listen((ConnectivityResult result) {
                if (result == ConnectivityResult.mobile ||
                    result == ConnectivityResult.wifi) {
                  Notify("connected to Internet", "Back Online", context,
                      ContentType.success);
                }
                if (result == ConnectivityResult.none) {
                  Notify(
                      "No Connection", "Offline", context, ContentType.failure);
                }
              });

              return new Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    height: 24.0,
                    left: 0.0,
                    right: 0.0,
                    child: Visibility(
                      visible: !connected,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 0),
                        color: connected ? Color(0xFF00EE44) : Colors.white,
                        child: Center(
                          child: Text(
                            "${connected ? 'ONLINE' : 'No Connection'}",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ),
                  child,
                ],
              );
            },
            child: RefreshIndicator(
              color: Colors.black,
              notificationPredicate: (notification) => notification.depth == 2,
              onRefresh: _refresh,
              child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return <Widget>[
                      // SliverToBoxAdapter(
                      //   child: SafeArea(
                      //     child: Container(
                      //       margin: EdgeInsets.symmetric(horizontal: 15),
                      // child: Row(
                      //   children: [
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           "Hi \n${FirebaseAuth.instance.currentUser!.displayName}",
                      //           style: TextStyle(
                      //             fontSize: 35,
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //     Spacer(),
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           "${DateFormat("MMMM\n dd, yyyy").format(DateTime.now())}",
                      //           style: TextStyle(
                      //             color: Colors.grey[400],
                      //             fontSize: 25,
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      //     ),
                      //   ),
                      // ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: 10),
                      ),
                      SliverToBoxAdapter(
                          child: Timelinecontainer(
                              changedate: (rdate) {
                                setState(() {
                                  date = rdate;
                                });
                              },
                              islight: _islight)),

                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Row(
                          children: [
                            Spacer(),
                            customContainer(
                                destination: NoteScreen(
                                  isRemainder: false,
                                ),
                                // image: "lib/Assets/images/crop1.png",
                                Barcolor: [
                                  // Color.fromRGBO(146, 60, 181, 1),
                                  // Color.fromRGBO(0, 0, 0, 1),
                                  Colors.black,
                                  Colors.black
                                ],
                                color: [
                                  Color.fromRGBO(54, 0, 51, 100),
                                  Color.fromRGBO(11, 135, 147, 100)
                                ],
                                title: "All Notes "),
                            Spacer(),
                            customContainer(
                                destination: NoteScreen(isRemainder: true),
                                // image: "",
                                Barcolor: [
                                  // Color.fromRGBO(192, 72, 72, 1),
                                  // Color.fromRGBO(75, 18, 72, 1),
                                  // Color.fromRGBO(11, 135, 147, 1),
                                  // Color.fromRGBO(54, 0, 51, 1),
                                  Colors.black,
                                  Colors.black
                                ],
                                color: [
                                  Color.fromRGBO(192, 72, 72, 100),
                                  Color.fromRGBO(75, 18, 72, 100),
                                ],
                                title: "Remainders "),
                            Spacer(),
                          ],
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(left: 15, top: 10),
                          child: Text(
                            "Recent",
                            style: TextStyle(
                                color: _islight ? Colors.black : Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      // SliverAppBar(
                      //   scrolledUnderElevation: 0,
                      //   // backgroundColor: Colors.amber,

                      //   toolbarHeight: 50,

                      //   pinned: true,
                      //   flexibleSpace: FlexibleSpaceBar(
                      //     background: Padding(
                      //       padding: EdgeInsets.only(left: 20, top: 10),
                      //       child: Text(
                      //         "Recent",
                      //         style:
                      //             TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                        sliver: SliverAppBar(
                          automaticallyImplyLeading: false,
                          // backgroundColor: Colors.amber,
                          elevation: 0,
                          scrolledUnderElevation: 0,
                          toolbarHeight: 80,
                          // backgroundColor: Colors.amber,
                          centerTitle: true,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                height: 50,
                                width: 300,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(
                                    15.0,
                                  ),
                                ),
                                child: DefaultTabController(
                                  length: 2,
                                  child: TabBar(
                                    controller: _tabController,
                                    indicatorSize: TabBarIndicatorSize.tab,

                                    // give the indicator a decoration (color and border radius)
                                    indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        10.0,
                                      ),
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            // Color.fromRGBO(192, 72, 72, 1),
                                            // Color.fromRGBO(75, 18, 72, 1),
                                            // Color.fromRGBO(0, 0, 0, 1),
                                            // Color.fromRGBO(146, 60, 181, 1),
                                            Colors.black,
                                            Colors.black
                                          ]),
                                    ),
                                    labelColor: Colors.white,
                                    unselectedLabelColor: Colors.black,
                                    tabs: [
                                      Tab(
                                        text: 'Notes',
                                      ),
                                      Tab(
                                        text: 'Remainders',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // SliverToBoxAdapter(
                      //   child: Container(
                      //     margin: EdgeInsets.only(bottom: 10),
                      //     height: 50,
                      //     child: DefaultTabController(
                      //       length: 2,
                      //       child: TabBar(
                      //           controller: _tabController,
                      //           labelStyle: TextStyle(
                      //               fontSize: 20, fontWeight: FontWeight.w500),
                      //           tabs: [Text("Notes"), Text("Remainders")]),
                      //     ),
                      //   ),
                      // )
                    ];
                  },
                  body: TabBarView(controller: _tabController, children: [
                    Tab(
                      child: homelist(
                        notes: notes,
                        isReminder: false,
                      ),
                    ),
                    Tab(
                        child: homelist(
                      notes: remainders,
                      isReminder: true,
                    )),
                  ])),
            ),
          ),
        );
      }),
    );
  }
}
