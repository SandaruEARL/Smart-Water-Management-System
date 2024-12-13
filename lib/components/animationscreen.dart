import 'dart:async';
import 'package:aqua/pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

import '../pages/login_page.dart';

class StartAnimate extends StatefulWidget {
  const StartAnimate({super.key});

  @override
  State<StartAnimate> createState() => _StartAnimateState();
}

class _StartAnimateState extends State<StartAnimate> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Get.off(() => const AuthPage(), transition: Transition.leftToRight,duration: Duration(milliseconds: 400));
          //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AuthPage()));
    });
  }



  @override
  Widget build(BuildContext context) {




    return Scaffold(

      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Lottie.asset("assets/animation2.json"),

        ],

      ),

    );
  }
}
