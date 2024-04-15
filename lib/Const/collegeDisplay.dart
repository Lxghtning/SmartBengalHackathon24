import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sbh24/Components/NavBar.dart';
import 'package:sbh24/Const/collegeBuddyDisplay.dart';
import 'package:sbh24/Startup Screens/Grid.dart';
import 'collegesFetch.dart';
class CollegeDisplay extends StatefulWidget {
  const CollegeDisplay({super.key});

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
    fetchData(); // Fetch data in initState
  }

  void fetchData()async {
    var fetchedColleges = await Colleges().collegesSend(Grid_Country().country[countryIndex], Grid_MainSubject().Subjects[subjectIndex]);
    setState(() {
      colleges = fetchedColleges;
      selected = List.generate(colleges.length, (_) => false);// Update colleges list and refresh UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#1b2a61"),
      drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          if (anyItemSelected)
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
              onPressed: () {
                // Navigate to the next screen here
                Navigator.push(
                  context,
                  PageTransition(
                    child: CollegeBuddyDisplay(),
                    type: PageTransitionType.fade,
                    duration: const Duration(milliseconds: 500),
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: colleges.isEmpty
                ? const Center(child: CircularProgressIndicator()) // Show loading indicator
                : ListView.builder(
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
                        colleges[index]['Name'][0],
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                    title: Text(
                      colleges[index]['Name'],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey, size: 18),
                        SizedBox(width: 4),
                        Text(
                          "Region: ${colleges[index]['City']}",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: selected[index]
                        ? Icon(Icons.check_circle, color: Colors.green) // Display tick icon if selected
                        : SizedBox.shrink(), // Otherwise, hide the trailing icon
                    onTap: () {
                      setState(() {
                        selected[index] = !selected[index]; // Toggle selection
                        anyItemSelected = selected.any((element) => element);
                      });
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
                    child: CollegeBuddyDisplay(),
                    type: PageTransitionType.fade,
                    duration: const Duration(milliseconds: 500),
                  ),
                );
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
      ),
    );
  }
}
