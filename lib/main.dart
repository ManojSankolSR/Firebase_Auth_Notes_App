import 'package:bottom/Notification.dart';
import 'package:bottom/Screens/NotesScreen.dart';
import 'package:bottom/Screens/LoginScreens/login.dart';
import 'package:bottom/Screens/HomeScreen.dart';
import 'package:bottom/Screens/loadinscreen.dart';
import 'package:bottom/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

LinearGradient colorgradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    stops: [
      .4,
      .8
    ],
    colors: [
      const Color.fromARGB(255, 239, 104, 80),
      Color.fromARGB(255, 127, 7, 135),
    ]);

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 143, 52, 170),
);
final isPlatformDark =
    WidgetsBinding.instance!.window.platformBrightness == Brightness.dark;
final initTheme = isPlatformDark ? ThemeData.dark() : ThemeData.light();

final firinstance = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ProviderScope(
        child: ThemeProvider(
      initTheme: light,
      builder: (p0, theme) {
        return MaterialApp(
            navigatorKey: navigatorKey, theme: theme, home: NotesApp());
      },
    )),
  );
}

class NotesApp extends StatelessWidget {
  NotesApp({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: firinstance.authStateChanges(),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   print("waiting");
        //   return const Scaffold(
        //     body: Center(child: CircularProgressIndicator()),
        //   );
        // }
        if (snapshot.hasData) {
          return loadingScreen();
        } else {
          return login();
        }
      },
    );
  }
}
