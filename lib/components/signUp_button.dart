import 'package:flutter/material.dart';



class SignupButton extends StatefulWidget {
  final Function()? onPressed;

  const SignupButton({super.key, required this.onPressed});

  @override
  State<SignupButton> createState() => _SignupButtonState();
}

class _SignupButtonState extends State<SignupButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(

        child: Container(

          alignment: Alignment.center,
          padding: EdgeInsets.all(10),

          child: ElevatedButton(
            child: Text('Sign Up'),

            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue[600],
              textStyle: TextStyle(fontFamily: 'kinetika',fontSize: 16),
              minimumSize: Size(100, 50)
            ),


            onPressed: widget.onPressed,


          ),
        )
    );

  }
}
