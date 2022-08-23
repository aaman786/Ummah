class UserModel {
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? uid;

  UserModel(
      {this.username, this.email, this.firstName, this.lastName, this.uid});

  // data from server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map["uid"],
        email: map["email"],
        firstName: map["firstName"],
        lastName: map["lastName"],
        username: map["username"]);
  }

  // data to server
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "email": email,
      "lastName": lastName,
      "firstName": firstName,
      "username": username,
    };
  }
}
