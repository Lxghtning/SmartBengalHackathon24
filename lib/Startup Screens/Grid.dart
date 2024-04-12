 import 'package:flutter/material.dart';

class Grid_Country extends StatelessWidget {
 List<String> country =['USA', 'Canada', 'United Kingdom', 'Australia', 'Germany', 'France', 'Netherlands', 'Singapore'];
 List<String> flags = ['assets/flags/united-states.png', 'assets/flags/canada.png', 'assets/flags/united-kingdom.png', 'assets/flags/australia.png', 'assets/flags/germany.png', 'assets/flags/france.png', 'assets/flags/netherlands.png', 'assets/flags/singapore.png'];

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1B264F),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff1B264F),
        title: Text('Select Country', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600,fontSize: 20.0,),),
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
              onPressed: () {},
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
