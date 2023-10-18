import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instaclone_ranavat/screens/profile_screen.dart';
import 'package:instaclone_ranavat/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUser = false;

  Future<QuerySnapshot<Map<String, dynamic>>> fetchData() async {
    // Fetch your data here, for example:
    return await FirebaseFirestore.instance.collection("posts").get();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            decoration: const InputDecoration(
              labelText: "search for  a user",
            ),
            controller: searchController,
            onFieldSubmitted: (String value) {
              setState(() {
                isShowUser = true;
              });
            },
          ),
        ),
        body: isShowUser
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .where("username",
                        isGreaterThanOrEqualTo: searchController.text)
                    .get(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  print("false");
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    // No users found based on the search query
                    return const Center(child: Text('No users found.'));
                  } else {
                    return ListView.builder(
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                          uid: (snapshot.data! as dynamic)
                                              .docs[index]["uid"],
                                        ))),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  (snapshot.data! as dynamic).docs[index]
                                      ["photourl"],
                                ),
                              ),
                              title: Text(
                                (snapshot.data! as dynamic).docs[index]
                                    ["username"],
                              ),
                            ),
                          );
                        });
                  }
                })
            : FutureBuilder(
                // future: FirebaseFirestore.instance.collection("posts").get(),
                future: fetchData(),
                builder: ((context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    print("inside ${snapshot.data!.docs.length}");

                    return GridView.custom(
                      padding: const EdgeInsets.only(
                        bottom: 8,
                        left: 8,
                        right: 8,
                      ),
                      gridDelegate: SliverQuiltedGridDelegate(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        repeatPattern: QuiltedGridRepeatPattern.inverted,
                        pattern: const [
                          QuiltedGridTile(2, 2),
                          QuiltedGridTile(1, 1),
                          QuiltedGridTile(1, 1),
                        ],
                      ),
                      childrenDelegate: SliverChildBuilderDelegate(
                        (context, index) {
                          print(index);

                          if (index < snapshot.data!.docs.length) {
                            return Image(
                              image: NetworkImage(
                                  snapshot.data!.docs[index]["postUrl"]),
                              // NetworkImage(
                              //     snapshot.data!.docs[index]["postUrl"])
                            );
                          } else {
                            return Image(
                                image: NetworkImage(
                                    snapshot.data!.docs[index]["postUrl"]));
                          }
                        },
                        childCount: snapshot.data!.docs.length,
                      ),
                    );
                  } else {
                    // No users found based on the search query
                    return const Center(child: Text('No posts found.'));
                  }
                }),
              ));
  }
}
