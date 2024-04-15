import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sbh24/Components/NavBar.dart';
import 'package:sbh24/Const/collegeBuddyDisplay.dart';

import '../Components/Navigators.dart';

class CollegeDisplay extends StatefulWidget {
  const CollegeDisplay({super.key});

  @override
  State<CollegeDisplay> createState() => _CollegeDisplayState();
}

class _CollegeDisplayState extends State<CollegeDisplay> {
  List<Map<String, String>> colleges = [
    {"name": "Harvard", "region": "Cambridge, MA"},
    {"name": "MIT", "region": "Cambridge, MA"},
    // Add more colleges as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#1b2a61"),
      drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: colleges.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        colleges[index]["name"]![0], // Displaying the first character of college name
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.blue, // You can customize the background color
                    ),
                    title: Text(
                      colleges[index]["name"]!,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey, size: 18),
                        SizedBox(width: 4),
                        Text(
                          "Region: ${colleges[index]["region"]}",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      navigation().navigateToPage(context, CollegeBuddyDisplay());
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                      child:  CollegeBuddyDisplay(),
                      type: PageTransitionType.fade,
                      duration: const Duration(milliseconds: 500),
                    ));
              },
              child: Text(
                "Continue without choosing a college",
                style: TextStyle(color: Colors.white ,fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button background color
                padding: EdgeInsets.all(16), // Button padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Button border radius
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
