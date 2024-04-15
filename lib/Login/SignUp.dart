import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:sbh24/Forum/forumBackend.dart';
import 'package:sbh24/Messages/messageBackend.dart';
import 'package:sbh24/Components/Navigators.dart';
import 'package:sbh24/Login/SignIn.dart';
import 'package:sbh24/Login/dummySignUP.dart';
import '/Firebase/Auth_Services.dart';
import '/help_func.dart';
import '/Firebase/Database_Services.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final messageDB msgdb = messageDB();
  final forumDatabase fdb = forumDatabase();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  String displayName = '';
  bool isStudent = true;
  String email = '';
  String password = '';
  String yearOfGrad = DateTime.now().year.toString();
  bool passview_off = true;
  String error = '';

  final List<dynamic>? years = help_func().yearOfGradDropDown();

  bool containsSpace(String value) {
    if(value.contains(' ')){
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        home: Scaffold(
            backgroundColor: const Color(0xff1B264F),



            body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(70.0),
                    child: Container(
                        child: Column(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              Image.asset("assets/const.png"),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                              const Text('Sign Up', style: TextStyle(fontSize: 35.0,fontWeight: FontWeight.w900,color: Colors.white, ),),
                              const SizedBox(height: 35.0),

                              //Display Name

                              TextField(
                                controller: _displayNameController,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),

                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),

                                  ),
                                  labelText: 'Enter your name', labelStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(Icons.person, color: Colors.white,),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    displayName = value;
                                  });
                                },),



                              const SizedBox(height: 20.0),

                              //Email

                              TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(color: Colors.white),
                                  cursorColor: Colors.white,
                                  decoration: const InputDecoration(
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
                                        email = value;
                                        error = 'Email is invalid';
                                      }
                                      );
                                    }
                                  }
                              ),

                              const SizedBox(height: 20.0),
                              TextField(
                                controller: _passwordController,
                                style: const TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                obscureText: passview_off == true ? true : false,
                                decoration: InputDecoration(
                                  focusColor: Colors.white,
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),

                                  ),

                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),

                                  ),
                                  labelText: 'Enter your password',labelStyle: const TextStyle(color: Colors.white),
                                  prefixIcon: const Icon(Icons.lock,color: Colors.white,),
                                  suffixIcon: passview_off ? IconButton(icon: const Icon(Icons.visibility_off,color: Colors.white,), onPressed: () {setState(() {
                                    passview_off = false;
                                  });}) : IconButton(icon: const Icon(Icons.visibility, color: Colors.white,), onPressed: () {setState(() {
                                    passview_off = true;
                                  });}),

                                ),
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },),

                              const SizedBox(height: 20.0),
                              DropdownButtonFormField(

                                decoration: const InputDecoration(
                                  focusColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),

                                  ),

                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  labelText: 'Year of Graduation',
                                  labelStyle: TextStyle(color: Colors.white),

                                  prefixIcon: Icon(Icons.school_sharp),
                                  prefixIconColor: Colors.white,

                                ),
                                icon: const Icon(Icons.arrow_drop_down_outlined, color: Colors.white,),
                                dropdownColor: const Color(0xff1B264F),
                                style: const TextStyle(color: Colors.white, fontSize: 17.0),
                                value : yearOfGrad,

                                items: years!.map((item){
                                  return DropdownMenuItem(


                                      value: item.toString(),
                                      child: Text(item.toString(), style: const TextStyle(color:Colors.white,
                                      ),
                                      )
                                  );



                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    yearOfGrad = value.toString();
                                  });
                                },
                              ),



                              const SizedBox(height: 50.0),
                              Align(
                                alignment: Alignment.center,
                                child: Text(error, style: const TextStyle(color: Colors.red),),
                              ),

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(fixedSize: const Size(400, 50)),
                                onPressed: ()async{
                                  bool isEmailExisting = await Database_Services().isEmailExisting(email);
                                  try{
                                    if(email == ''){
                                      setState(() {
                                        error = 'Email is required';
                                      });
                                    }
                                    else if(isEmailExisting){
                                      setState(() {
                                        error = 'Email already exists';
                                      });
                                    }
                                    else if(password == ''){
                                      setState(() {
                                        error = 'Password is required';
                                      });
                                    } else if(displayName == ''){
                                      setState(() {
                                        error = 'Display Name is required';
                                      });
                                    } else if(_passwordController.text.length < 6){
                                      setState(() {
                                        error = 'Password must be at least 6 characters';
                                      });
                                    } else if(containsSpace(password)){
                                      setState(() {
                                        error = 'Password cannot contain spaces';
                                      });
                                    } else {
                                      await Authentication_Services().RegisterStudent(email, password, displayName, yearOfGrad, isStudent);

                                      //Messages
                                      await msgdb.addUser(displayName,
                                          FirebaseAuth.instance.currentUser?.email,
                                          FirebaseAuth.instance.currentUser?.uid,
                                          "Online");

                                      //Forum
                                      await fdb.addUser(displayName,
                                          FirebaseAuth.instance.currentUser?.uid);

                                      Navigator.pushReplacementNamed(context, '/');
                                      navigation().navigateToPage(context, const DummySignUp());
                                    }
                                  } catch (e) {
                                    setState(() {
                                      error = 'User already exists';
                                    });

                                  }

                                },
                                child: const Text('Sign Up', style: TextStyle(fontSize: 15.0),),

                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  const Text('Already have an account?', style: TextStyle(color: Colors.white),),
                                  TextButton(
                                    onPressed: () {
                                      navigation().navigateToPage(context, const SignIn());
                                    },
                                    child: const Text('Sign In', style: TextStyle(color: Colors.blue),),
                                  ),
                                ],
                              )




                            ]
                        )
                    )
                ),
                )
    )
    );
  }
}
