import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sbh24/Const/collegeBuddyProfileDisplay.dart';


import '../Firebase/Database_Services.dart';
import 'collegeDisplay.dart';

class CollegeBuddyDisplay extends StatefulWidget {
  const CollegeBuddyDisplay({super.key});

  @override
  State<CollegeBuddyDisplay> createState() => _CollegeBuddyDisplayState();
}

class _CollegeBuddyDisplayState extends State<CollegeBuddyDisplay> {

  late Future<void> _initDataFuture;
  final db =  Database_Services();
  List alumniNames = [];

  @override
  void initState() {
    super.initState();
    _initDataFuture = initData();
  }

  Future<void> initData() async {
    List an = await db.sendALUMNINames();
    setState(() {
      alumniNames = an;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#1b2a61"),
      appBar: AppBar(
        leading: Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  child: CollegeDisplay(),
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 500),
                ),
              );
            },
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: alumniNames.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue, // You can customize the background color
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(
                  alumniNames[index],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                Navigator.push(
                context,
                PageTransition(
                child: CollegeBuddyProfileDisplay(alumniName : alumniNames[index]),
                type: PageTransitionType.fade,
                duration: const Duration(milliseconds: 500),
                ),
              );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
