import 'dart:async';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sbh24/Components/NavBar.dart';
import 'dart:io';
import 'package:sbh24/Components/Navigators.dart';
import 'package:sbh24/Firebase/Database_Services.dart';
import 'package:sbh24/Startup%20Screens/1.dart';
import 'package:sbh24/help_func.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Map userData = {};

  @override
  void initState(){
    super.initState();
    getUserData();
  }
  Future<void> getUserData() async {
    Map userData = await Database_Services().userData(user.uid);
    setState(() {
      this.userData = userData;
    });
  }
  User user = FirebaseAuth.instance.currentUser!;
  String yearOfGrad = '';
  bool anyChanges = false;
  List<dynamic>? years = help_func().yearOfGradDropDown();
  File? _image;
  final picker = ImagePicker();
  List<String> colleges = ['Mit', 'Harvard', 'Yale University', 'Caltech', 'University of Toronto', 'National University of Singapore'];
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      backgroundColor: Color(0xff1B264F),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff1B264F),
        title: Text('Profile', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: IconButton(onPressed: (){
              FirebaseAuth.instance.signOut();
              navigation().navigateToPage(context, InitialSetup());
            },
              icon: Icon(Icons.logout, color: Colors.red,),
            ),
          ),
        ],

      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Select Image'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.photo),
                              title: Text('Select from Gallery'),
                              onTap: () {
                                Navigator.pop(context);
                                getImageFromGallery();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.camera),
                              title: Text('Take a Photo'),
                              onTap: () {
                                Navigator.pop(context);
                                getImageFromCamera();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? Icon(Icons.person, size: 50) // Placeholder icon
                          : null,
                    ),
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: 20),
            // Other profile details...
            Text(
              user.displayName.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              user.email.toString(),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),

            ListTile(
              leading: Icon(Icons.school, color: Colors.white,),
              title: Text('Year Of Graduation: ${userData['yearOfGrad']} ', style: TextStyle(color: Colors.white),),
              trailing:  IconButton(
                icon:Icon(Icons.edit),
                onPressed: () {
                  showDialog(context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Edit Year of Graduation'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButtonFormField(
                                        decoration: InputDecoration(
                                  labelText: 'Year of Graduation',
                                  labelStyle: TextStyle(color: Colors.black),
                                  prefixIcon: Icon(Icons.school_sharp),
                                  prefixIconColor: Colors.black,
                                ),
                                icon: Icon(Icons.arrow_drop_down_outlined, color: Colors.black,),
                                dropdownColor: Color(0xffffffff),
                                style: TextStyle(color: Colors.black, fontSize: 17.0),
                                value: userData['yearOfGrad'],
                                items: years!.map((item) {
                                  return DropdownMenuItem(
                                    value: item.toString(),
                                    child: Text(item.toString(), style: TextStyle(color: Colors.black),),
                                  );
                                }).toList(),

                                onChanged: (value) {
                                  setState(() {
                                    yearOfGrad = value.toString();
                                    anyChanges = true;
                                  });
                                },

                              ),


                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Database_Services().updateUserData_Profile(user.uid, user.displayName!, user.email!, yearOfGrad,);
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                            child:  ProfilePage(),
                                            type: PageTransitionType.fade,
                                            duration: const Duration(milliseconds: 1),
                                          ));
                                    },
                                    child: Text('Save', style: TextStyle(color: Colors.white),),
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue),
                                    )
                                  ),

                                )
                            ],
                          ),
                        );
                      }
                  );
                  // Implement logout functionality
                },
                color: Colors.white,),
              onTap: () {
                // Navigate to personal information page
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            ListTile(
              leading: Icon(Icons.attach_money_rounded, color: Colors.white,),
              title: Text('Payment History', style: TextStyle(color: Colors.white),),
            ),




            // Align(
            //   alignment: Alignment.bottomRight,
            //   child: Padding(padding: EdgeInsets.only(bottom: 10, left: 10),
            //   child: anyChanges? ElevatedButton(
            //     onPressed:(){},
            //     child: Text('Save', style: TextStyle(color: Colors.white),),
            //     style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue),
            //   )
            //   ):null,
            // )
            // )
          ],
        ),
      ),


    );
  }
}
