
import 'package:aqua/components/animationscreen.dart';
import 'package:flutter/material.dart';
import 'package:aqua/pages/navigator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:aqua/firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';




void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await Future.delayed(const Duration(milliseconds: 1500));
  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    return const GetMaterialApp(

        debugShowCheckedModeBanner: false,
        home:StartAnimate(),


    );
  }
}


