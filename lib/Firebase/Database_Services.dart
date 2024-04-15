
import 'package:cloud_firestore/cloud_firestore.dart';



 class Database_Services{

  final CollectionReference ALUMNI = FirebaseFirestore.instance.collection('ALUMNI');
  final CollectionReference users = FirebaseFirestore.instance.collection('users');


  //while updating the user profile, this function will be called to update the user to the database for changing the photoURL of the user and generate an avatar of the user.
  Future updateUserData_Profile(String uid, String email, String displayName, String yearOfGrad) async {
    //TODO: Add isStudent field to the database
    return await users.doc(uid).set({
        'email': email,
        'displayName': displayName,
        'yearOfGrad': yearOfGrad,
        'photoURL': '',
        'uid': uid,
    });
  }
   Future updateALUMNIData_Profile(String collegeName, String uid, String email, String displayName, String yearsOfExperience) async {
     //TODO: Add isStudent field to the database
     return await ALUMNI.doc(uid).set({
       'email': email,
       'displayName': displayName,
       'yearsOfExperience': yearsOfExperience,
       'photoURL': '',
       'reviewAuthors':[],
       'reviewComments': [],
       'collegeName': collegeName,
       'uid': uid,
     });
   }

  Future<List> sendALUMNINames() async{
    List alumniNames = [];
    await ALUMNI
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        alumniNames.add(doc['displayName']);
        }
      });
    return alumniNames;
  }

  Future<String> sendAlumniYOE(String name) async{
    String uid = await fetchUIDFromName(name);
    DocumentReference<
        Map<String, dynamic>> documentRef = await FirebaseFirestore.instance.collection("ALUMNI")
        .doc(uid);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef
        .get();
    String yoe = documentSnapshot.data()!['yearsOfExperience'];
    return yoe;
  }

  Future<String> sendAlumniCollege(String name) async{
    String uid = await fetchUIDFromName(name);
    DocumentReference<
        Map<String, dynamic>> documentRef = await FirebaseFirestore.instance.collection("ALUMNI")
        .doc(uid);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef
        .get();
    String c = documentSnapshot.data()!['collegeName'];
    return c;
  }

   Future<List> sendAlumniReviews(String name) async{
     String uid = await fetchUIDFromName(name);
     DocumentReference<
         Map<String, dynamic>> documentRef = await FirebaseFirestore.instance.collection("ALUMNI")
         .doc(uid);

     DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef
         .get();
     List r= documentSnapshot.data()!['reviewComments'];
     return r;
   }

   Future<List> sendAlumniReviewsAuthor(String name) async{
     String uid = await fetchUIDFromName(name);
     DocumentReference<
         Map<String, dynamic>> documentRef = await FirebaseFirestore.instance.collection("ALUMNI")
         .doc(uid);

     DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef
         .get();
     List r= documentSnapshot.data()!['reviewAuthors'];
     return r;
   }

   Future<String> fetchUIDFromName(name) async{
     String uid="";
     await ALUMNI
         .get()
         .then((QuerySnapshot querySnapshot) {
       for (var doc in querySnapshot.docs) {
         if (doc['name'] == name) {
           uid = doc['uid'];
           break;
         }
       }
     });
     return uid;
   }

  Future <bool> isEmailExisting(String email) async {
    bool isEmailExisting = false;
    await users.get().then((QuerySnapshot querySnapshot){
      for(var doc in querySnapshot.docs){
        print(doc['email']);
        if(doc['email'] == email){
          print(email);
          print(true);
          isEmailExisting = true;
        }
      }

    });
  return isEmailExisting;
  }

  Future<Map> userData(String uid) async {
    Map<String, dynamic> userData = {};
    await users.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        userData = documentSnapshot.data() as Map<String, dynamic>;
        userData['uid'] = uid;
      } else {
        print('Document does not exist on the database');
      }
    });
    return userData;
  }
}