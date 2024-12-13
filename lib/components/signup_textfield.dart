import 'package:flutter/material.dart';

class CustomTextFieldSignUpUser extends StatelessWidget {

  final controller;
  final String hintText;
  final bool obscureText;

  const CustomTextFieldSignUpUser({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextFormField(

        enableInteractiveSelection: true,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300,width: 2),

          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade600,width: 2),
          ),
          fillColor: Colors.grey[200],
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}
class CustomTextFieldSignUpEmail extends StatelessWidget {

  final controller;
  final String hintText;
  final bool obscureText;

  const CustomTextFieldSignUpEmail({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextFormField(

        enableInteractiveSelection: true,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300,width: 2),

          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade600,width: 2),
          ),
          fillColor: Colors.grey[200],
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}
class CustomTextFieldSignupPhone extends StatelessWidget {

  final controller;
  final String hintText;
  final bool obscureText;

  const CustomTextFieldSignupPhone({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(

        enableInteractiveSelection: true,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone),// this make it inside the textfield
          //icon: const Padding(padding:  EdgeInsets.only(top: 0.0),
          //  child:  Icon(Icons.phone),
          //), this code for set the icon outside the textfield
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300,width: 2),

          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade600,width: 2),
          ),
          fillColor: Colors.grey[200],
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}
class CustomTextFieldSignupPassword extends StatefulWidget {

  final controller;
  final String hintText;


  const CustomTextFieldSignupPassword({
    super.key,

    required this.controller,
    required this.hintText,

  });

  @override
  State<CustomTextFieldSignupPassword> createState() => _CustomTextFieldSignupPasswordState();
}

class _CustomTextFieldSignupPasswordState extends State<CustomTextFieldSignupPassword> {
  bool secureText = true;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(

        enableInteractiveSelection: true,
        controller: widget.controller,
        obscureText: secureText,

        decoration: InputDecoration(
          suffixIcon: IconButton(icon: Icon(secureText ? Icons.visibility : Icons.visibility_off),
              onPressed:(){
                setState(() {
                  secureText =!  secureText;
                });

              }

          ),
          prefixIcon: Icon(Icons.lock),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300,width: 2),

          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade600,width: 2),
          ),
          fillColor: Colors.grey[200],
          filled: true,
          hintText: widget.hintText,
        ),
      ),
    );
  }
}