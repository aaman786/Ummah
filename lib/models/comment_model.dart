class CommentModel {
  final String? username;
  final String? comment;
  final String? uid;
  final String? commentId;
  final dateOfPublished;

  CommentModel({
    this.username,
    this.comment,
    this.dateOfPublished,
    this.commentId,
    this.uid,
  });

  // data from server
  // factory CommentModel.fromMap(map) {
  //   return CommentModel(
  //     username: map["username"],
  //     comment: map["comment"],
  //     dateOfPublished: map["dateOfPublished"],
  //     commentId: map["commentId"],
  //     uid: map["uid"],
  //   );
  // }

  // data to server
  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "comment": comment,
      "dateOfPublished": dateOfPublished,
      "commentId": commentId,
      "uid": uid,
    };
  }
}
