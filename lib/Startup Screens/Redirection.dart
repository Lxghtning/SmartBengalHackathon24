import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sbh24/Components/Navigators.dart';
import 'package:sbh24/Login/SignInALUMNI.dart';
import 'package:sbh24/Login/SignUp.dart';
import 'package:sbh24/Login/SignUpALUMNI.dart';

class Redirection extends StatelessWidget {

  final navigation nav = navigation();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        home: Scaffold(
        backgroundColor: Color(0xff1B264F),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 20.0),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                   Image.asset("assets/const.png"),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  const Text("Welcome To Const",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.13),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.white),
                        ),
                        child: TextButton.icon(
                          onPressed: () {
                            nav.navigateToPage(context, SignUp());
                          },
                          icon: Icon(Icons.person, color: Colors.white,),
                          label: Text('Sign Up as Student', style: TextStyle(color: Colors.white, fontSize: 20.0),),

                        ),
                      ),


                  SizedBox(height: 30.0),

                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.white),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        nav.navigateToPage(context, SignUpALUMNI());
                      },
                      icon: Icon(Icons.person, color: Colors.white,),
                      label: Text('Sign Up as College Buddy', style: TextStyle(color: Colors.white, fontSize: 20.0),),

                    ),
                  ),

                  SizedBox(height: 20.0),
                  ]
                  ),
            ],),
            ),
          ),
        )
    );

  }
}
