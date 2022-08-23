import 'package:flutter/cupertino.dart';
import 'package:ummah/methods/auth_methods.dart';
import 'package:ummah/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get getUser => _user;

  Future<void> refreshUser() async {
    UserModel user = await AuthMethods().getUserDetails();
    _user = user;
    notifyListeners();
  }
}
