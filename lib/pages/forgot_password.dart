import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();

}

class _ForgotPasswordState extends State<ForgotPassword> {
  final mailController = TextEditingController();

  @override
  void dispose() {
    mailController.dispose();
    super.dispose();
  }
  Future passwordReset() async{
    try{
       await FirebaseAuth.instance.sendPasswordResetEmail(email: mailController.text.trim());
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Container(height: 30,decoration: BoxDecoration(color: Colors.green),child: Text("Rest link sent successfully",style: TextStyle(fontSize: 18,fontFamily: "roboto",fontWeight: FontWeight.bold,color: Colors.white)),alignment: Alignment.center,),duration: Durations.long4,backgroundColor: Colors.green,));


    }on FirebaseException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Container(height: 30,decoration: BoxDecoration(color: Colors.red),child: Text(e.code.toString(),style: TextStyle(fontSize: 18,fontFamily: "roboto",fontWeight: FontWeight.bold)),alignment: Alignment.center,),duration: Durations.long4,backgroundColor: Colors.red,));


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(iconTheme: IconThemeData(color: Colors.white,size: 30),

        backgroundColor: Colors.blue[600],
        title: const Text("back",style: TextStyle(color: Colors.white),),

      ),

      body: Column(
        children: [
          const SizedBox(height: 100),
          Text("Enter your Email to send the password reset link",style: TextStyle(fontSize: 16),),
          Padding(

            padding: const EdgeInsets.all(30.0),
            child: TextField(

              controller: mailController,
              enableInteractiveSelection: true,
              decoration: InputDecoration(


                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300,width: 2),

                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue.shade600,width: 2),
                ),
                fillColor: Colors.grey[200],
                filled: true,
                hintText: "Email",
              ),
            ),
          ),

          ElevatedButton(
            child: Text('Send'),

            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue[600],
              textStyle: TextStyle(fontFamily: 'kinetika',fontSize: 16),
              minimumSize: Size(100,60),
            ),

            onPressed: passwordReset,


          ),
        ],

      ),

    );
  }
}



