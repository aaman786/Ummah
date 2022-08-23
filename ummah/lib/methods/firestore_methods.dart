import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ummah/methods/storage_methods.dart';
import 'package:ummah/models/comment_model.dart';
import 'package:ummah/models/posts_model.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadComment(
    String postId,
    String comment,
    String uid,
    String username,
  ) async {
    try {
      if (comment.isNotEmpty) {
        String commentId = const Uuid().v1();
        CommentModel commentModel = CommentModel(
            username: username,
            comment: comment,
            commentId: commentId,
            uid: uid,
            dateOfPublished: DateTime.now());

        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set(commentModel.toMap());
        Fluttertoast.showToast(msg: "Successfully commented :)");
      } else {
        print("isEmpty");
      }
    } catch (e) {
      print(
          "The error in comment method in Firestore methods: " + e.toString());
    }
  }

  Future<void> likePost(String postId, List like, String uid) async {
    try {
      if (like.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          "like": FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection("posts").doc(postId).update({
          "like": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> uploadPost(
      String caption, Uint8List file, String uid, String username) async {
    String res = "some error occurred";

    try {
      String photoURL = await StorageMethods()
          .uploadImageToFirebaseStorage("posts", file, true);

      String postId = const Uuid().v1();
      PostsModel postsModel = PostsModel(
        caption: caption,
        uid: uid,
        username: username,
        postId: postId,
        dateOfPublished: DateTime.now(),
        postUrl: photoURL,
        like: [],
      );

      await _firestore.collection("posts").doc(postId).set(postsModel.toMap());
      Fluttertoast.showToast(msg: "Posts is uploaded :)");
      res = "Sucesssull";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
