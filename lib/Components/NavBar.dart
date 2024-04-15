import 'package:sbh24/Forum/forum.dart';
import 'package:sbh24/Profile/Profile.dart';
import 'package:sbh24/Startup%20Screens/Grid.dart';
import 'package:sbh24/main.dart';
import 'package:sbh24/Components/Navigators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../Messages/messageBackend.dart';
import '../Messages/messages.dart';



class NavBar extends StatelessWidget {
  NavBar({super.key});
  //Navigation object
  final navigation nav = navigation();
  final messageDB msgdb = messageDB();

  @override
  Widget build(BuildContext context) {

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
                title: const Text("Connect with a professional"),
                onTap: () {
                    nav.navigateToPage(context, Grid_Country());
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
              // nav.navigateToPage(context, Forum())
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
                nav.navigateToPage(context, ProfilePage());
                  }),
          const Divider(
            indent: 0,
            endIndent: 0,
            thickness: 2,
          ),
          ListTile(
            title: Text('Log Out', style: listtiletextstyle,),
            leading: const Icon(Icons.exit_to_app),
            onTap: () async{
              await msgdb.updateState(FirebaseAuth.instance.currentUser?.uid, "Offline");
              navigatorKey.currentState!.popUntil((route) => route.isFirst);
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
