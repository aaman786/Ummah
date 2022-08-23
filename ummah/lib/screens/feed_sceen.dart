import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ummah/methods/firestore_methods.dart';
import 'package:ummah/providers/user_proider.dart';

import '../models/user_model.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text('My App'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("posts").snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length >= 5
                  ? 3
                  : snapshot.data!.docs.length, // it will pick lesser docs
              itemBuilder: (context, index) {
                return PostCard(
                  snap: snapshot.data!.docs[index],
                );
              },
            );
          },
        ));
  }
}

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      // color: Colors.grey.withOpacity(0.3),
      color: const Color.fromARGB(255, 58, 92, 89),
      padding: const EdgeInsets.only(top: 3, bottom: 6, right: 5, left: 5),
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10)
                .copyWith(right: 0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      "https://i.pinimg.com/550x/94/fb/9e/94fb9e94f0db7e3d429df2d9c64527d2.jpg"),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap["username"],
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.amber),
                      )
                    ],
                  ),
                )),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                child: ListView(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shrinkWrap: true,
                                  children: [
                                    'Delete',
                                  ]
                                      .map((e) => InkWell(
                                            onTap: () {},
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: Text(e),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ));
                    },
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.amber,
                      size: 35,
                    )),
              ],
            ),
          ),

          //post pic
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(
              widget.snap["postUrl"],
              // "https://imgs.search.brave.com/pTqF1PlvHOK5tSag6AZ2dARi6lyPDQvAD-3eJIubcdY/rs:fit:592:225:1/g:ce/aHR0cHM6Ly90c2Uz/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC5j/MkJ3N2FSNi14d25V/dTE4aWZ0RVZ3SGFG/NyZwaWQ9QXBp",
              fit: BoxFit.cover,
            ),
          ),

          // Icons like,comment and save
          Row(children: [
            IconButton(
                onPressed: () async {
                  await FirestoreMethods().likePost(
                      widget.snap["postId"], widget.snap["like"], user!.uid!);
                },
                icon: widget.snap["like"].contains(user?.uid)
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 35,
                      )
                    : const Icon(
                        Icons.favorite_border,
                        color: Colors.amber,
                        size: 35,
                      )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'comment',
                      arguments: widget.snap);
                },
                icon: const Icon(
                  Icons.comment_outlined,
                  color: Colors.amber,
                  size: 35,
                )),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_border,
                      color: Colors.amber,
                      size: 35,
                    )),
              ),
            )
          ]),

          // number of likes, comments and description.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text(
                    "likes: ",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Text(
                    "${widget.snap["like"].length}",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white70),
                  ),
                ]),
                const Divider(
                  thickness: 2,
                  height: 6,
                  color: Colors.amber,
                  endIndent: 90,
                ),

                widget.snap["caption"] != ""
                    ? Container(
                        width: double.infinity,
                        // padding: const EdgeInsets.only(top: 0),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                style: const TextStyle(
                                    backgroundColor:
                                        Color.fromARGB(255, 61, 97, 94),
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400),
                                text: "${widget.snap["username"]}"),
                            TextSpan(
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70),
                                text: ":- ${widget.snap["caption"]}"
                                // " Hey, this is some discription present here."
                                )
                          ]),
                        ),
                      )
                    : Container(),
                // InkWell(
                //   onTap: () {},
                //   child: Container(
                //     padding: EdgeInsets.symmetric(vertical: 4),
                //     child: Text("View All Comments",
                //         style: TextStyle(
                //             color: Colors.grey.shade800,
                //             fontSize: 18,
                //             fontWeight: FontWeight.w500)),
                //   ),
                // ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                          DateFormat.yMMMd()
                              .format(widget.snap['dateOfPublished'].toDate()),
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                      const Text(" ~/~ "),
                      Text(
                          DateFormat.jm()
                              .format(widget.snap['dateOfPublished'].toDate()),
                          style: const TextStyle(
                              textBaseline: TextBaseline.ideographic,
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ]),
              ],
            ),
          )
        ],
      ),
    );
  }
}
