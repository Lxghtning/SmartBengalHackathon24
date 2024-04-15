import 'package:cloud_firestore/cloud_firestore.dart';

class Colleges{
  Future<List<Map<String,dynamic>>> collegesSend(String country, String course) async{
    List<Map<String,dynamic>> college = [];
    await FirebaseFirestore
        .instance
        .collection('Colleges')
        .doc('Colleges')
        .collection(course)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['Country'] == country) {
          college.add(data);
        }
      }
    });
    return college;
  }
}