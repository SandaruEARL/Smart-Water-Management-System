
import 'package:flutter/material.dart';
import 'login_button.dart';


class CustomTextFieldUsername extends StatelessWidget {

      final controller;
      final String hintText;
      final readOnly;

      const CustomTextFieldUsername({
        super.key,
        required this.readOnly,
        required this.controller,
        required this.hintText,

      });

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: TextFormField(

          readOnly: readOnly,
          enableInteractiveSelection: true,
          controller: controller,

          decoration: InputDecoration(
              icon: const Padding(padding: const EdgeInsets.only(top: 0.0),
                child: const Icon(Icons.person),
              ),
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

class CustomTextFieldPassword extends StatefulWidget {

  final controller;
  final readOnly;
  final String hintText;


  const CustomTextFieldPassword({
    super.key,

    required this.readOnly,
    required this.controller,
    required this.hintText,

  });

  @override
  State<CustomTextFieldPassword> createState() => _CustomTextFieldPasswordState();
}

class _CustomTextFieldPasswordState extends State<CustomTextFieldPassword> {

  bool secureText = true;

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(

        enableInteractiveSelection: true,
        readOnly: widget.readOnly,
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

          icon: const Padding(padding: const EdgeInsets.only(top: 0.0),
            child: const Icon(Icons.lock),

          ),
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
