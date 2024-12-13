import 'package:flutter/material.dart';

class GoogleApplel extends StatefulWidget {

  final String iconPath;
  final Function()? onTap;

  const GoogleApplel({
          super.key,
          required this.onTap,
          required this.iconPath,
  });

  @override
  State<GoogleApplel> createState() => _GoogleApplelState();
}

class _GoogleApplelState extends State<GoogleApplel> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(

        child: Image.asset(widget.iconPath,height: 40,),


      ),
    );
  }
}
