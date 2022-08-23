class PostsModel {
  final String? username;
  final String? caption;
  final dateOfPublished;
  final String? postId;
  final String? postUrl;
  final String? uid;
  final List? like;

  PostsModel(
      {this.username,
      this.caption,
      this.dateOfPublished,
      this.postId,
      this.postUrl,
      this.uid,
      this.like});

  // data from server
  factory PostsModel.fromMap(map) {
    return PostsModel(
      username: map["username"],
      caption: map["caption"],
      dateOfPublished: map["dateOfPublished"],
      postId: map["postId"],
      postUrl: map["postUrl"],
      uid: map["uid"],
      like: map["like"],
    );
  }

  // data to server
  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "caption": caption,
      "dateOfPublished": dateOfPublished,
      "postId": postId,
      "postUrl": postUrl,
      "uid": uid,
      "like": like,
    };
  }
}
