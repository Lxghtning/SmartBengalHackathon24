// ignore_for_file: file_names

import 'package:sbhconst/Login/sign_up.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sbhconst/main.dart';
import 'package:sbhconst/Components/myButton.dart';
import 'package:sbhconst/Login/Forgot_Password_Page.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

import '../Components/utils.dart';

//tasked with login and sign up routing
class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  //Helps switch between login and signup

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  //stores the form data
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  //form key is used to check if form has been filled properly or not
  final formKey = GlobalKey<FormState>();

  @override
  //dispose to prevent memory leaks and data leaks
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  Future<void> navigateToSignup(context) async {
    Navigator.push(
        context,
        PageTransition(
          child:  const SignUpWidget(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 1000),
        ));
  }
  @override
  //Log in screen
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#1b2a61"),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Center(
          child: Form(
            key: formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 20),
              Image.asset("assets/const.png"),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextFormField(
                  style: const TextStyle(color: Colors.black),
                  controller: emailController,
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    labelText: 'Email',
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    hintStyle: const TextStyle(color: Colors.black),
                    labelStyle: const TextStyle(color: Colors.black),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Enter a valid email'
                          : null,
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextFormField(
                  style: const TextStyle(color: Colors.black),
                  controller: passwordController,
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    hintStyle: const TextStyle(color: Colors.black),
                    labelStyle: const TextStyle(color: Colors.black),
                  ),
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6
                      ? 'Enter minimum 6 characters'
                      : null,
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Forgot  Password?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: "Sarabun",
                    ),
                  ),
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ForgotPasswordPage(),
                )),
              ),
              const SizedBox(height: 15),
              MyButton(onTap: signIn, text: "Sign In"),
              const SizedBox(height: 15),

              RichText(
                  text: TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap =(){ navigateToSignup(context);},
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: "Sarabun"),
                text: 'No account? Sign Up!',
              )),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 40),
                      backgroundColor: HexColor("#d9eff5"),
                      shadowColor:  HexColor("#d9eff5"),
                    ),
                    onPressed: signInGuest,
                      child: const Text(
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: "Sarabun"),
                        'Log In as Guest!',
                      )),

            ]),
          ),
        )),
      ),
    );
  }

//function for signing in on clicking sign in
  Future<void> signIn() async {
    //showing progress indicartor
    if (formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      //trying to authenticate
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } on FirebaseAuthException catch (e) {
        //exception handling
        Utils.showSnackBar(e.message);
        navigatorKey.currentState!.popUntil((route) => route.isFirst);
      }
      //going to parent route
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }
  Future<void> signInGuest() async {
    //showing progress indicartor
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    //trying to authenticate
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "guest@srimalcards.in",
        password: "alphabetagammatheta"
      );
    } on FirebaseAuthException catch (e) {
      //exception handling
      Utils.showSnackBar(e.message);
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
    //going to parent route
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
