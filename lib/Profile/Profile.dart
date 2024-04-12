import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '/Firebase/Database_Services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  List<String> colleges = ['MIT', 'Harvard', 'Yale University', 'Caltech', 'University of Toronto'];
  Map? userData;

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    userData = ModalRoute.of(context)!.settings.arguments as Map?;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar() as PreferredSizeWidget?,
      body: buildTop()
      );
  }

  Widget entireText() {
    return Container(
      // color: Colors.red,
      margin: EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          Text('${userData!['displayName']}',
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
          Text('${userData!['email']}',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.grey[600], ),
          ),
          SizedBox(height: 45.0),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 30, // Horizontal spacing between children
            runSpacing: 40, // Vertical spacing between lines
            children: [
                 Container(
                  height: 55,
                  width: 350,

                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                          spreadRadius: 0.0,
                          offset: Offset(0.0, 0.0),
                        )
                      ]
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child:TextButton.icon(
                          onPressed: (){},
                          icon: Icon(Icons.school, color: Colors.grey[700],),
                          label: Text('Year of Graduation :  ${userData!['yearOfGrad']}', style: TextStyle(fontSize: 20.0, color: Colors.grey[900], fontWeight: FontWeight.w500),),
                      )
                    ),
                  ),
                ),

              Container(
                height: 55,
                width: 350,
                // padding: EdgeInsets.all(),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                        spreadRadius: 0.0,
                        offset: Offset(0.0, 0.0),
                      )
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Align(
                    alignment: Alignment.center,

                    child: TextButton(
                      onPressed: (){
                        Colleges();
                      },
                      child: Text('College List', style: TextStyle(fontSize: 20.0, color: Colors.grey[900], fontWeight: FontWeight.w500),),
                    )
                ),
              ),

              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton.icon(onPressed: (){},
                  label: Text('Sign Out'),
                  icon: Icon(Icons.logout, color: Colors.red,),
                  ),
                ),
              )
              // Add more Container widgets for additional items
            ],
          )

        ],
      ),
    );
  }
  Widget Colleges(){
    return Scaffold(
      body: ListView.builder(
        itemCount: colleges.length,
        itemBuilder: (context, index){
          return ListTile(
            title: Text(colleges[index]),

          );
        },
      ),
    );

  }
  Widget buildTop(){
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 65.0,
          decoration: BoxDecoration(
            color: Color(0xff1B264F),
          ),
        ),
        Positioned(child: ProfilePicture() as Widget,
          top: -15,
          left: 0.0,
          right: 0.0,
        ),
        Positioned(child: entireText(),
          left: 0,
          right: 0,
          top: 110.0,
        )
      ],
    );
  }

  Widget? MyAppBar(){
   return AppBar(
     iconTheme: IconThemeData(color: Colors.white, size: 28.0),
     backgroundColor: Color(0xff1B264F),
     title: Text('Profile', style: TextStyle(color: Colors.white, fontSize: 25.0),),
     centerTitle: true,
     actions: [
       IconButton(onPressed: (){}, icon: Icon(Icons.edit, color: Colors.white, size: 28.0,)),
     ],

   );
  }

Widget? ProfilePicture(){
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 35.0, 0, 0),
        child: GestureDetector(
          onTap: () {
            setState(() {
            });
          },
          child: CircleAvatar(

            radius:50.0,
            child: ClipOval(
              child: Image(image: NetworkImage('${userData!['photoURL']}'),
                height: 100.0, width: 100.0, fit: BoxFit.cover,
              ),
            ),
          ),

        )
    );

}


}
