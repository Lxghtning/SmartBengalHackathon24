import 'package:flutter/material.dart';
class Grid_Country extends StatelessWidget {
 List<String> country =['United States of America', 'Canada', 'United Kingdom', 'Australia', 'Germany', 'France', 'Netherlands', 'Singapore'];
 List<String> flags = ['assets/flags/united-states.png', 'assets/flags/canada.png', 'assets/flags/united-kingdom.png', 'assets/flags/australia.png', 'assets/flags/germany.png', 'assets/flags/france.png', 'assets/flags/netherlands.png', 'assets/flags/singapore.png'];

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Country', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600,fontSize: 20.0,),),
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: country.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Column(
              children: [
                Image.asset(flags[index], height: 100, width: 100,),
                Text(country[index], style: TextStyle(fontSize: 20),),
              ],
            ),
          );
        },
      ),
    );
  }
}
