import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sbhconst/Components/NavBar.dart';
import 'package:sbhconst/Messages/messageBackend.dart';
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

  @override
  void initState() {
    super.initState();
    call();
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

  Widget _delegate(BuildContext context, int index) {
    print("messengers $latestMessages");
    final currentDate = DateTime.now();
    return _MessageTitle(messageData: MessageData(
      senderName: messengers[index],
      message: latestMessages.isEmpty ? " " : latestMessages[index],
      messageDate: currentDate,
      dateMessage: latestMessagesTimestamp.isEmpty ? " " : latestMessagesTimestamp[index],
      profilePicture: Helpers.randomPictureUrl(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor("#1b2a61"),
        drawer: NavBar(),
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
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
                 child: Avatar.medium(url:messageData.profilePicture),
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
                      height:20,
                      child:Text(
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
                    const SizedBox(
                      height: 8
                    ),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3B76F6),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          "1",
                          style: TextStyle(
                            color: Color(0xFFF5F5F5),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ]
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}