// This file contains the authentication services for the app
import 'package:firebase_auth/firebase_auth.dart';
import '/FireBaseUser.dart';
import 'Database_Services.dart';
import '/Home/Home.dart';

class Authentication_Services {

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future Register(String email, String password,String displayName, String years,bool isStudent) async {
    //TODO: Add isStudent field to the database
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _auth.currentUser!.updateDisplayName(displayName);
      await _auth.currentUser!.updatePhotoURL('https://www.google.com/url?sa=i&url=https%3A%2F%2Fin.pinterest.com%2Fpin%2Faccount-add-admin-avatar-host-person-user-icon-download-on-iconfinder--876090933731408162%2F&psig=AOvVaw0X5O8GKOFqkAqB6FTeXt9l&ust=1712745872558000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCIirm-X5tIUDFQAAAAAdAAAAABAK');
      String uid = _auth.currentUser!.uid;
      await Database_Services().updateUserData_SignUp(uid, email, displayName, years, isStudent );
    } catch (e) {
      print(e.toString());
    }
  }
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e.toString());
    }
  }
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
  void resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }
  Future<User> returnUser() async {
     return await _auth.currentUser!;
  }

}