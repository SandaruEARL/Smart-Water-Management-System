
import 'package:aqua/components/appleUnavailableScreen.dart';
import 'package:aqua/pages/forgot_password.dart';
import 'package:aqua/services/googlesign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aqua/components/login_button.dart';
import 'package:aqua/components/google_apple_buttons.dart';
import 'package:aqua/components/login_textfield.dart';
import 'package:aqua/pages/sign_up_page.dart';






class LoginPage extends StatefulWidget {


  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

   final usernameController = TextEditingController();
   final passwordController = TextEditingController();
   bool readonly = false;

   //login in method
   void Login()async {


     if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Container(height: 50,decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(20)),child: Text("Fields cannot be empty",style: TextStyle(fontSize: 18,fontFamily: "roboto",fontWeight: FontWeight.bold)),alignment: Alignment.center,),duration: Durations.long4,backgroundColor: Colors.white,));
                    readonly = false;

     }else{
       readonly = true;

       showDialog(
           context: context,
           builder: (context) {
             return const Center(
               child: CircularProgressIndicator(color: Colors.blue,),
             );
           }
       );

       //looking for error like, password mismatch or email mismatch
       try {
         await FirebaseAuth.instance.signInWithEmailAndPassword(


           email: usernameController.text,
           password: passwordController.text,

         );

         Navigator.pop(context);

       } on FirebaseAuthException catch (e) {

           readonly = false;
           Navigator.pop(context);
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Container(height: 50,child: Text(e.code.toString(),style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold,fontFamily: "roboto")),alignment: Alignment.center,),duration: Durations.long4,backgroundColor: Colors.red,));

       }
     }
   }

  @override
  Widget build(BuildContext context) {

      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.blue, // Transparent status bar
      statusBarBrightness: Brightness.dark, // Dark text for status bar

    )); // status bar customization


    return Scaffold(
      resizeToAvoidBottomInset: false, //bottom overflow error is now dismissed
      backgroundColor: Colors.white,

      body: SafeArea(
    
          child: SingleChildScrollView(
            child: Center(

              child: Column(

                  //----------------------------login-page-image------------------------------
                      children: [
                         Container(

                         height: 200,
                         child: Image.asset('icons/img.png'),
                         ),
                         const SizedBox(height: 10,),

                //-------------------------------"LOGIN"_text----------------------------------
                           Text(
                             "LOGIN",
                             style: TextStyle(
                               color: Colors.grey[600],
                               fontSize: 20,
                               fontFamily:'Kinetika',

                             ),
                           ),

                         const SizedBox(height: 10,),//space
               //---------------------------------"username"-------------------------------------
                         //email text field
                         CustomTextFieldUsername(
                                readOnly: readonly,
                                controller: usernameController,
                                hintText: 'Email',

                         ),//component/textfield.dart

                         const SizedBox(height: 20,),//space
               //---------------------------------"password"--------------------------------------
                        //password text field
                         CustomTextFieldPassword(
                           readOnly: readonly,
                           controller: passwordController,
                           hintText: 'Password',

                         ),//component/textfield.dart
                         const SizedBox(height: 10,),

               //----------------------------------"forgot_password_text"---------------------------------------------
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 30.0),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.end,
                             children: [
                               GestureDetector(

                                   onTap: (){
                                     Navigator.push(context, MaterialPageRoute(builder: (context){
                                       return ForgotPassword();
                                     }));
                                   },




                                   child: Text('Forgot Password ?',style:TextStyle(fontSize: 15,color: Colors.blue[600],fontFamily: 'Kinetika') )),

                             ],
                           ),
                         ),

                         const SizedBox(height: 10,),

                         LoginButton(onPressed: Login), //sign in button(lib/components)



                         Text(
                           "Or continue with",
                           style: TextStyle(
                             color: Colors.grey[600],
                             fontSize:15,
                             fontFamily:'Kinetika',

                           ),
                         ),
                         const SizedBox(height: 20,),


               //------------------------------------Apple/Google_sign_in_buttons-----------------------------------
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 150),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.end,
                             children:  [

                               GoogleApplel(iconPath: 'icons/google.png',onTap: () => GoogleAuth().signInWithGoogle()),
                               SizedBox(width: 20,),
                               GoogleApplel(iconPath: 'icons/apple.png',onTap: ()=>const AppleUnavailable(),),
                             ],
                           ),
                         ),
                         const SizedBox(height: 20,),



                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text("Haven't signed up yet? ",style: TextStyle(fontFamily: 'Kinetika',color: Colors.grey[600],fontSize: 16),

                             ),

                             GestureDetector(
                               onTap: (){

                                 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context)=>SignUp()));


                                 },
                               child: Text(' Sign Up',style: TextStyle(fontFamily:'Kinetika',color: Colors.blue[600],fontSize: 16)


                               ),

                             )
                           ],
                         ),


                       ],


              ),

            ),
          )),
    


    );
  }



}

