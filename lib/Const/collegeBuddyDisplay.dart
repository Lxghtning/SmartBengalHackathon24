import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sbh24/Components/NavBar.dart';

class CollegeBuddyDisplay extends StatefulWidget {
  const CollegeBuddyDisplay({super.key});

  @override
  State<CollegeBuddyDisplay> createState() => _CollegeBuddyDisplayState();
}

class _CollegeBuddyDisplayState extends State<CollegeBuddyDisplay> {
  List<Map<String, String>> colleges = [
    {"name": "Yash", "region": "Cambridge, MA"},
    {"name": "Jagrit", "region": "Cambridge, MA"},
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
      body: ListView.builder(
        itemCount: colleges.length,
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
                  // Handle onTap if needed
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
