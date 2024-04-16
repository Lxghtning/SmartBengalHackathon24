import 'package:flutter/material.dart';
import 'package:sbh24/Components/NavBarAlumni.dart';

class HomeAlumni extends StatefulWidget {
  const HomeAlumni({super.key});

  @override
  State<HomeAlumni> createState() => _HomeAlumniState();
}

class _HomeAlumniState extends State<HomeAlumni> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer: NavBarAlumni(),
      appBar: AppBar(
        backgroundColor: Colors.blue,

      ),
    );
  }
}
