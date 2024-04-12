import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import '../Components/NavBar.dart';
import '../Components/avatar.dart';
import '../Components/helpers.dart';
import '../Components/message_data.dart';
import '../Components/theme.dart';
import 'messageBackend.dart';
import 'dart:core';

class Messaging extends StatefulWidget {
  //helper function
  static Route route(MessageData data) => MaterialPageRoute(
    builder: (context) => Messaging(
      messageData: data,
    ),
  );


  const Messaging({
    Key? key,
    required this.messageData,
  }) : super(key: key);

  final MessageData messageData;



  @override
  State<Messaging> createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#1b2a61"),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 54,
        leading: Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: _AppBarTitle(
          messageData: widget.messageData,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.video_call,color: Colors.white,),
                onPressed: () {},
                ),
              )
            ),
          Padding(
            padding: const EdgeInsets.only(right:20),
            child: Center(
              child: IconButton(
                icon: const Icon(
                    Icons.call,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _MessageList(messageData: widget.messageData,)),
          _MessagingBar(messageData: widget.messageData)
        ]
      ),
    );
  }
}

class _AppBarTitle extends StatefulWidget {
  _AppBarTitle({
    Key? key,
    required this.messageData,
  }) : super(key: key);
  final MessageData messageData;

  @override
  State<_AppBarTitle> createState() => _AppBarTitleState();
}

class _AppBarTitleState extends State<_AppBarTitle> {
  final messageDB msgdb = messageDB();
  String state = "";
  @override
  void initState(){
    super.initState();
    call();

  }

  void call() async{
    String userState = await msgdb.userState(widget.messageData.senderName);
    setState(() {
        state=userState;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(state);
    return Row(
      children: [
        Avatar.small(
          url: widget.messageData.profilePicture,
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.messageData.senderName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16,color: Colors.white),
              ),
              const SizedBox(height: 2),
              Text(
               state,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}


class _MessagingBar extends StatefulWidget {


  _MessagingBar({
    Key? key,
    required this.messageData,
  }) : super(key: key);

  final MessageData messageData;

  @override
  State<_MessagingBar> createState() => _MessagingBarState();
}

class _MessagingBarState extends State<_MessagingBar> {
  final messageDB msgdb = messageDB();

  String message = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF585959),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 2,
                    ),
                  )
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: IconButton(
                    icon: Icon(Icons.camera_alt,color: Colors.white,),
                    onPressed: null,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left:16),
                  child: TextField(
                    onChanged: (value){
                      setState((){
                        message=value;
                      });
                    },
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:12, right:24),
                  child: IconButton(
                    icon: const Icon(Icons.send,color: Colors.white),
                    onPressed: () async{
                      DateTime now = DateTime.now();
                      String time = DateFormat('HH:mm a').format(now);

                      await msgdb.sendMessage(FirebaseAuth.instance.currentUser?.uid, widget.messageData.senderName, message, time);
                      await msgdb.receiveMessage(widget.messageData.senderName, 'Yash', message, time);
                      Navigator.push(
                          context,
                          PageTransition(
                            child:  Messaging(messageData: widget.messageData),
                            type: PageTransitionType.fade,
                            duration: const Duration(milliseconds: 1),
                          ));
                    },
                  ),
                ),
            ],
          ),
        ),
      )
    );
  }
}

class _MessageList extends StatefulWidget {
  _MessageList({Key? key, required this.messageData}) : super(key: key);

  final MessageData messageData;

  @override
  State<_MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<_MessageList> {

  late Future<void> _initDataFuture;

  @override
  void initState() {
    super.initState();
    _initDataFuture = initData();
  }

  Future<void> initData() async {
    await dateMessages();
    await messages();
    await boolMessages();
    await timestampMessages();
  }

  final messageDB msgdb = messageDB();

  List dates = [];
  List messagesList = [];
  List boolean = [];
  List timestamp = [];

  Future dateMessages() async{
    dates = await msgdb.messagesDateListReturn(FirebaseAuth.instance.currentUser?.uid, widget.messageData.senderName);
  }

  Future messages() async {

    for (int i = 0; i < dates.length; i++) {
      messagesList.add(dates[i]);
      List msent = await msgdb.messagesListReturn(
          FirebaseAuth.instance.currentUser?.uid, widget.messageData.senderName,
          dates[i], 'messagesList');
      for(int j=0;j < msent.length;j++){
        messagesList.add(msent[j]);
      }
    }
  }

  Future boolMessages() async {
    for (int i = 0; i < dates.length; i++) {
      List mb = await msgdb.messagesListReturn(
          FirebaseAuth.instance.currentUser?.uid, widget.messageData.senderName,
          dates[i],'messagesBoolean');
      for(int j=0;j < mb.length;j++){
        boolean.add(mb[j]);
      }
    }
  }

  Future timestampMessages() async {
    for (int i = 0; i < dates.length; i++) {
      List mt = await msgdb.messagesListReturn(
          FirebaseAuth.instance.currentUser?.uid, widget.messageData.senderName,
          dates[i],'messagesTimestamp');
      for(int j=0;j < mt.length;j++){
        timestamp.add(mt[j]);
      }
    }
  }

  bool isDateInFormat(String date) {
    // Define the regex pattern for the date format "day.month.year"
    RegExp regExp = RegExp(r'^\d{1,2}\.\d{1,2}\.\d{4}$');

    return regExp.hasMatch(date);
  }

  Widget buildWidget(int index) {
    DateTime now = DateTime.now();
    String date = DateFormat('dd.MM.yyyy').format(now);
    DateTime previousDay = now.subtract(Duration(days: 1));
    String previousDate = DateFormat('dd.MM.yyyy').format(previousDay);

    if(date==messagesList[index])
      return _DateLabel(label: "Today");
    else if(previousDate==messagesList[index])
      return _DateLabel(label: "Yesterday");
    return _DateLabel(label: messagesList[index]);
  }

  @override
  Widget build(BuildContext context) {
    print("m:");
    print(messagesList);
    int msgIndex = 0;
    return Scaffold(
      backgroundColor: HexColor("#1b2a61"),
      body: FutureBuilder<void>(
        future: _initDataFuture,
        builder: (context, snapshot) {
            return ListView.builder(
              itemCount: boolean.length,
              itemBuilder: (context, index) {
                if (isDateInFormat(messagesList[msgIndex])) {
                  Widget dateLabelWidget = buildWidget(msgIndex++);
                  if (boolean[index]) {
                    return Column(
                      children: [
                        dateLabelWidget,
                        _MessageSelfTile(message: messagesList[msgIndex++], messageDate: timestamp[index]),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        dateLabelWidget,
                        _MessageTile(message: messagesList[msgIndex++], messageDate: timestamp[index], messageData: widget.messageData),
                      ],
                    );
                  }
                }
                else if (boolean[index]) {
                  return _MessageSelfTile(message: messagesList[msgIndex++], messageDate: timestamp[index]);
                } else {
                  return _MessageTile(message: messagesList[msgIndex++], messageDate: timestamp[index], messageData: widget.messageData);
                }
              },
            );
          }
      ),
    );
  }
}

class _MessageSelfTile extends StatelessWidget {
  const _MessageSelfTile({
    Key? key,
    required this.message,
    required this.messageDate,
  }) : super(key: key);

  final String message;
  final String messageDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      messageDate,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Avatar.small(
            url: Helpers.randomPictureUrl(),
          ),
        ],
      ),
    );
  }
}


class _MessageTile extends StatelessWidget {
  const _MessageTile({
    Key? key,
    required this.message,
    required this.messageDate,
    required this.messageData,
  }) : super(key: key);

  final String message;
  final String messageDate;
  final MessageData messageData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar.small(
            url: messageData.profilePicture,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      messageDate,
                      style: const TextStyle(
                        color: Color(0xFF585959),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateLabel extends StatelessWidget {
  const _DateLabel({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textFaded,
              ),
            ),
          ),
        ),
      ),
    );
  }
}