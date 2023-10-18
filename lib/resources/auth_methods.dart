import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instaclone_ranavat/models/user.dart';
import 'package:instaclone_ranavat/resources/storage_method.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails() async {
    User currentuser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection("users").doc(currentuser.uid).get();

    return UserModel.fromSnap(snap);
  }

  // signup
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "some error occured";
    try {
      if (email.isNotEmpty ||
              password.isNotEmpty ||
              username.isNotEmpty ||
              bio.isNotEmpty
          // ||file.isNotEmpty
          ) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // add image to storage
        String photoUrl = await StorageMethods()
            .uploadImageToStorage("profilePics", file, false);
        //  add user to database

        UserModel user = UserModel(
            email: email,
            uid: cred.user!.uid,
            photoUrl: photoUrl,
            username: username,
            bio: bio,
            followers: [],
            following: []);
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());

        // await _firestore.collection("users").doc(cred.user!.uid).set({
        //   "username": username,
        //   "uid": cred.user!.uid,
        //   "email": email,
        //   "bio": bio,
        //   "followers": [],
        //   "following": [],
        // });

        // await _firestore.collection("users").add({
        //   "username": username,
        //   "uid": cred.user!.uid,
        //   "email": email,
        //   "bio": bio,
        //   "followers": [],
        //   "following": [],
        // });

        res = "success";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        res = "the email is badly formatted";
      } else if (e.code == "weak-password") {
        res = "password should be atleast 6 charcters";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "please enter all the fields";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    _auth.signOut();
  }
}
