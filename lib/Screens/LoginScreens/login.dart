// ignore: camel_case_types
import 'package:bottom/Providers/EmailPassProvider.dart';
import 'package:bottom/main.dart';
import 'package:bottom/Screens/LoginScreens/page1.dart';
import 'package:bottom/Screens/LoginScreens/page2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

typedef MyBuilder = void Function(
    BuildContext context, void Function() methodFromChild);

class login extends ConsumerStatefulWidget {
  login({super.key});

  @override
  ConsumerState<login> createState() => _loginState();
}

class _loginState extends ConsumerState<login> {
  late void Function() myMethod;
  int? val = 0;
  bool _signup = true;
  TextEditingController mailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();

  late PageController _pagecont;
  @override
  void initState() {
    // TODO: implement initState
    _pagecont = PageController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _pagecont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double prog = _pagecont.hasClients ? _pagecont.page ?? 0 : 0;
    bool _pro = ref.watch(processingstateprovider);

    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
                // color: Color.fromARGB(255, 241, 199, 255),
                ),
            if (MediaQuery.of(context).viewInsets.bottom <= 0)
              Positioned(
                left: 75 + prog * 20,
                bottom: 420 + prog * 110,
                child: Container(
                    height: 300 - prog * 60,
                    width: 250 - prog * 60,
                    // decoration: BoxDecoration(color: Colors.white),
                    child: SvgPicture.asset(
                      'lib/Assets/images/signup.svg',
                      alignment: Alignment.topCenter,
                    )),
              ),
            if (MediaQuery.of(context).viewInsets.bottom <= 0)
              Positioned(
                  top: 0,
                  left: 0,
                  child: Transform.rotate(
                      angle: 3.13,
                      child: Container(
                        height: .16 * MediaQuery.of(context).size.height,
                        child: Image.asset(
                          'lib/Assets/images/top.png',
                          // height: .20 * MediaQuery.of(context).size.height,
                          // width: .55 * MediaQuery.of(context).size.width,
                        ),
                      ))),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 380 + prog * 160,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 9,
                        offset: Offset(0, 2),
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: PageView(
                  controller: _pagecont,
                  onPageChanged: (value) {
                    val = value;
                    if (val == 0) {
                      FocusScope.of(context).unfocus();
                    }
                    print(val);
                  },
                  children: [
                    page1(),
                    page2(
                      builder: (context, methodFromChild) {
                        myMethod = methodFromChild;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                height: 52,
                bottom: 40 + prog * 75,
                right: 16,
                child: InkWell(
                  onTap: () {
                    if (val == 0) {
                      _pagecont.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.linear);
                    } else {
                      myMethod.call();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 15),
                              blurRadius: 22,
                              color: Colors.black.withOpacity(.22)),
                          BoxShadow(
                              offset: Offset(-15, -15),
                              blurRadius: 20,
                              color: Colors.white)
                        ],
                        gradient: colorgradient),
                    child: _pro
                        ? LoadingAnimationWidget.horizontalRotatingDots(
                            color: Colors.white, size: 50)
                        : Row(
                            children: [
                              Text(
                                "Continue ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                              Container(
                                padding: EdgeInsets.all(4),
                                margin: EdgeInsets.only(left: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                  ),
                )),
          ],
        ));
  }
}
