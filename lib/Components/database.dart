/// The DatabaseService class provides methods for interacting with the Firebase Cloud Firestore
/// database, including setting and updating user data, submitting project and feedback data, and
/// retrieving leaderboard data.
// ignore_for_file: non_constant_identifier_names, unused_catch_clause,
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sbh24/Components/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid;
  final now = DateTime.now();

  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('Users');

  /// The function sets initial user data in a Firestore document with various fields such as name,
  /// email, class, registration number, points, streak, course, and arrays for tracking progress.
  ///
  /// Args:
  ///   Class (String): The class or grade of the user.
  ///   Name (String): The name of the user.
  ///   reg (String): Registration number of the user.
  ///   email (String): The email address of the user.
  ///   points (int): An integer representing the initial number of points for the user.
  ///   streak (int): The coding streak of the user, which refers to the number of consecutive days the
  /// user has completed coding challenges or activities.
  ///   course (String): The main course that the user is enrolled in.
  ///   length (int): The length parameter is an integer that specifies the length of the list to be
  /// created with List.filled() method. The list will be filled with 0 values and will have a fixed
  /// length specified by the length parameter.
  ///
  /// Returns:
  ///   a `Future<void>`.
  Future<void> setInitialUserData(
      String Address, String Name, String Phone, String email) async {

    return await brewCollection.doc(uid).set({
      'Uid': uid,
      'Name': Name,
      'Email': email,
      'Phone': Phone,
      'Address': Address,
    });
  }


}
