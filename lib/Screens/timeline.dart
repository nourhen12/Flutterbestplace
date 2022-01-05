import 'package:flutter/material.dart';
import 'package:flutterbestplace/models/user.dart';
import 'package:flutterbestplace/Screens/home.dart';
import 'package:flutterbestplace/Screens/header.dart';
import 'package:flutterbestplace/models/post.dart';
import 'package:flutterbestplace/components/progress.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:flutterbestplace/Screens/Posts/post.dart';
//CollectionReference users = FirebaseFirestore.instance.collection('user');
final  users =FirebaseFirestore.instance.collection('user');
/*
class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('user').snapshots();

  @override
  void initState(){
  //createUser();
  super.initState();
}
  createUser()async {
    return await users
        .add({
      'fullname': "ddd", // John Doe
      'adress': "tn", // Stokes and Sons
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['fullname']),
            );

          }).toList(),
        );
      },
    );

  }

}*/

class Timeline extends StatefulWidget {
  final CUser currentUser;

  Timeline({ this.currentUser});

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
   List<PostS> posts;
   List<Post> Mposts;
  @override
  void initState() {
    super.initState();
    getTimeline();
  }

  getTimeline() async {
    QuerySnapshot snapshot = await timelineRef
        .doc(widget.currentUser.id)
        .collection('timelinePosts')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      Mposts =
          snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
      //posts = Mposts;
    });
  }

  buildTimeline() {
    if (Mposts == null) {
      return circularProgress();
    } else if (Mposts.isEmpty) {
      return Text("No posts");
    } else {
      return ListView(children: posts);
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: header(context, isAppTitle: true),
        body: RefreshIndicator(
            onRefresh: () => getTimeline(), child: buildTimeline()));
  }
}
