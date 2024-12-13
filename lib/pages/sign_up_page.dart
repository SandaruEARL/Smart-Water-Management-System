import 'package:aqua/pages/navigator.dart';
import 'new_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aqua/components/signUp_button.dart';
import 'package:aqua/pages/login_page.dart';
import '../components/signup_textfield.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future signUserUp() async {
    if (usernameController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            height: 30,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(20)),
            child: const Text("Fields cannot be empty",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "roboto",
                    fontWeight: FontWeight.bold)),
            alignment: Alignment.center,
          ),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.white,
        ),
      );
    } else if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(20)),
            child: const Text("Password does not match.",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "roboto",
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            alignment: Alignment.center,
          ),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.white,
        ),
      );
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          });

      try {
        //create user
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());

        await AddUserDetails(usernameController.text.trim(),
            emailController.text.trim(), phoneController.text.trim());

        Navigator.of(context).pop(); // Close the loading dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Added new user ${usernameController.text.trim()}",
                style: const TextStyle(
                    fontSize: 18,
                    fontFamily: "roboto",
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              alignment: Alignment.center,
            ),
            duration: const Duration(seconds: 4),
            backgroundColor: Colors.white,
          ),
        );

        Get.off(() => const MyNavigationBar(),
            transition: Transition.leftToRight,
            duration: const Duration(milliseconds: 400));
      } on FirebaseException catch (e) {
        Navigator.of(context).pop(); // Close the loading dialog if there's an error

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(20)),
              child: Text(
                "${e.message}",
                style: const TextStyle(
                    fontSize: 15,
                    fontFamily: "roboto",
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              alignment: Alignment.center,
            ),
            duration: const Duration(seconds: 4),
            backgroundColor: Colors.white,
          ),
        );
      }
    }
  }

  //add user
  Future AddUserDetails(String name, String email, String phone) async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'Username': name,
        'Email': email,
        'Phone': phone,
      });
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(20)),
            child: Text(
              "${e.message}",
              style: const TextStyle(
                  fontSize: 15,
                  fontFamily: "roboto",
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            alignment: Alignment.center,
          ),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.white,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              //--------------------------------Signup_text--------------------------------------
              Text(
                "SIGN UP",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 20,
                  fontFamily: 'Kinetika',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //---------------------------------username---------------------------------------(signup_textfields.dart)
              CustomTextFieldSignUpUser(
                controller: usernameController,
                hintText: "Username",
                obscureText: false,
              ),
              const SizedBox(
                height: 20,
              ),
              //--------------------------------email--------------------------------------------(signup_textfields.dart)
              CustomTextFieldSignUpEmail(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
              ),
              const SizedBox(
                height: 20,
              ),
              //--------------------------------phone-------------------------------------------(signup_textfields.dart)
              CustomTextFieldSignupPhone(
                controller: phoneController,
                hintText: "Phone",
                obscureText: false,
              ),
              const SizedBox(
                height: 20,
              ),
              //------------------------------------------password_field-----------------------(signup_textfields.dart)
              CustomTextFieldSignupPassword(
                controller: passwordController,
                hintText: "Password",
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFieldSignupPassword(
                controller: confirmPasswordController,
                hintText: "Confirm Password",
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Already have an account?',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontFamily: 'Kinetika')),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                  const LoginPage()));
                        },
                        child: Text('Login',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue[600],
                                fontFamily: 'Kinetika'))),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SignupButton(onPressed: signUserUp), //sign in button(lib/components)
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
