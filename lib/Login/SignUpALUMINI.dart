import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '/Firebase/Auth_Services.dart';
import '/help_func.dart';
import '/Firebase/Database_Services.dart';
import 'package:sbh24/Components/Navigators.dart';
import 'SignInALUMINI.dart';


class SignUpALUMINI extends StatefulWidget {


  @override
  State<SignUpALUMINI> createState() => _SignUpALUMINIState();
}

class _SignUpALUMINIState extends State<SignUpALUMINI> {
  @override
  final navigation nav = navigation();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _yearsOfExperienceController = TextEditingController();
  String displayName = '';
  bool isStudent = false;
  String email = '';
  String password = '';
  int yearsOfExperience = 0;
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
              
              
                            //Display Name
              
                            TextField(
                              controller: _displayNameController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
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
              
              
              
                            SizedBox(height: 20.0),
              
                            //Email
              
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
                                      email = value;
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
                              cursorColor: Colors.white,
                              obscureText: passview_off == true ? true : false,
                              decoration: InputDecoration(
                                focusColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
              
                                ),
              
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
              
                                ),
                                labelText: 'Enter your password',labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.lock,color: Colors.white,),
                                suffixIcon: passview_off ? IconButton(icon: Icon(Icons.visibility,color: Colors.white,), onPressed: () {setState(() {
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
              
                            SizedBox(height: 20.0),
                            TextField(
                              controller: _yearsOfExperienceController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
              
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
              
                                ),
                                labelText: 'Years of Experience', labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.work, color: Colors.white,),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  yearsOfExperience = int.parse(value);
                                });
                              },),
              
              
              
              
                            SizedBox(height: 50.0),
                            Align(
                              alignment: Alignment.center,
                              child: Text(error, style: TextStyle(color: Colors.red),),
                            ),
              
                            ElevatedButton(onPressed: ()async{
                              bool isEmailExisting = await Database_Services().isEmailExisting(email);
                              try{
                                if(email == ''){
                                  setState(() {
                                    error = 'Email is required';
                                  });
                                }
                                else if(isEmailExisting){
                                  setState(() {
                                    print('Email already exists');
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
                                  await Authentication_Services().Register(email, password, displayName, yearsOfExperience.toString(),isStudent,);
                                  Navigator.pushReplacementNamed(context, '/');
                                }
                              } catch (e) {
                                setState(() {
                                  error = 'User already exists';
                                });
              
                              }
              
                            },
                              child: Text('Sign Up', style: TextStyle(fontSize: 15.0),),
              
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
              
                              children: [
                                Text('Already have an account?', style: TextStyle(color: Colors.white),),
                                TextButton(
                                  onPressed: () {
                                    nav.navigateToPage(context, SignInALUMINI());   //TODO: Add the sign in Alumini page
                                  },
                                  child: Text('Sign In', style: TextStyle(color: Colors.blue),),
                                ),
              
                              ],
                            )
              
              
              
              
                          ]
                      )
                  )
              ),
            )
        ));}
}
