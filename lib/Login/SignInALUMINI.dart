import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import '/Firebase/Database_Services.dart';

class SignInALUMINI extends StatefulWidget {


  @override
  State<SignInALUMINI> createState() => _SignInALUMINIState();
}

class _SignInALUMINIState extends State<SignInALUMINI> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Database_Services database_services = Database_Services();
  String email = '';
  String password = '';
  bool passview_off = true;
  String error = '';
  String resetEmail = '';

  void SignIn() async {
    try {
      // await Authentication_Services().signIn(email, _passwordController.text);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Color(0xff1B264F),

            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(70.0),
                child: Container(
                  child: Column(
                    children: [
                      Image(image: AssetImage('assets/const_logo.png'), height: 100.0, width: 100.0,),
              
                      Text('Sign Up', style: TextStyle(fontSize: 35.0,fontWeight: FontWeight.w900,color: Colors.white, ),),
                      SizedBox(height: 10.0),
                      Text('Alumini', style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w900,color: Colors.white, ),),
              
                      SizedBox(height: 20.0),
              
                      TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
              
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
              
                            ),
                            labelText: 'Enter your email', labelStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(Icons.email, color: Colors.white,),
                          ),
                          onChanged: (value) {
                            bool isValid = EmailValidator.validate(value);
                            if (isValid) {
                              setState(() {
                                email = value;
                                error = '';
                              });
                            } else {
                              setState(() {
                                error = 'Email is invalid';
                              }
              
                              );
                            }
                          }
              
              
                      ),
              
                      SizedBox(height: 20.0),
              
                      TextField(
                        controller: _passwordController,
                        style: TextStyle(color: Colors.white),
                        obscureText: passview_off == true ? true : false,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          focusColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
              
                          ),
              
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
              
                          ),
                          labelText: 'Enter your password', labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Icons.lock, color: Colors.white,),
                          suffixIcon: passview_off ? IconButton(icon: Icon(Icons.visibility, color: Colors.white,), onPressed: () {setState(() {
                            passview_off = false;
                          });}) : IconButton(icon: Icon(Icons.visibility_off, color: Colors.white,), onPressed: () {setState(() {
                            passview_off = true;
                          });}),
              
                        ),
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },),
              
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: (){_showForgotPasswordDialog(context);},
                          child: Text('Forgot Password', style: TextStyle(color: Colors.white),),
              
              
              
              
                        ),),
              
                      SizedBox(height: 20.0),
                      Align(
                        alignment: Alignment.center,
                        child: Text(error, style: TextStyle(color: Colors.red),),
                      ),
                      SizedBox(height: 5.0),
              
              
                      ElevatedButton(
                          child: Text('Sign In', style: TextStyle(fontSize: 15.0),),
              
                          onPressed:()async {
                            bool isEmailExisting = await database_services.isEmailExisting(email);
                            print (isEmailExisting);
                            try {
                              if (email == '') {
                                setState(() {
                                  error = 'Email is required';
                                });
                              } else if (password == '') {
                                setState(() {
                                  error = 'Password is required';
                                });
                              }
                              else {
                                await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                              }
                            }
              
              
                            catch (e) {
                              if (isEmailExisting) {
                                setState(() {
                                  print('Email already exists');
                                  error = 'Password is incorrect';
                                });
                              } else {
                                setState(() {
                                  print(e.toString());
                                  error = 'User not found. Try registering!';
                                }
                                );
                              }
                            }
                          }
              
              
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center
                          ,children: [
                        Text('Don\'t have an account?',
                          style: TextStyle(color: Colors.white),)
                        ,
                        TextButton(
                          onPressed: (){
                            Navigator.pushNamed(context, '/signup');//TODO: Add the route to the sign up for Alumini page
                          },
                          child: Text('Sign Up', style: TextStyle(color: Colors.blue),),
                        )
                      ]
                      )
                    ],
                  ),
              
                ),
              
              ),
            )
        )
    );
  }
  void _showForgotPasswordDialog(BuildContext context) {
    TextEditingController _resetEmailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Forgot Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Enter your email to reset password."),
              const SizedBox(height: 16),
              TextField(
                controller: _resetEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
                onChanged: (value){
                  setState(() {
                    resetEmail = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Submit"),
              onPressed: () async{
                await FirebaseAuth.instance.sendPasswordResetEmail(email: resetEmail);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

