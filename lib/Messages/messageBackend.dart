import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class  messageDB {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(name, email, uid, state) async{
    return _firestore.collection('messages')
        .doc(uid).set({
      'name': name,
      'email': email,
      'uid': uid,
      'state': state,
      'users': [],
      'latestMessages': [],
      'latestMessagesTimestamp': [],

    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  void addReceptor(name, uid) async {
    DateTime now = DateTime.now();
    String date = DateFormat('dd.MM.yyyy').format(now);
    String receiverName = await fetchNameFromUID(uid);
    String receiverUID = await fetchUIDFromName(name);

    //Receiver
    DocumentReference<
        Map<String, dynamic>> documentRefReceiver = await FirebaseFirestore
        .instance
        .collection('messages')
        .doc(receiverUID);

    DocumentSnapshot<Map<String, dynamic>> documentSnapReceiver = await documentRefReceiver
        .get();

    QuerySnapshot<Map<String, dynamic>> querySnapshotReceiver = await documentRefReceiver
        .collection(receiverName).get();

    Timestamp time = Timestamp.now();

    if (querySnapshotReceiver.docs.isEmpty) {
      await documentRefReceiver.collection(receiverName).doc(date).set({
        'messagesList': [],
        'messagesBoolean': [],
        'messagesTimestamp': [],
        'createdAt': time,
      });

      await documentRefReceiver.update({
        'users': FieldValue.arrayUnion([receiverName]),
      });

    }

    //Sender
    DocumentReference<
        Map<String, dynamic>> documentRef = await FirebaseFirestore
        .instance
        .collection('messages')
        .doc(uid);

    DocumentSnapshot<Map<String, dynamic>> documentSnap = await documentRef
        .get();

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await documentRef
        .collection(name).get();

    if (querySnapshot.docs.isEmpty) {
      await documentRef.collection(name).doc(date).set({
        'messagesList': [],
        'messagesBoolean': [],
        'messagesTimestamp': [],
        'createdAt': time,
      });

      await documentRef.update({
        'users': FieldValue.arrayUnion([name]),
      });

    }

  }
  Future<void> sendMessage(uid, name, message, time) async {
    String currentUserName = await fetchNameFromUID(uid);
    String receiverUID = await fetchUIDFromName(name);

    DateTime now = DateTime.now();
    String date = DateFormat('dd.MM.yyyy').format(now);
    Timestamp createdTime = Timestamp.now();

    //Current User Messages sent list update
    DocumentReference<Map<String, dynamic>> documentRef = FirebaseFirestore
        .instance
        .collection('messages')
        .doc(uid)
        .collection(name)
        .doc(date);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef
        .get();

    if (documentSnapshot.exists) {
      //boolean value update in array
      final b = documentSnapshot.data()?['messagesBoolean'];
      b.add(true);

      //Timestamp update in array
      final t = documentSnapshot.data()?['messagesTimestamp'];
      t.add(time);

      final m = documentSnapshot.data()?['messagesList'];
      m.add(message);
      await documentRef.update({
        'messagesBoolean': b,
        'messagesList': m,
        'messagesTimestamp': t,
      });
      print('Message added to messagesSent list');
    } else {
      // Document does not exist, create it with messagesSent list
      await documentRef.set({
        'messagesList': [message],
        'messagesBoolean': [true],
        'messagesTimestamp': [time],
        'createdAt' : createdTime,
      });
      print('Document created with messagesSent list');
    }

    //Update latest message
    await updateLatestMessage(currentUserName, receiverUID);
    print("updated");

  }

  //Person to whom the message was send, that is, messages received list update
  Future<void> receiveMessage(receiverName, senderUID,message,time) async{
    String uid = await fetchUIDFromName(receiverName);
    String senderName = await fetchNameFromUID(senderUID);

    DateTime now = DateTime.now();
    String date = DateFormat('dd.MM.yyyy').format(now);
    Timestamp createdTime = Timestamp.now();

    DocumentReference<Map<String, dynamic>> documentRef = FirebaseFirestore
        .instance
        .collection('messages')
        .doc(uid)
        .collection(senderName)
        .doc(date);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef.get();

    if (documentSnapshot.exists) {
      //Boolean value update
      final b = documentSnapshot.data()?['messagesBoolean'];
      b.add(false);

      //Timestamp update
      final t = documentSnapshot.data()?['messagesTimestamp'];
      t.add(time);

      final m = documentSnapshot.data()?['messagesList'];
      m.add(message);
      await documentRef.update({
        'messagesList': m,
        'messagesBoolean': b,
        'messagesTimestamp': t,
      });
      print('Message added to messagesReceived list');
    } else {
      // Document does not exist, create it with messagesSent list
      await documentRef.set({
        'messagesList': [message],
        'messagesBoolean': [false],
        'messagesTimestamp': [time],
        'createdAt' : createdTime,
      });
      print('Document created with messagesSent list');
    }

    await updateLatestMessage(receiverName, senderUID);
  }

  Future<String> fetchUIDFromName(name) async{
    String uid="";
    print(name);
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

  Future<String> fetchNameFromUID(uid) async{
    String name="";
    DocumentReference<Map<String, dynamic>> documentRef = await FirebaseFirestore
        .instance
        .collection('messages')
        .doc(uid);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef.get();

    name = documentSnapshot.data()!['name'];
    return name;
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

  Future<String> userState(name) async{
    String uid = await fetchUIDFromName(name);
    String state = "";
    print(uid);
    DocumentReference<Map<String, dynamic>> documentRef = await FirebaseFirestore
        .instance
        .collection('messages')
        .doc(uid);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef.get();

    state = documentSnapshot.data()!['state'];

    return state;
  }

  Future<String> fetchphotoURLFromUID(name) async{
    String photoURL="";
    String uid = await fetchUIDFromName(name);
    print(uid);
    DocumentReference<Map<String, dynamic>> documentRef = await FirebaseFirestore
        .instance
        .collection('ALUMNI')
        .doc(uid);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef.get();
    print(documentSnapshot.data());
    photoURL = documentSnapshot.data()!['photoURL'];
    return photoURL;
  }

  Future<void> updateState(uid, status) async{
    DocumentReference<Map<String, dynamic>> documentRef = await FirebaseFirestore
        .instance
        .collection('messages')
        .doc(uid);

    await documentRef.update({
      'state': status,
    });
  }

  Future<List> sendChattingUsers(uid) async{
    DocumentReference<Map<String, dynamic>> documentRef = await FirebaseFirestore
        .instance
        .collection('messages')
        .doc(uid);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef.get();

    List messengers = documentSnapshot.data()!['users'];

    return messengers;
  }


  Future<void> updateLatestMessage(name, uid) async{
    String currentUserUID = await fetchUIDFromName(name);
    List currentUserChattingUsers = await sendChattingUsers(uid);
    String receiverUserName = await fetchNameFromUID(uid);
    int index = currentUserChattingUsers.indexOf(name);

    QuerySnapshot<Map<String, dynamic>> querySnapshotReceiver = await FirebaseFirestore
        .instance
        .collection('messages')
        .doc(currentUserUID)
        .collection(receiverUserName)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    DocumentReference<Map<String, dynamic>> documentRef= await FirebaseFirestore
        .instance
        .collection('messages')
        .doc(currentUserUID);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef.get();

    if (querySnapshotReceiver.docs.isNotEmpty) {
      //Latest document data
      List messagesList = querySnapshotReceiver.docs[0].data()['messagesList'];
      List messagesTimestamp = querySnapshotReceiver.docs[0].data()['messagesTimestamp'];

      String latestMessage = messagesList[messagesList.length-1];
      String latestMessageTimestamp = messagesTimestamp[messagesTimestamp.length-1];

      List latestMessages = documentSnapshot.data()!['latestMessages'];
      List latestMessagesTimestamp = documentSnapshot.data()!['latestMessagesTimestamp'];
      try{
        latestMessages[index] = latestMessage;
        latestMessagesTimestamp[index] = latestMessageTimestamp;
      }
      catch(Exception){
        latestMessages.add(latestMessage);
        latestMessagesTimestamp.add(latestMessageTimestamp);
      }


      await documentRef.update({
        'latestMessages': latestMessages,
        'latestMessagesTimestamp': latestMessagesTimestamp,
      });
    } else {
      print('No documents found in collection');
    }
  }

  Future<List> sendLatestMessageList(uid) async{
    DocumentReference<Map<String, dynamic>> documentRef = await FirebaseFirestore
        .instance
        .collection('messages')
        .doc(uid);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef.get();

    List latest = documentSnapshot.data()!['latestMessages'];

    return latest;
  }


  Future<List> sendLatestMessageTimestampList(uid) async{
    DocumentReference<Map<String, dynamic>> documentRef = await FirebaseFirestore
        .instance
        .collection('messages')
        .doc(uid);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await documentRef.get();

    List latest = documentSnapshot.data()!['latestMessagesTimestamp'];

    return latest;
  }

}