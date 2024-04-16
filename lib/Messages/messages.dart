import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sbh24/Components/NavBar.dart';
import 'package:sbh24/Messages/messageBackend.dart';
import '../Components/NavBarAlumni.dart';
import '../Components/avatar.dart';
import '../Components/helpers.dart';
import '../Components/message_data.dart';
import 'messaging.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final messageDB msgdb = messageDB();

  //Lists
  List messengers = [];
  List latestMessages = [];
  List latestMessagesTimestamp = [];
  User user = FirebaseAuth.instance.currentUser!;
  bool isAlumni = false;

  @override
  void initState() {
    super.initState();
    call();
    checkIfAlumni();
  }
  Future<void> checkIfAlumni() async {
    var userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    setState(() {
      isAlumni = !userDoc.exists; // If the document doesn't exist, assume it's an alumni
    });
  }

  void call() async {
    List m = await msgdb.sendChattingUsers(FirebaseAuth.instance.currentUser?.uid);
    List m1 = await msgdb.sendLatestMessageList(FirebaseAuth.instance.currentUser?.uid);
    List m2 = await msgdb.sendLatestMessageTimestampList(FirebaseAuth.instance.currentUser?.uid);
    setState(() {
      messengers = m;
      latestMessages = m1;
      latestMessagesTimestamp = m2;
    });
    print(messengers);
  }

  String messageData(List l, int index){
    String data = " ";
    try{
      data = l[index];
    }catch(Exception){
      data = " ";
    }
    return data;
  }

  Future<String> fetchphotoURLFromUID(String name) async{
    String url = "https://t4.ftcdn.net/jpg/00/65/77/27/360_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg";
    return url;
  }

  Widget _delegate(BuildContext context, int index) {
    final currentDate = DateTime.now();
    print(messengers);
    return _MessageTitle(messageData: MessageData(
      senderName: messengers[index],
      message: messageData(latestMessages, index),
      messageDate: currentDate,
      dateMessage: messageData(latestMessagesTimestamp, index),
      // profilePicture: fetchphotoURLFromUID(messengers[index]).toString(),
      profilePicture: Helpers.randomPictureUrl()
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor("#1b2a61"),
        drawer: isAlumni? NavBarAlumni(): NavBar(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    _delegate,
                    childCount: messengers.length
                ),
              )
            ]
        )
    );
  }

}

class _MessageTitle extends StatelessWidget {
  _MessageTitle({
    Key? key,
    required this.messageData,
  }) : super(key: key);

  final MessageData messageData;
  final messageDB msgdb = messageDB();

  Future<String> fetchphotoURLFromUID(String name) async{
    String url = "https://t4.ftcdn.net/jpg/00/65/77/27/360_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg";
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchphotoURLFromUID(messageData.senderName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the future to complete, return a placeholder or loading indicator
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If an error occurred, display an error message
          return Text('Error: ${snapshot.error}');
        } else {
          // If the future completed successfully, display the image
          return InkWell(
            onTap: () async {
              msgdb.addReceptor(messageData.senderName, FirebaseAuth.instance.currentUser?.uid);
              Navigator.of(context).push(Messaging.route(messageData));
            },
            child: Container(
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.2,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Avatar.medium(url: snapshot.data!), // Use the snapshot data here
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            messageData.senderName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              letterSpacing: 0.2,
                              wordSpacing: 1.5,
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            child: Text(
                              messageData.message,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF9899A5),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children:[
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              messageData.dateMessage.toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xFF9899A5),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ]
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
