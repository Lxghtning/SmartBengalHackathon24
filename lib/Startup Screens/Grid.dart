import 'package:flutter/material.dart';
import 'package:sbh24/Components/Navigators.dart';
import 'package:sbh24/Const/collegeDisplay.dart';

import '../Components/NavBar.dart';

int countryIndex = -1;
int subjectIndex = -1;

giveCountry(){
  return countryIndex;
}
giveSubject(){
  return subjectIndex;
}
class Grid_Country extends StatelessWidget {
  List<String> country =['United States', 'Canada', 'United Kingdom', 'Australia', 'Germany', 'France', 'Netherlands', 'Singapore'];
  List<String> flags = ['assets/flags/united-states.png', 'assets/flags/canada.png', 'assets/flags/united-kingdom.png', 'assets/flags/australia.png', 'assets/flags/germany.png', 'assets/flags/france.png', 'assets/flags/netherlands.png', 'assets/flags/singapore.png'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      backgroundColor: Color(0xff1B264F),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff1B264F),
        title: Text('Select Country', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600,fontSize: 25.0,),),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: country.length,
          itemBuilder: (BuildContext context, int index) {
            return TextButton(
              onPressed: () {
                countryIndex = index;
                navigation().navigateToPage(context, Grid_MainSubject(country: country[countryIndex]));
              },
              child: Column(
                children: [
                  Image.asset(flags[index], height: 130, width: 130,),
                  Text(country[index], style: TextStyle(fontSize: 20, color: Colors.white),),

                ],
              ),
            );

          },
        ),
      ),
    );
  }
}

class Grid_MainSubject extends StatelessWidget {
  final String country;
  Grid_MainSubject({super.key, required this.country});

  List<String>  Subjects= ['Accounting and Finance', 'Business Studies', 'Chemistry', 'Civil Engineering', 'Computer Science','Dentistry','Economics',
    'Electrical Engineering', 'Law', 'Mathematics','Mechanical Engineering','Medicine','Physics'];
  List<String> Icons = ['assets/subjects/accounting.png', 'assets/subjects/business.png', 'assets/subjects/chemistry.png', 'assets/subjects/civil.png', 'assets/subjects/computer.png',
    'assets/subjects/dentistry.png', 'assets/subjects/economics.png', 'assets/subjects/electrical.png', 'assets/subjects/law.png',
    'assets/subjects/mathematics.png', 'assets/subjects/mechanical.png', 'assets/subjects/medicine.png', 'assets/subjects/physics.png'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff1B264F),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(0xff1B264F),
          title: Text('Select Main Subject', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600,fontSize: 25.0,),),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 35,
                mainAxisSpacing: 0,
                childAspectRatio: 1/1.5,
              ),
              itemCount: Subjects.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: GestureDetector(
                    onTap: () {
                      print(Subjects[index]);
                      subjectIndex = index;
                      navigation().navigateToPage(context, CollegeDisplay(subject: Subjects[index], country: country));
                    },
                    child: Column(
                      children: [
                        Image.asset(Icons[index], fit: BoxFit.cover),
                        const SizedBox(height: 5,),
                        Center(child: Text(Subjects[index], style: TextStyle(fontSize: 18, color: Colors.white),)),

                      ],
                    ),
                  ),
                );

              },
            ),
        ),
    );
  }
}