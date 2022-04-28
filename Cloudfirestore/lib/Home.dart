import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/post.dart';

class Home extends StatelessWidget {
  final Stream<QuerySnapshot> _postStream =
      FirebaseFirestore.instance.collection('posts').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
          child: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: _postStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map data =
                      document.data()! as Map;
                  return Post(data: data);
                }).toList(),
              );
            }),
      )),
    ));
  }
}
