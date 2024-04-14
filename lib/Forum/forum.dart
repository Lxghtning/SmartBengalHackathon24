import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sbh24/Components/NavBar.dart';

import '../Components/Navigators.dart';
import 'forumBackend.dart';

class Forum extends StatefulWidget {
  const Forum({super.key});

  @override
  State<Forum> createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  late Future<void> _initDataFuture;

  final forumDatabase fdb = forumDatabase();
  bool _isExpanded = false;
  List forumQuestions = [];
  List forumAuthors = [];

  @override
  void initState() {
    super.initState();
    _initDataFuture = initData();
  }

  Future<void> initData() async {
    List f = await fdb.getQuestions();
    List f1 = await fdb.getAuthors();
    setState(() {
      forumQuestions = f;
      forumAuthors = f1;
    });
  }

  Widget displayForumWidget(String question, String author){
    return _DisplayForum(
        forumQuestion: question,
        forumAuthor: author
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),// Assuming NavBar.dart contains your navigation drawer widget
      backgroundColor: HexColor("#1b2a61"),
      body: FutureBuilder<void>(
        future: _initDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: forumQuestions.length,
              itemBuilder: (context, index) {
                //Variables
                String author = forumAuthors[index];
                List questions = forumQuestions[index];

                //Returning Column Widget
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < questions.length; i++)
                      displayForumWidget(questions[i], author),
                  ],
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController _textFieldController = TextEditingController();
              return AlertDialog(
                title: Text('Add Question'),
                content: TextField(
                  controller: _textFieldController,
                  decoration: InputDecoration(hintText: "Enter your question"),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('CANCEL'),
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('OK'),
                    onPressed: () async{
                      String question = _textFieldController.text;
                      if(!question.isEmpty){
                        await fdb.postQuestion(FirebaseAuth.instance.currentUser!.uid, question);
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            PageTransition(
                              child: Forum(),
                              type: PageTransitionType.fade,
                              duration: const Duration(milliseconds: 1),
                            ));
                      }
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(_isExpanded ? Icons.close : Icons.add),
      ),
    );
  }
}

class _DisplayForum extends StatelessWidget {
  const _DisplayForum({Key? key, required this.forumQuestion, required this.forumAuthor}) : super(key: key);
  final String forumQuestion;
  final String forumAuthor;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _DisplayForumReplies(question: forumQuestion, author: forumAuthor)
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(8),
        child: ListTile(
          title: Text(forumQuestion),
          subtitle: Text(forumAuthor),
          trailing: Icon(Icons.question_answer),
        ),
      ),
    );
  }
}

class _DisplayForumReplies extends StatefulWidget {
  const _DisplayForumReplies({Key? key, required this.question, required this.author}) : super(key: key);
  final String question;
  final String author;

  @override
  State<_DisplayForumReplies> createState() => _DisplayForumRepliesState();
}

class _DisplayForumRepliesState extends State<_DisplayForumReplies> {
  late Future<void> _initDataFuture;
  final TextEditingController _replyController = TextEditingController();
  final navigation nav = navigation();
  final forumDatabase fdb = forumDatabase();

  List replies = [];
  List repliesAuthor = [];

  @override
  void initState() {
    super.initState();
    _initDataFuture = initData();
  }

  Future<void> initData() async{
    await getReplies();
    await getRepliesAuthor();
  }

  Future<void> getReplies() async{
    List r = await fdb.getReplies(widget.author, widget.question);
    setState(() {
      replies = r;
    });
  }

  Future<void> getRepliesAuthor() async{
    List r = await fdb.getRepliesAuthor(widget.author, widget.question);
    setState(() {
      repliesAuthor = r;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#1b2a61"),
      appBar: AppBar(
        leading: Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
            onPressed: () {
              nav.navigateToPage(context, Forum());
            },
          ),
        ),
        title: Text(widget.question, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
        backgroundColor: HexColor("#1b2a61"),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Text("Author: ${widget.author}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<void>(
              future: _initDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: replies.length,
                    itemBuilder: (context, index) {
                      return _DisplayForumRepliesAnswers(forumQuestion: replies[index], forumAuthor: repliesAuthor[index]);
                    },
                  );
                };
              }
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showReplyDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showReplyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Reply'),
          content: TextField(
            controller: _replyController,
            decoration: InputDecoration(hintText: "Enter your reply"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async{
                String reply = _replyController.text;
                await fdb.postReply(widget.author, widget.question, reply, FirebaseAuth.instance.currentUser!.uid);
                _replyController.clear();
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => _DisplayForumReplies(question: widget.question, author: widget.author)
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class _DisplayForumRepliesAnswers extends StatelessWidget {
  const _DisplayForumRepliesAnswers({Key? key, required this.forumQuestion, required this.forumAuthor}) : super(key: key);
  final String forumQuestion;
  final String forumAuthor;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        margin: EdgeInsets.all(8),
        child: ListTile(
          title: Text(forumQuestion),
          subtitle: Text(forumAuthor),
        ),
      ),
    );
  }
}


