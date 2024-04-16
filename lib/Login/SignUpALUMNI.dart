import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:sbh24/Forum/forumBackend.dart';
import 'package:sbh24/Login/VerifyEmail.dart';
import '../Messages/messageBackend.dart';
import 'package:sbh24/Home/Home.dart';
import 'package:sbh24/Login/apiVerify.dart';
import '/Firebase/Auth_Services.dart';
import '/help_func.dart';
import '/Firebase/Database_Services.dart';
import 'package:sbh24/Components/Navigators.dart';
import 'SignInALUMNI.dart';
import 'package:sbh24/Forum/forum.dart';

class SignUpALUMNI extends StatefulWidget {
  const SignUpALUMNI({super.key});



  @override
  State<SignUpALUMNI> createState() => _SignUpALUMNIState();
}


class _SignUpALUMNIState extends State<SignUpALUMNI> {

  final navigation nav = navigation();

  final messageDB msgdb = new messageDB();
  final forumDatabase fdb = forumDatabase();
  List<String>  Subjects= ['Accounting and Finance', 'Business Studies', 'Chemistry', 'Civil Engineering', 'Computer Science','Dentistry','Economics',
    'Electrical Engineering', 'Law', 'Mathematics','Mechanical Engineering','Medicine','Physics'];
  List<String> country =['United States', 'Canada', 'United Kingdom', 'Australia', 'Germany', 'France', 'Netherlands', 'Singapore'];
  String countryName = '';
  String subject = '';
  String about = '';
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _collegeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _yearsOfExperienceController = TextEditingController();
  String displayName = '';
  String collegeName = '';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        home: Scaffold(
            backgroundColor: const Color(0xff1B264F),



            body: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 65.0, horizontal: 50.0),
                  child: Container(
                      child: Column(
                          children: [
                            const Image(image: AssetImage('assets/const_logo.png'), height: 125.0, width: 125.0,),
                            const Text('Sign Up', style: TextStyle(fontSize: 35.0,fontWeight: FontWeight.w900,color: Colors.white, ),),
                            const SizedBox(height: 10.0),
                            const Text('College Buddy', style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w900,color: Colors.white, ),),
                            const SizedBox(height: 20.0),
              
              
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
                            DropdownButtonFormField(

                              decoration: const InputDecoration(
                                focusColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),

                                ),

                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                labelText: 'Select Country',
                                labelStyle: TextStyle(color: Colors.white),

                                prefixIcon: Icon(Icons.school_sharp),
                                prefixIconColor: Colors.white,

                              ),
                              icon: const Icon(Icons.arrow_drop_down_outlined, color: Colors.white,),
                              dropdownColor: const Color(0xff1B264F),
                              style: const TextStyle(color: Colors.white, fontSize: 17.0),
                              value : country[0],

                              items: country.map((item){
                                return DropdownMenuItem(


                                    value: item.toString(),
                                    child: Text(item.toString(), style: const TextStyle(color:Colors.white,
                                    ),
                                    )
                                );



                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  countryName = value.toString();
                                });
                              },
                            ),



                            const SizedBox(height: 20.0),
                            TextField(
                              controller: _collegeController,
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
                                labelText: 'Enter your college name', labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.person, color: Colors.white,),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  collegeName = value;
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
                                labelText: 'Select Subject',
                                labelStyle: TextStyle(color: Colors.white),

                                prefixIcon: Icon(Icons.school_sharp),
                                prefixIconColor: Colors.white,

                              ),
                              icon: const Icon(Icons.arrow_drop_down_outlined, color: Colors.white,),
                              dropdownColor: const Color(0xff1B264F),
                              style: const TextStyle(color: Colors.white, fontSize: 17.0),
                              value :Subjects[0],

                              items: Subjects.map((item){
                                return DropdownMenuItem(


                                    value: item.toString(),
                                    child: Text(item.toString(), style: const TextStyle(color:Colors.white,
                                    ),
                                    )
                                );



                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  subject = value.toString();
                                });
                              },
                            ),

                            //Email
                            const SizedBox(height: 20.0),
              
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
                                  labelText: 'Enter your college email', labelStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(Icons.email, color: Colors.white,),
                                ),
              
                                onChanged: (value) async{
                                  bool isOfficial = await verify(value, collegeName);
                                  if (isOfficial){
                                    setState(() {
                                      email = value;
                                      error = '';
                                    });
                                  } else {
                                    setState(() {
                                      // print('in else');
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
                            TextField(
                              controller: _yearsOfExperienceController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(
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

                            const SizedBox(height: 20.0),
                            TextField(
                              controller: _aboutController,
                              keyboardType: TextInputType.text,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),

                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),

                                ),
                                labelText: 'About Yourself', labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.person, color: Colors.white,),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  about = value;
                                });
                              },
                            ),

                            const SizedBox(height: 50.0),
                            Align(
                              alignment: Alignment.center,
                              child: Text(error, style: const TextStyle(color: Colors.red),),
                            ),
                            SizedBox(height: 5),
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
                                } else if(error == ''){

                                  await Authentication_Services().RegisterAlumni(collegeName, email, password, displayName, yearsOfExperience.toString(), countryName, subject, about);

                                  //Messages
                                  await msgdb.addUser(displayName,
                                      FirebaseAuth.instance.currentUser?.email,
                                      FirebaseAuth.instance.currentUser?.uid,
                                      "Online");

                                  //Forum
                                  await fdb.addUser(displayName,
                                      FirebaseAuth.instance.currentUser?.uid);
                                  navigation().navigateToPage(context, VerifyEmailPage());

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
                                    nav.navigateToPage(context, const SignInALUMNI());   //TODO: Add the sign in ALUMNI page
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
        ));}
}

