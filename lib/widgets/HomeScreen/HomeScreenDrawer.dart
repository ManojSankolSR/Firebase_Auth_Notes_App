import 'package:animated_icon/animated_icon.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bottom/theme_config.dart';
import 'package:bottom/widgets/notifysnackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreenDrawer extends StatelessWidget {
  final bool islight;
  HomeScreenDrawer({super.key, required this.islight});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      elevation: 0,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20),
              color: Theme.of(context).primaryColor,
              height: MediaQuery.of(context).size.height * .30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            return AnimateIcon(
                                iconType: IconType.toggleIcon,
                                animateIcon: AnimateIcons.dayNightWeather,
                                onTap: () {
                                  switcher.changeTheme(
                                      isReversed: !islight,
                                      theme:
                                          theme.brightness == Brightness.light
                                              ? dark
                                              : light);
                                }
                                // icon: Icon(
                                //     islight
                                //         ? Icons.brightness_3
                                //         : Icons.sunny,
                                //     size: 40,
                                //     color: islight
                                //         ? Color.fromARGB(
                                //             255, 255, 81, 0)
                                //         : Colors.yellow),
                                );
                          },
                        ),
                      ),

                      // ElevatedButton(
                      //     onPressed: () {
                      //       // Notificationservice().shownot();
                      //       showTimePicker(
                      //           context: context, initialTime: TimeOfDay.now());
                      //     },
                      //     child: Text("press"))
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
            InkWell(
              onTap: () {
                showCupertinoDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) => AlertDialog(
                    elevation: 0,
                    // insetPadding: EdgeInsets.all(10),
                    // iconPadding: EdgeInsets.all(0),
                    // titlePadding: EdgeInsets.all(0),
                    actionsPadding: EdgeInsets.only(top: 30, bottom: 20),
                    // buttonPadding: EdgeInsets.all(0),
                    // contentPadding: EdgeInsets.all(0),

                    // title: Text("Do You Really Want To Log Out..?"),
                    actions: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Log Out?",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Do You Really Want To Logout",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey)),
                          SizedBox(
                            height: 40,
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: .3,
                          ),
                          ListTile(
                              dense: true,
                              minVerticalPadding: 0,
                              // contentPadding: EdgeInsets.zero,
                              visualDensity:
                                  VisualDensity(horizontal: 0, vertical: -2),
                              onTap: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.pop(context);
                              },
                              title: Center(
                                child: Text("Log Out",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
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
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
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
                      )
                    ],
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(children: [
                  Icon(Icons.logout),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Log Out",
                    style: TextStyle(
                        fontSize: 20,
                        color: islight ? Colors.black : Colors.white),
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
