import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instaclone_ranavat/models/post.dart';
import 'package:instaclone_ranavat/resources/storage_method.dart';
import 'package:instaclone_ranavat/utils/utils.dart';
import 'package:uuid/uuid.dart';

class FireStoremethods {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

// upload post

  Future<String> uploadPost(
    String description,
    String uid,
    Uint8List file,
    String username,
    String profImage,
  ) async {
    String res = "some error occured";

    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);

      String postId = Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          postId: postId,
          postUrl: photoUrl,
          datePublished: DateTime.now(),
          profImage: profImage,
          likes: []);

      firestore.collection("posts").doc(postId).set(post.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        await firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(String postId, String name, String text, String uid,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          "profilePic": profilePic,
          "name": name,
          "uid": uid,
          "text": text,
          "commentId": commentId,
          "datePublished": DateTime.now(),
        });
      } else {
        print("the text is empty");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // delete post
  Future<void> deletePost(String postId) async {
    try {
      await firestore.collection("posts").doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await firestore.collection("users").doc(uid).get();
      List following = (snap.data()! as dynamic)["following"];
      if (following.contains(followId)) {
        await firestore.collection("users").doc(followId).update({
          "followers": FieldValue.arrayRemove([uid]),
        });
        await firestore.collection("users").doc(uid).update({
          "followers": FieldValue.arrayRemove([followId]),
        });
      } else {
        await firestore.collection("users").doc(followId).update({
          "followers": FieldValue.arrayUnion([uid]),
        });
      }
      await firestore.collection("users").doc(uid).update({
        "following": FieldValue.arrayUnion([followId]),
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
