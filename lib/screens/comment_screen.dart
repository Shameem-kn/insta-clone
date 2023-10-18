import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instaclone_ranavat/models/user.dart';
import 'package:instaclone_ranavat/providers/user_provider.dart';
import 'package:instaclone_ranavat/resources/fire_store_methods.dart';
import 'package:instaclone_ranavat/utils/colors.dart';
import 'package:instaclone_ranavat/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("comment"),
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                      hintText: "comment as ${user.username}",
                      border: InputBorder.none),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await FireStoremethods().postComment(
                    widget.snap["postId"],
                    user.username,
                    commentController.text,
                    user.uid,
                    user.photoUrl);
                setState(() {
                  commentController.text = "";
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: const Text(
                  "post",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            )
          ],
        ),
      )),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("posts")
              .doc(widget.snap["postId"])
              .collection("comments")
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: ((context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: ((context, index) {
                  return CommentCard(
                    snap: snapshot.data!.docs[index].data(),
                  );
                }));
          })),
    );
  }
}
