import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ummah/methods/firestore_methods.dart';
import 'package:ummah/models/user_model.dart';
import 'package:ummah/providers/user_proider.dart';
import '../utils/constant.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController comments = TextEditingController();

  @override
  dispose() {
    super.dispose();
    comments.dispose();
  }

  void getOutOfCommentField() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    String postId = args["postId"];
    final UserModel? user = Provider.of<UserProvider>(context).getUser;

    return GestureDetector(
      onTap: () {
        getOutOfCommentField();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text(
            "Comments",
            style: TextStyle(fontSize: 22),
          ),
        ),
        backgroundColor: kBackgroundClr,
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .doc(postId)
                .collection("comments")
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return CommentsCard(
                      snap: snapshot.data!.docs[index].data(),
                    );
                  });
            }),
        bottomNavigationBar: SafeArea(
          child: Container(
            color: Colors.blueGrey,
            height: 65,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Row(children: [
              const CircleAvatar(
                radius: 25,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: TextField(
                    controller: comments,
                    decoration: InputDecoration(
                      hintText: "Comment as ${user!.username}",
                      hintStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      suffixIcon: IconButton(
                        splashRadius: 50,
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await FirestoreMethods().uploadComment(
                              postId, comments.text, user.uid!, user.username!);
                          comments.clear();
                          getOutOfCommentField();
                        },
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}

class CommentsCard extends StatefulWidget {
  final snap;
  const CommentsCard({Key? key, this.snap}) : super(key: key);

  @override
  State<CommentsCard> createState() => _CommentsCardState();
}

class _CommentsCardState extends State<CommentsCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Container(
        // color: Colors.grey.withOpacity(0.3),
        // height: MediaQuery.of(context).size.height * 0.2,
        color: const Color.fromARGB(255, 58, 92, 89),

        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 30,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: widget.snap["username"],
                        style: const TextStyle(
                            backgroundColor: Color.fromARGB(255, 67, 106, 103),
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: " ${widget.snap["comment"]}",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70),
                      ),
                    ])),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.ideographic,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                DateFormat.yMMMd().format(
                                    widget.snap['dateOfPublished'].toDate()),
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                            const Text(" ~/~ "),
                            Text(
                                DateFormat.jm().format(
                                    widget.snap['dateOfPublished'].toDate()),
                                style: const TextStyle(
                                    textBaseline: TextBaseline.ideographic,
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ]),
                    )
                  ],
                ),
              ),
            ),
            const Icon(
              Icons.favorite_border,
              color: Colors.white,
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}
