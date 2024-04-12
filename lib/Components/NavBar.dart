import 'package:sbh24/main.dart';
import 'package:sbh24/Components/Navigators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../Messages/messages.dart';



class NavBar extends StatelessWidget {
  NavBar({super.key});
  //Navigation object
  final navigation nav = navigation();

  @override
  Widget build(BuildContext context) {

    // ignore: unused_local_variable
    //this checks the internet connection everywhere in app and as soon as internet goes off,
    //as this widget is the common link to evry page in the app, pops to the main route, where no internet connection is handled by main.dart
    // ignore: unused_local_variable

    TextStyle listtiletextstyle = const TextStyle(color: Colors.black,);
    String? name = FirebaseAuth.instance.currentUser!.emailVerified
        ? FirebaseAuth.instance.currentUser!.displayName.toString():"Guest";
    String? email =  FirebaseAuth.instance.currentUser!.email.toString();
    return Drawer(
      backgroundColor: Colors.white.withOpacity(0.8),
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name, style:  const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
            accountEmail: Text(email, style:  const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Text(
                  name[0],
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontFamily: "Futura",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: HexColor("#d9eff5")
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text('Home', style: listtiletextstyle,),
            onTap: () => {}
          ),
          const Divider(
            indent: 0,
            endIndent: 0,
            thickness: 2,
          ),
          ExpansionTile(
            leading: const Icon(Icons.shop),
            title: const Text('Services'),
            children: [
              ListTile(
                title: const Text("College Counselling"),
                onTap: () {

                },
              ),
              ListTile(
                title: const Text('Country Counselling'),
                onTap: () {

                },
              ),
              ListTile(
                title: const Text('Career Counselling'),
                onTap: () {
                  // Handle category 3 tap

                },
              ),
              ListTile(
                title: const Text('College Specifiers'),
                onTap: () {

                },
              ),
              // Add more ListTile widgets for additional categories
            ],
          ),
          ListTile(
            leading: const Icon(Icons.question_answer),
            title: Text('Forum', style: listtiletextstyle,),
            onTap: () => {

            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: Text('Messages', style: listtiletextstyle,),
            onTap: () {
                nav.navigateToPage(context, Messages());
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text('Profile', style: listtiletextstyle,),
            onTap: () {

                  }),
          const Divider(
            indent: 0,
            endIndent: 0,
            thickness: 2,
          ),
          ListTile(
            title: Text('Log In', style: listtiletextstyle,),
            leading: const Icon(Icons.login),
            onTap: () {

            },
          ),
          ListTile(
            title: Text('Log Out', style: listtiletextstyle,),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {
              navigatorKey.currentState!.popUntil((route) => route.isFirst);
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
