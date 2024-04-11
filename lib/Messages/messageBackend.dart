import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class messageDB {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(name, email, uid, token) {
    return _firestore.collection('messages')
        .doc(uid).set({
      'name': name,
      'email': email,
      'uid': uid,
      'token': token,
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  void addReceptor(name, uid) async {
    DateTime now = DateTime.now();
    String date = DateFormat('dd.MM.yyyy').format(now);

    print(date);
    DocumentReference<
        Map<String, dynamic>> documentSnapshot = await FirebaseFirestore
        .instance
        .collection('messages')
        .doc(uid);

    await documentSnapshot.collection(name).doc(date).set({
      'messagesSent': [],
      'messagesReceived': [],
      'messagesBoolean' : [],
    });
    print('Subcollection created successfully');
  }

  void sendMessage(uid, name, message) async {
    DateTime now = DateTime.now();
    String date = DateFormat('dd.MM.yyyy').format(now);
    //Current User Messages sent list updation
    DocumentReference<Map<String, dynamic>> documentRef = FirebaseFirestore
        .instance
        .collection('messages')
        .doc(uid)
        .collection(name)
        .doc(date);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef
        .get();

    if (documentSnapshot.exists) {
      // Document exists, update messagesSent list
      final b = documentSnapshot.data()?['messagesBoolean'];
      b.add(true);
      await documentRef.update({
        'messagesBoolean': b,
        'messagesSent': FieldValue.arrayUnion([message]),
      });
      print('Message added to messagesSent list');
    } else {
      // Document does not exist, create it with messagesSent list
      await documentRef.set({
        'messagesSent': [message],
        'messagesBoolean': ['true'],
      });
      print('Document created with messagesSent list');
    }
  }

  //Person to whom the message was send, that is, messages received list updation
  void receiveMessage(receiverName, senderName,message) async{
    String uid = await fetchUIDFromName(receiverName);
    DateTime now = DateTime.now();
    String date = DateFormat('dd.MM.yyyy').format(now);

    DocumentReference<Map<String, dynamic>> documentRef = FirebaseFirestore
        .instance
        .collection('messages')
        .doc(uid)
        .collection(senderName)
        .doc(date);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef.get();

    if (documentSnapshot.exists) {
      // Document exists, update Receiver
      final b = documentSnapshot.data()?['messagesBoolean'];
      b.add(false);
      await documentRef.update({
        'messagesReceived': FieldValue.arrayUnion([message]),
        'messagesBoolean': b,
      });
      print('Message added to messagesReceived list');
    } else {
      // Document does not exist, create it with messagesSent list
      await documentRef.set({
        'messagesReceived': [message],
        'messagesBoolean': ['false'],
      });
      print('Document created with messagesSent list');
    }
  }

  Future<String> fetchUIDFromName(name) async{
    String uid="";
    await _firestore.collection('messages')
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

  //Return MessagesSentList of Current User
  Future<List> messagesDateListReturn(uid, receiverName) async{
    final collectionReference = await FirebaseFirestore
        .instance
        .collection('messages')
        .doc(uid)
        .collection(receiverName);

    final querySnapshot = await collectionReference.get();
    final documentNames = querySnapshot.docs.map((doc) => doc.id).toList();
    return documentNames;

    // Map<String, dynamic>? data = documentSnapshot.data();
    // data?.forEach((key, value){
    //     print('$key: $value');
    // });
  }

  Future<List> messagesListReturn(uid, receiverName, date, value) async {
    List sent = [];
    DocumentReference<Map<String, dynamic>> documentRef = await FirebaseFirestore
        .instance
        .collection('messages')
        .doc(uid)
        .collection(receiverName)
        .doc(date);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef.get();

    if (documentSnapshot.exists && documentSnapshot.data()!.containsKey(value)) {
      // Return the value of the field
      sent = documentSnapshot.data()![value];
    }
    return sent;
  }

  // Future<List> messagesReceivedListReturn(uid, receiverName, date) async {
  //   List r = [];
  //   DocumentReference<
  //       Map<String, dynamic>> documentRef = await FirebaseFirestore
  //       .instance
  //       .collection('messages')
  //       .doc(uid)
  //       .collection(receiverName)
  //       .doc(date);
  //
  //   DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef
  //       .get();
  //
  //   if (documentSnapshot.exists &&
  //       documentSnapshot.data()!.containsKey('messagesReceived')) {
  //     // Return the value of the field
  //     r = documentSnapshot.data()!['messagesReceived'];
  //   }
  //   return r;
  // }
  //
  // Future<List> messagesBoolListReturn(uid, receiverName, date) async {
  //   List b = [];
  //   DocumentReference<
  //       Map<String, dynamic>> documentRef = await FirebaseFirestore
  //       .instance
  //       .collection('messages')
  //       .doc(uid)
  //       .collection(receiverName)
  //       .doc(date);
  //
  //   DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef
  //       .get();
  //
  //   if (documentSnapshot.exists &&
  //       documentSnapshot.data()!.containsKey('messagesBoolean')) {
  //     // Return the value of the field
  //     b = documentSnapshot.data()!['messagesBoolean'];
  //   }
  //
  //   return b;
  // }
}