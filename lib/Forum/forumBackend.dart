import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class forumDatabase {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(name, uid) async{
    return _firestore.collection('Forum')
        .doc(uid).set({
      'name': name,
      'uid': uid,
      'question': [],
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<List> getQuestions() async{
    List questions = [];
    await _firestore.collection('Forum')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        questions.add(doc['question']);
      }
    });

    return questions;
  }

  Future<List> getAuthors() async{
    List authors = [];
    await _firestore.collection('Forum')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        authors.add(doc['name']);
      }
    });
    return authors;
  }
  
  Future<void> postQuestion(String uid, String question) async{
    DocumentReference<Map<String, dynamic>> documentRef = await _firestore
        .collection('Forum')
        .doc(uid);

    // Update the document
    await documentRef.update({
      'question': FieldValue.arrayUnion([question]),
    });

  }

  Future<void> postReply(String authorName, String question, String reply, String replierUID) async{
    String authorUID = await fetchUIDFromName(authorName);
    String replierName = await fetchNameFromUID(replierUID);

    DocumentReference<Map<String, dynamic>> documentRef = await _firestore
        .collection('Forum')
        .doc(authorUID)
        .collection(question)
        .doc(replierUID);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef
        .get();

    if (documentSnapshot.exists) {
      await documentRef.update({
        'uid':replierUID,
        'name': replierName,
        'reply': reply
      });
    }else{
      await documentRef.set({
        'uid':replierUID,
        'name': replierName,
        'reply': reply
      });
    }
  }

  Future<String> fetchUIDFromName(name) async{
    String uid="";
    await _firestore.collection('Forum')
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

  Future<String> fetchNameFromUID(uid) async{
    String name="";
    DocumentReference<Map<String, dynamic>> documentRef = await _firestore
        .collection('Forum')
        .doc(uid);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef.get();

    name = documentSnapshot.data()!['name'];
    return name;
  }

  Future<List> getReplies(String author, String question) async{
      String authorUID = await fetchUIDFromName(author);
      List replies = [];


      DocumentReference<Map<String, dynamic>> documentRef = await _firestore
          .collection('Forum')
          .doc(authorUID);

      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef.get();
      await _firestore.collection('Forum')
          .doc(authorUID)
          .collection(question)
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          replies.add(doc['reply']);
        }
      });

      return replies;
  }

  Future<List> getRepliesAuthor(String author, String question) async{
    String authorUID = await fetchUIDFromName(author);
    List repliesAuthor = [];


    DocumentReference<Map<String, dynamic>> documentRef = await _firestore
        .collection('Forum')
        .doc(authorUID);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef.get();
    await _firestore.collection('Forum')
        .doc(authorUID)
        .collection(question)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        repliesAuthor.add(doc['name']);
      }
    });

    return repliesAuthor;
  }

}