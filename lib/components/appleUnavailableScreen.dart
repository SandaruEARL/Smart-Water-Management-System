import 'package:flutter/material.dart';

class AppleUnavailable extends StatelessWidget {
  const AppleUnavailable({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      
      body: Text("Unavailable at the moment",style: TextStyle(fontSize: 16)),
      
    );
  }
}

