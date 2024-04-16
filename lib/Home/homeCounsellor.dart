import 'package:flutter/material.dart';
import 'package:sbh24/Components/NavBarAlumni.dart';

class HomeCounsellor extends StatefulWidget {
  const HomeCounsellor({super.key});

  @override
  State<HomeCounsellor> createState() => _HomeCounsellor();
}

class _HomeCounsellor extends State<HomeCounsellor> {
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
