import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sbh24/Components/NavBar.dart';
import 'package:sbh24/Const/collegeBuddyDisplay.dart';
import 'package:sbh24/Startup Screens/Grid.dart';
import '../Components/Navigators.dart';
import 'collegesFetch.dart';

class CollegeDisplay extends StatefulWidget {
  final String subject;
  final String country;

  const CollegeDisplay({super.key, required this.subject, required this.country});
  

  @override
  State<CollegeDisplay> createState() => _CollegeDisplayState();
}

class _CollegeDisplayState extends State<CollegeDisplay> {
  List<Map<String,dynamic>> colleges = [];
  List<bool> selected = []; // Maintain a list to track selected items
  bool anyItemSelected = false;
  int countryIndex = giveCountry();
  int subjectIndex = giveSubject();
  String err = '';
  
  @override
  void initState() {
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: HexColor("#1b2a61"),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        // actions: [
        //   if (anyItemSelected)
        //     IconButton(
        //       icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
        //       onPressed: () {
        //         // Navigate to the next screen here
        //         Navigator.push(
        //           context,
        //           PageTransition(
        //             child: CollegeBuddyDisplay(),
        //             type: PageTransitionType.fade,
        //             duration: const Duration(milliseconds: 500),
        //           ),
        //         );
        //       },
        //     ),
        // ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.country == "" ?FirebaseFirestore.instance.collection("Colleges").doc(
            "Colleges").collection(widget.subject).orderBy('Rank')

            .snapshots():FirebaseFirestore.instance.collection("Colleges").doc(
            "Colleges").collection(widget.subject).where("Country", isEqualTo: widget.country).orderBy('Rank')

            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index)
                      {
                        Map<String, dynamic> collegeData =
                        snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.all(2),
                          child: Card(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  collegeData['Name'],
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.blue,
                              ),
                              title: Text(
                                collegeData['Name'],
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Row(
                                children: [
                                  Icon(Icons.location_on, color: Colors.grey, size: 18),
                                  SizedBox(width: 4),
                                  Text(
                                    "Region: ${collegeData['City']}",
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                              onTap: () {
                                navigation().navigateToPage(context, CollegeBuddyDisplay(college: collegeData['Name'], subject: widget.subject, country: widget.country,));
                              },
                            ),
                          ),
                        );
                      }
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      navigation().navigateToPage(context, CollegeBuddyDisplay(college: "", subject: widget.subject, country: widget.country,));
                    },
                    child: Text(
                      "Continue without choosing a college",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Center(
              child: Text(
                  'No colleges found for ${widget.country
                      .toUpperCase()}'));

          },
        ),
      );
  }
}
