import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sbh24/Firebase/Database_Services.dart';

import '../Messages/messageBackend.dart';
import '../Messages/messages.dart';

class CollegeBuddyProfileDisplay extends StatefulWidget {
  const CollegeBuddyProfileDisplay({Key? key, required this.alumniName}) : super(key: key);
  final alumniName;

  @override
  State<CollegeBuddyProfileDisplay> createState() =>
      _CollegeBuddyProfileDisplayState();
}

class _CollegeBuddyProfileDisplayState
    extends State<CollegeBuddyProfileDisplay> {

  List reviewAuthors = [];
  List reviewComments = [];
  String collegeName = "";
  String yearsOfExperience = "";
  List studentsPhotoUrl = [];
  late Future<void> _initDataFuture;
  final db = Database_Services();
  final msgdb = messageDB();
  @override
  void initState() {
    super.initState();
    _initDataFuture = initData();
  }

  Future<void> initData() async {
    List ra = await db.sendAlumniReviewsAuthor(widget.alumniName);
    List rc = await db.sendAlumniReviews(widget.alumniName);
    String c = await db.sendAlumniCollege(widget.alumniName);
    String yoe = await db.sendAlumniYOE(widget.alumniName);
    List spu = [];
    for(int i=0; i<ra.length;i++){
      String s = await db.sendStudentPhotoUrl(widget.alumniName);
      spu.add(s);
    }

    setState(() {
      reviewAuthors = ra;
      reviewComments = rc;
      collegeName = c;
      yearsOfExperience = yoe;
      studentsPhotoUrl = spu;
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
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
            ),
            SizedBox(height: 20),
            Text(
              widget.alumniName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              collegeName,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Years of Experience',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  yearsOfExperience,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Rating:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  '4.5',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                        'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                        'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Centered Row with Elevated Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      msgdb.addReceptor(widget.alumniName, FirebaseAuth.instance.currentUser?.uid);
                      Navigator.push(
                          context,
                          PageTransition(
                            child:  Messages(),
                            type: PageTransitionType.fade,
                            duration: const Duration(milliseconds: 1),
                          ));
                    },
                    child: Text('Message', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20), // Adjust the spacing between buttons
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Add a review', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Text(
              'Reviews',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // Display review authors and comments
            ListView.builder(
              shrinkWrap: true,
              itemCount: reviewAuthors.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    title: Text(
                      reviewAuthors[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        reviewComments[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    leading: CircleAvatar(
                      child: ClipOval(
                        child: studentsPhotoUrl[index] != null && studentsPhotoUrl[index] != ""
                            ? Image(
                          image: NetworkImage(studentsPhotoUrl[index]),
                          height: 100.0,
                          width: 100.0,
                          fit: BoxFit.cover,
                        )
                            : Icon(
                          Icons.person, // Default person icon
                          size: 25, // Adjust size as needed
                        ),
                      ),
                    ),

                    onTap: () {

                    },
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
