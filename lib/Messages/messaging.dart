import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import '../Components/NavBar.dart';
import '../Components/avatar.dart';
import '../Components/helpers.dart';
import '../Components/message_data.dart';
import '../Components/theme.dart';
import 'messageBackend.dart';


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

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({
    Key? key,
    required this.messageData,
  }) : super(key: key);

  final MessageData messageData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Avatar.small(
          url: messageData.profilePicture,
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
                messageData.senderName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16,color: Colors.white),
              ),
              const SizedBox(height: 2),
              const Text(
                'Online now',
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
                    onPressed: () {
                      msgdb.sendMessage('gF4LOJIn1oXAsNRTVpXsivSmf9j1', widget.messageData.senderName, message);
                      msgdb.receiveMessage(widget.messageData.senderName,'Garvit', message);
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

  @override
  void initState(){
    super.initState();
    initData();

  }

  Future<void> initData() async {
    await dateMessages();
    await sentMessages();
    await receivedMessages();
    await boolMessages();
    merge();

  }

  final messageDB msgdb = messageDB();

  List dates = [];
  List sent = [];
  List received = [];
  List boolean = [];
  List combine = [];

  Future dateMessages() async{
    dates = await msgdb.messagesDateListReturn(FirebaseAuth.instance.currentUser?.uid, widget.messageData.senderName);
  }

  Future sentMessages() async {

    for (int i = 0; i < dates.length; i++) {
      List msent = await msgdb.messagesListReturn(
          FirebaseAuth.instance.currentUser?.uid, widget.messageData.senderName,
          dates[i], 'messagesSent');
      for(int j=0;j < msent.length;j++){
        sent.add(msent[j]);
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

  Future receivedMessages() async {
    for (int i = 0; i < dates.length; i++) {
      List mr = await msgdb.messagesListReturn(
          FirebaseAuth.instance.currentUser?.uid, widget.messageData.senderName,
          dates[i],'messagesReceived');
      for(int j=0;j < mr.length;j++){
        received.add(mr[j]);
      }
    }
  }

  void merge(){

    for(int i=0;i< boolean.length; i++){
      if(boolean[i] == false) combine.add(received[i]);
      else combine.add(sent[i]);
    }
    print(sent);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: HexColor("#1b2a61"),
      body: ListView.builder(
        itemCount: boolean.length,
        itemBuilder: (context, index) {
          if(boolean[index] == true){
            return _MessageSelfTile(message: combine[index], messageDate: "dates[index]");
          }
          else{
            return _MessageTile(message: combine[index],messageDate: "dates[index]",messageData: widget.messageData);
          }
        },
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
                        color: Color(0xFF585959),
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