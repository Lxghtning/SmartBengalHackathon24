import 'package:cloud_firestore/cloud_firestore.dart';

class Colleges{
  Future<List> collegesSend(String country, String course) async{
    List name= [];
    await FirebaseFirestore
        .instance
        .collection('Colleges')
        .doc('Colleges')
        .collection(course)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['country'] == country) {
          name.add(doc['name']);
        }
      }
    });
    return name;
  }
}