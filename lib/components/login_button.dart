import 'package:flutter/material.dart';
import 'login_textfield.dart';

class LoginButton extends StatefulWidget {
  final Function()? onPressed;

  const LoginButton({super.key, required this.onPressed});

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      child: Container(

        alignment: Alignment.center,
         padding: EdgeInsets.all(35),

         child: ElevatedButton(
           child: Text('Login'),

           style: ElevatedButton.styleFrom(
             foregroundColor: Colors.white,
             backgroundColor: Colors.blue[600],
             textStyle: TextStyle(fontFamily: 'kinetika',fontSize: 16),
             minimumSize: Size(100,60),
          ),

          onPressed: widget.onPressed,


         ),
      )
    );

  }
}
