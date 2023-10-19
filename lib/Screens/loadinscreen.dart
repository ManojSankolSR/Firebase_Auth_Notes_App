import 'package:bottom/Providers/DataBaseProvider.dart';
import 'package:bottom/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

class loadingScreen extends ConsumerWidget {
  loadingScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return FutureBuilder(
      future: ref.read(DataBaseProvider.notifier).getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return Scaffold(
              body: Center(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Image.asset(
                "lib/Assets/images/notelogo.png",
              ),
              Spacer(),
              LoadingAnimationWidget.prograssiveDots(
                  color: Colors.pink[300]!, size: 80)
            ],
          )));
        }
      },
    );
  }
}
