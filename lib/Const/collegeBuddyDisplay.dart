import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sbh24/Const/collegeBuddyProfileDisplay.dart';
import '../Firebase/Database_Services.dart';
import 'collegeDisplay.dart';

class CollegeBuddyDisplay extends StatefulWidget {
  final String college;
  final String country;
  final String subject;
  const CollegeBuddyDisplay({super.key, required this.college, required this.country, required this.subject});

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
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: widget.country == ""
              ? (widget.college == ""
              ? FirebaseFirestore.instance
              .collection("ALUMNI")
              .where("Subject", isEqualTo:widget.subject)

              .snapshots()
              : FirebaseFirestore.instance
              .collection("ALUMNI")
              .where("collegeName", isEqualTo: widget.college)
              .where("Subject", isEqualTo:widget.subject)


              .snapshots())
              : widget.college == ""
              ? FirebaseFirestore.instance
              .collection("ALUMNI")
              .where("Country", isEqualTo: widget.country)
              .where("Subject", isEqualTo:widget.subject)

              .snapshots()
              : FirebaseFirestore.instance
              .collection("ALUMNI")
              .where("Country", isEqualTo: widget.country)
              .where("collegeName", isEqualTo: widget.college)
              .where("Subject", isEqualTo:widget.subject)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> AlumniData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
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
                          AlumniData['displayName'],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: CollegeBuddyProfileDisplay(alumniName : AlumniData),
                              type: PageTransitionType.fade,
                              duration: const Duration(milliseconds: 500),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('No data found!!'));
          },
      ),
    );
  }
}
