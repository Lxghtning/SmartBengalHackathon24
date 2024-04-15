import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CollegeBuddyProfileDisplay extends StatefulWidget {
  const CollegeBuddyProfileDisplay({super.key});

  @override
  State<CollegeBuddyProfileDisplay> createState() =>
      _CollegeBuddyProfileDisplayState();
}

class _CollegeBuddyProfileDisplayState
    extends State<CollegeBuddyProfileDisplay> {
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
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Harvard University',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
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

                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                        'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                        'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Message'),
              style: ElevatedButton.styleFrom(
                backgroundColor: HexColor('#1b2a61'),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
