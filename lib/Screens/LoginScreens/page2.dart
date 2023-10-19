import 'package:bottom/Providers/DataBaseProvider.dart';
import 'package:bottom/Providers/EmailPassProvider.dart';
import 'package:bottom/Screens/LoginScreens/login.dart';
import 'package:bottom/main.dart';
import 'package:bottom/widgets/notifysnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class page2 extends ConsumerStatefulWidget {
  final MyBuilder builder;
  page2({
    required this.builder,
  });

  @override
  ConsumerState<page2> createState() => _page2State();
}

class _page2State extends ConsumerState<page2> {
  bool _signup = true;
  bool _processing = false;
  // UserCredential? user;

  final _formKey = GlobalKey<FormState>();
  String? _Email;
  String? _password;

  void validation() async {
    if (_formKey.currentState!.validate()) {
      ref.read(processingstateprovider.notifier).state = true;
      _formKey.currentState!.save();
      try {
        if (_signup) {
          final user = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _Email!, password: _password!);
          if (context.mounted) {
            (
              "Login Sucess",
              "Welcome Back ${user.user!.email!}",
              context,
              ContentType.success
            );
          }
        } else {
          final user = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _Email!, password: _password!);
          if (context.mounted) {
            Notify("Login Sucess", "Welcome Back ${user.user!.email!}", context,
                ContentType.success);
          }
        }
      } on FirebaseAuthException catch (e) {
        ref.read(processingstateprovider.notifier).state = false;
        if (context.mounted) {
          Notify(e.message!, e.code, context, ContentType.failure);
        }
      } finally {
        ref.read(processingstateprovider.notifier).state = false;
      }
    }
  }

  signInWithGoogle() async {
    try {
      setState(() {
        _processing = true;
      });
      final GoogleSignInAccount? Guser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? Gauth = await Guser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: Gauth!.accessToken,
        idToken: Gauth.idToken,
      );
      UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(credential);
      // print();
      if (context.mounted) {
        Notify(" Login Sucess", "Welcome ${user.user!.displayName}", context,
            ContentType.success);
      }

      setState(() {
        _processing = false;
      });
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        Notify(e.message!, e.code, context, ContentType.failure);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.builder.call(context, validation);
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              _signup ? "Create An Account" : "Sign In...!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.trim().isEmpty ||
                        !value.contains('@') ||
                        !value.contains('.com')) {
                      return "Invaid Email Adress";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    setState(() {
                      _Email = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(fontSize: 18),
                    prefixIcon: Icon(
                      Icons.person_outline_sharp,
                    ),
                    focusedErrorBorder: GradientOutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          stops: [
                            .4,
                            .8
                          ],
                          colors: [
                            Color.fromARGB(255, 225, 13, 13),
                            Color.fromARGB(255, 235, 8, 107),
                          ]),
                    ),
                    errorBorder: GradientOutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          stops: [
                            .4,
                            .8
                          ],
                          colors: [
                            Color.fromARGB(255, 225, 13, 13),
                            Color.fromARGB(255, 235, 8, 107),
                          ]),
                    ),
                    enabledBorder: GradientOutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      gradient: colorgradient,
                    ),
                    focusedBorder: GradientOutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      width: 2,
                      gradient: colorgradient,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value!.trim().isEmpty || !(value.length > 6)) {
                        return "Password shoud be greater than 6 charecters";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      setState(() {
                        _password = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      focusedErrorBorder: GradientOutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            stops: [
                              .4,
                              .8
                            ],
                            colors: [
                              Color.fromARGB(255, 225, 13, 13),
                              Color.fromARGB(255, 235, 8, 107),
                            ]),
                      ),
                      errorBorder: GradientOutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            stops: [
                              .4,
                              .8
                            ],
                            colors: [
                              Color.fromARGB(255, 225, 13, 13),
                              Color.fromARGB(255, 235, 8, 107),
                            ]),
                      ),
                      hintText: "Password",
                      hintStyle: TextStyle(fontSize: 18),
                      prefixIcon: Icon(
                        Icons.lock,
                      ),
                      enabledBorder: GradientOutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        gradient: colorgradient,
                      ),
                      focusedBorder: GradientOutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        width: 2,
                        gradient: colorgradient,
                      ),
                    )),
              ],
            ),
          ),
          // Spacer(),

          SizedBox(
            height: 20,
          ),
          Align(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _signup = !_signup;
                });
                print(_signup);
              },
              child: Row(
                children: [
                  Text(
                    _signup == true
                        ? "Already Have An Account?"
                        : "Dont Have An Account?",
                    style: TextStyle(color: Color.fromARGB(255, 116, 116, 116)),
                  ),
                  Text(
                    _signup ? " Sign In." : " Sign Up.",
                    style: TextStyle(color: Colors.blue, fontSize: 17),
                  )
                ],
              ),
            ),
          ),
          // SizedBox(
          //   height: 20,
          // ),
          if (_signup == false)
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 85,
                    left: 0,
                    child: InkWell(
                      onTap: _processing ? null : signInWithGoogle,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: _processing
                            ? LoadingAnimationWidget.threeRotatingDots(
                                color: Colors.white, size: 40)
                            : Image.asset('lib/Assets/images/google.png',
                                color: Colors.white),
                        height: 55,
                        width: 100,
                        decoration: BoxDecoration(
                          gradient: colorgradient,
                          color: Colors.white,
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
