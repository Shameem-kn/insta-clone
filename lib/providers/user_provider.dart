import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone_ranavat/models/user.dart';
import 'package:instaclone_ranavat/resources/auth_methods.dart';

class UserProvider extends ChangeNotifier {
  // user must be made private
  UserModel? _user;
  final AuthMethods _authMethods = AuthMethods();
  UserModel get getUser => _user != null
      ? _user!
      : const UserModel(
          email: "null",
          uid: "null",
          photoUrl: "null",
          username: "null",
          bio: "mull",
          followers: [],
          following: []);

  Future<void> refreshUser() async {
    UserModel userdetails = await _authMethods.getUserDetails();
    print("${userdetails.username}");
    _user = userdetails;
    notifyListeners();
  }
}
