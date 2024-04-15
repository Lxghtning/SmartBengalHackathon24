import 'package:sbh24/Const/colleges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
  void uploadData() {
    Colleges college = Colleges();
    var list = college.physics;
    for (var col in list) {
      FirebaseFirestore.instance
          .collection('Colleges')
          .doc('Colleges')
          .collection('Physics')
          .doc(col['Name'])
          .set(col);
    }
  }