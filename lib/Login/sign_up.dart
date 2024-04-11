// ignore_for_file: non_constant_identifier_names

import 'package:sbhconst/Login/LoginWidget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sbhconst/main.dart';
import 'package:sbhconst/Components/database.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

import '../Components/myButton.dart';
import '../Components/utils.dart';

//widget that deals with sign up
class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  //function to help route auth


  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  //controllers to store form data
  final emailController = TextEditingController();
  final PhoneController = TextEditingController();
  final addressController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  //dispose is used to prevent memory leaks and data stealing
  void dispose() {
    PhoneController.dispose();
    addressController.dispose();
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  
  Future<void> navigateToLogin(context) async {
    Navigator.push(
        context,
        PageTransition(
          child:  const LoginWidget(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 1000),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#d9eff5"),
        automaticallyImplyLeading: true,
        elevation: 0,
        title: const Text("Sign Up", style: TextStyle(fontSize: 24)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
                  child: Center(
                child: Form(
                  key: formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.black),
                            controller: nameController,
                            cursorColor: Colors.black,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Name',
                              labelText: 'Name',
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              hintStyle: const TextStyle(color: Colors.black),
                              labelStyle: const TextStyle(color: Colors.black),
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (name) =>
                                // ignore: prefer_is_empty
                                name!.length == 0 ? 'Enter a valid name' : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.black),
                            controller: PhoneController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            cursorColor: Colors.black,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Phone No.',
                              labelText: 'Phone No. ',
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey.shade400),
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              hintStyle: const TextStyle(color: Colors.black),
                              labelStyle: const TextStyle(color: Colors.black),
                            ),
                            autovalidateMode: AutovalidateMode.disabled,
                            validator: (clas) => (clas == null ||
                                int.parse(clas) < 1000000000 ||
                                int.parse(clas) > 9999999999)
                                ? 'Enter a valid phone.no of 10 digits '
                                : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.black),
                            controller: addressController,
                            cursorColor: Colors.black,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Address',
                              labelText: 'Address',
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey.shade400),
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              hintStyle: const TextStyle(color: Colors.black),
                              labelStyle: const TextStyle(color: Colors.black),
                            ),
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            validator: (name) =>
                            // ignore: prefer_is_empty
                            name!.length == 0 ? 'Enter a valid address' : null,
                          ),
                        ),
                        const SizedBox(height: 8),
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
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              hintStyle: const TextStyle(color: Colors.black),
                              labelStyle: const TextStyle(color: Colors.black),
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (email) => email != null &&
                                    !EmailValidator.validate(email) &&
                                    !email.startsWith("craftsandprints")
                                ? 'Enter a valid email'
                                : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.black),
                            controller: passwordController,
                            cursorColor: Colors.black,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Password',
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              hintStyle: const TextStyle(color: Colors.black),
                              labelStyle: const TextStyle(color: Colors.black),
                            ),
                            obscureText: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                value != null && value.length < 6
                                    ? 'Enter minimum 6 characters'
                                    : null,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const SizedBox(height: 20),
                        MyButton(
                            onTap: () {
                              signUp();
                            },
                            text: "Sign Up"),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30,0,30,0),
                          child: RichText(
                              text: TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = (){navigateToLogin(context);},
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontFamily: "Sarabun"),
                            text: 'Have An Account? Log In!',
                          )),
                        ),
                      ]),
                ),
              )));}
          

//main signup function, that handles the signup
  Future<void> signUp() async {
    //checks for form validity
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      //trying to create user and login
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      //setting initial user data using the databse service.dart file to cloud firestore
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .setInitialUserData(
              addressController.text.trim(),
              nameController.text.trim(),
              PhoneController.text.trim(),
              emailController.text.trim(),
              );
      FirebaseAuth.instance.currentUser!
          .updateDisplayName(nameController.text.trim());

    } on FirebaseAuthException catch (e) {
      //exception handling
      Utils.showSnackBar(e.message);
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
    //updating the display name
    //popping to first route so that auth state change takes place
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
