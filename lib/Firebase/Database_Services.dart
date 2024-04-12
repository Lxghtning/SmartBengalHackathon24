import 'package:cloud_firestore/cloud_firestore.dart';



 class Database_Services{

  final CollectionReference alumini = FirebaseFirestore.instance.collection('alumini');
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

//while signing up the user, this function will be called to add the user to the database
  Future updateUserData_SignUp(String uid, String email, String displayName, String years, isStudent) async {
    //TODO: Add isStudent field to the database
    if(isStudent)
      return updateUserData_Profile(uid, email, displayName, years, 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.shutterstock.com%2Fsearch%2Fadmin-user&psig=AOvVaw0X5O8GKOFqkAqB6FTeXt9l&ust=1712745872558000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCIirm-X5tIUDFQAAAAAdAAAAABAE');
    else
      return updateAluminiData_Profile(uid, email, displayName, years, 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.shutterstock.com%2Fsearch%2Fadmin-user&psig=AOvVaw0X5O8GKOFqkAqB6FTeXt9l&ust=1712745872558000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCIirm-X5tIUDFQAAAAAdAAAAABAE');
  }
  //while updating the user profile, this function will be called to update the user to the database for changing the photoURL of the user and generate an avatar of the user.
  Future updateUserData_Profile(String uid, String email, String displayName, String yearOfGrad, String photoURL) async {
    //TODO: Add isStudent field to the database
    return await users.doc(uid).set({
        'email': email,
        'displayName': displayName,
        'yearOfGrad': yearOfGrad,
        'photoURL': photoURL,
    });
  }
   Future updateAluminiData_Profile(String uid, String email, String displayName, String yearsOfExperience, String photoURL) async {
     //TODO: Add isStudent field to the database
     return await alumini.doc(uid).set({
       'email': email,
       'displayName': displayName,
       'yearsOfExperience': yearsOfExperience,
       'photoURL': photoURL,
     });
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