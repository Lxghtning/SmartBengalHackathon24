import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';



 class Database_Services{

  final CollectionReference ALUMNI = FirebaseFirestore.instance.collection('ALUMNI');
  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  final CollectionReference Counsellors = FirebaseFirestore.instance.collection('Counsellors');

  //while updating the user profile, this function will be called to update the user to the database for changing the photoURL of the user and generate an avatar of the user.
  Future updateUserData_Profile(String uid, String email, String displayName, String yearOfGrad) async {
    //TODO: Add isStudent field to the database
    return await users.doc(uid).set({
        'email': email,
        'displayName': displayName,
        'yearOfGrad': yearOfGrad,
        'photoURL': 'https://t4.ftcdn.net/jpg/00/65/77/27/360_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg',
        'uid': uid,
    });
  }
   Future updateALUMNIData_Profile(String collegeName, String uid, String email, String displayName, String yearsOfExperience, String country, String subject, String about) async {
     //TODO: Add isStudent field to the database
     return await ALUMNI.doc(uid).set({
       'email': email,
       'displayName': displayName,
       'yearsOfExperience': yearsOfExperience,
       'photoURL': 'https://t4.ftcdn.net/jpg/00/65/77/27/360_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg',
       'reviewAuthors':[],
       'reviewComments': [],
       'collegeName': collegeName,
       'uid': uid,
       'rating': [],
       'Country': country,
        'Subject': subject,
        'About': about
     });
   }
  Future updateCounsellorData_Profile(String countryName, String uid, String email, String displayName, String yearsOfExperience) async {
    //TODO: Add isStudent field to the database
    return await Counsellors.doc(uid).set({
      'email': email,
      'displayName': displayName,
      'yearsOfExperience': yearsOfExperience,
      'photoURL': 'https://t4.ftcdn.net/jpg/00/65/77/27/360_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg',
      'reviewAuthors':[],
      'reviewComments': [],
      'countryName': countryName,
      'uid': uid,
      'rating': [],
    });
  }

  Future<void> updateMoreDetails_ALUMNI(String uid, String country, String subject,String about) async {
    await ALUMNI.doc(uid).update({
      'Country': country,
      'Subject': subject,
      'About': about
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

  Future<void> postReview(String name, String uid, String review, double rating) async{
    String uidALUMNI = await fetchUIDFromName(name);
    String author = await fetchNameFromUID(uid);

    DocumentReference<
        Map<String, dynamic>> documentRef = await FirebaseFirestore.instance.collection("ALUMNI")
        .doc(uidALUMNI);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef
        .get();

    if(documentSnapshot.exists) {
      final ratingList = documentSnapshot.data()!['rating'];
      ratingList.add(rating);
      final reviewAuthor = documentSnapshot.data()!['reviewAuthors'];
      final reviewComments = documentSnapshot.data()!['reviewComments'];
      reviewComments.add(review);

      bool given = false;
      for (int index = 0; index < reviewAuthor.length; index++) {
        if (reviewAuthor[index] == author) given = true;
      }

      if (!given) {
        await documentRef.update({
          'reviewComments': reviewComments,
          'reviewAuthors': FieldValue.arrayUnion([author]),
          'rating': ratingList,
        });
      }
    }else{
      await documentRef.set({
        'reviewComments': [review],
        'reviewAuthors': [author],
        'rating': [rating],
      });
    }
  }

  Future<List> sendAlumniRating(String name) async{
    String uid = await fetchUIDFromName(name);
    List r=[];
    DocumentReference<
        Map<String, dynamic>> documentRef = await FirebaseFirestore.instance.collection("ALUMNI")
        .doc(uid);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef
        .get();
    r= documentSnapshot.data()!['rating'];
    return r;
  }

   Future<List> sendAlumniReviews(String name) async{
     String uid = await fetchUIDFromName(name);
     List r=[];
     DocumentReference<
         Map<String, dynamic>> documentRef = await FirebaseFirestore.instance.collection("ALUMNI")
         .doc(uid);

     DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef
         .get();
     r= documentSnapshot.data()!['reviewComments'];
     return r;
   }

   Future<List> sendAlumniReviewsAuthor(String name) async{
     String uid = await fetchUIDFromName(name);

     List r = [];
     DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance.collection("ALUMNI").doc(uid).get();

     r= documentSnapshot.data()!['reviewAuthors'];

     return r;
   }

  Future<String> sendStudentPhotoUrl(String name) async{
    String uid = await fetchUIDFromNameStudent(name);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance.collection("users").doc(uid).get();
    print(documentSnapshot.data());
    String r= documentSnapshot.data()!['photoURL'];

    return r;
  }

  Future<String> sendPhotoUrl(String name) async{
    String uid = await fetchUIDFromName(name);
    DocumentReference<
        Map<String, dynamic>> documentRef = await FirebaseFirestore.instance.collection("ALUMNI")
        .doc(uid);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef
        .get();

    String r= documentSnapshot.data()!['photoURL'];
    print(r);
    return r;
  }

   Future<String> fetchUIDFromName(name) async{
     String uid="";
     await ALUMNI
         .get()
         .then((QuerySnapshot querySnapshot) {
       for (var doc in querySnapshot.docs) {
         if (doc['displayName'] == name) {
           uid = doc['uid'];
           break;
         }
       }
     });
     return uid;
   }

  Future<String> fetchNameFromUID(uid) async{
    String name="";
    DocumentReference<Map<String, dynamic>> documentRef = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(uid);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef.get();

    name = documentSnapshot.data()!['displayName'];
    return name;

  }

  Future<String> fetchUIDFromNameStudent(name) async{
    String uid="";
    await users
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['displayName'] == name) {
          uid = doc['uid'];
          break;
        }
      }
    });
    return uid;
  }

  Future<bool> isEmailExisting(String email) async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('users') // Assuming 'users' is your collection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      var result1 = await FirebaseFirestore.instance
          .collection('ALUMNI') // Assuming 'users' is your collection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      var result2 = await FirebaseFirestore.instance
          .collection('Counsellors') // Assuming 'users' is your collection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (result.docs.isEmpty && result1.docs.isEmpty && result2.docs.isEmpty){
        // No document found with the specified email
        return false;
      }

      // Check if the document actually has the 'email' field
      if ((result.docs.first.exists &&
          result.docs.first.data().containsKey('email')) || ( (result1.docs.first.exists && result1.docs.first.data().containsKey('email')) ) || ( result2.docs.first.exists &&
          result2.docs.first.data().containsKey('email') ) ) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
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
  Future<Map> alumniData(String uid) async {
    Map<String, dynamic> alumniData = {};
    await ALUMNI.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        alumniData = documentSnapshot.data() as Map<String, dynamic>;
        alumniData['uid'] = uid;
      } else {
        print('Document does not exist on the database');
      }
    });
    return alumniData;
  }

  Future<void> uploadImage(File file, String uid) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child('profile_images/$uid');
      UploadTask uploadTask = ref.putFile(file);
      await uploadTask.whenComplete(() => null);
      String downloadUrl = await ref.getDownloadURL();
      await users.doc(uid).update({'photoURL': downloadUrl});
    } catch (e) {
      print(e.toString());
    }
  }
}