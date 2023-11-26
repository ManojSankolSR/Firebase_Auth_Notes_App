import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bottom/theme_config.dart';
import 'package:bottom/widgets/notifysnackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum screens {
  HomeScreen,
  RecycleBinScreen,
}

class HomeScreenDrawer extends StatefulWidget {
  final bool islight;
  PageController pagecontoller;
  HomeScreenDrawer(
      {super.key, required this.islight, required this.pagecontoller});

  @override
  State<HomeScreenDrawer> createState() => _HomeScreenDrawerState();
}

class _HomeScreenDrawerState extends State<HomeScreenDrawer>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late screens screen;
  @override
  void initState() {
    // TODO: implement initState
    screen = widget.pagecontoller.page == 0
        ? screens.HomeScreen
        : screens.RecycleBinScreen;
    _animationController =
        AnimationController(vsync: this, duration: Duration(microseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      // width: MediaQuery.of(context).size.width * .70,
      elevation: 0,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).primaryColor,
              ),
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(left: 15),
              height: 240,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SafeArea(
                        child: Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(50)),
                          child: Align(
                            child: Text(
                                FirebaseAuth
                                    .instance.currentUser!.email!.characters
                                    .take(1)
                                    .toUpperCase()
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35)),
                          ),
                        ),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.topRight,
                        child: ThemeSwitcher.withTheme(
                          builder: (_, switcher, theme) {
                            return IconButton(
                                iconSize: 0,
                                onPressed: () {
                                  switcher.changeTheme(
                                      isReversed: widget.islight,
                                      theme:
                                          theme.brightness == Brightness.light
                                              ? dark
                                              : light);
                                },
                                icon: LottieBuilder.asset(
                                  reverse: false,
                                  controller: _animationController,

                                  height: 40,
                                  "lib/Assets/images/day_night.json",
                                  // controller: _animationController,
                                ));
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser!.displayName == null
                        ? FirebaseAuth.instance.currentUser!.email!.characters
                            .take(5)
                            .toString()
                        : FirebaseAuth.instance.currentUser!.displayName!,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser!.email!,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // ListTile(
            //   title: Text(
            //     "Screens",
            //     style: TextStyle(
            //         fontSize: 20,
            //         color: Theme.of(context).textTheme.bodyLarge!.color),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                selected: screen == screens.HomeScreen ? true : false,
                selectedTileColor: Theme.of(context).primaryColor,
                leading: Icon(
                  Icons.home_outlined,
                  size: 27,
                  color: Theme.of(context).iconTheme.color,
                ),
                onTap: () async {
                  setState(() {
                    screen = screens.HomeScreen;
                  });
                  Navigator.pop(context);
                  widget.pagecontoller.jumpToPage(0);

                  // await widget.pagecontoller.animateToPage(0,
                  //     duration: Duration(milliseconds: 200),
                  //     curve: Curves.linear);
                },
                title: Text(
                  "Home",
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                selected: screen == screens.RecycleBinScreen ? true : false,
                selectedTileColor: Theme.of(context).primaryColor,
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).iconTheme.color,
                  size: 27,
                ),
                onTap: () async {
                  setState(() {
                    screen = screens.RecycleBinScreen;
                  });
                  Navigator.pop(context);
                  // await widget.pagecontoller.animateToPage(1,
                  //     duration: Duration(milliseconds: 200),
                  //     curve: Curves.linear);
                  widget.pagecontoller.jumpToPage(1);
                },
                title: Text(
                  "Deleted",
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
              ),
            ),
            Divider(
              thickness: .3,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                onTap: () {
                  showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) => Dialog(
                            surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(0),
                              height: 400,
                              width: 10,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  LottieBuilder.asset(
                                    frameRate: FrameRate.max,
                                    "lib/Assets/images/logout.json",
                                    height: 150,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Log Out ?",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Do You Really Want\n To Logout",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.grey)),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                    thickness: .3,
                                  ),
                                  ListTile(
                                      dense: true,
                                      minVerticalPadding: 0,
                                      contentPadding: EdgeInsets.zero,
                                      visualDensity: VisualDensity(
                                          horizontal: 0, vertical: -2),
                                      onTap: () {
                                        FirebaseAuth.instance.signOut();
                                        Navigator.pop(context);
                                      },
                                      title: Center(
                                        child: Text("Log Out",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.red)),
                                      )),
                                  Divider(
                                    color: Colors.grey,
                                    thickness: .3,
                                  ),
                                  ListTile(
                                    dense: true,
                                    minVerticalPadding: 0,
                                    // contentPadding: EdgeInsets.zero,
                                    visualDensity: VisualDensity(
                                        horizontal: 0, vertical: -4),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },

                                    title: Center(
                                      child: Text("cancel",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                },
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).iconTheme.color,
                  size: 25,
                ),
                title: Text(
                  "Log Out",
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
