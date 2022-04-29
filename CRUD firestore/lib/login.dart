import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class login extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController= TextEditingController(text: "uzair@gmail.com");
    final TextEditingController passwordController= TextEditingController(text: "uzair123");

    void log() async{
      FirebaseAuth auth=FirebaseAuth.instance;
      FirebaseFirestore db=FirebaseFirestore.instance;
      final String email= emailController.text;
      final String password= passwordController.text;
      try{
        final UserCredential user = await auth.signInWithEmailAndPassword(email: email, password: password);
        final DocumentSnapshot snapshot = await db.collection('users').doc(user.user?.uid).get();
        final data = snapshot.data() as Map;

        Navigator.of(context).pushNamed("/home",arguments: data);
      } catch(e){
        print('error');
        var error = e.toString().split(']');
        showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(content:Text(error[1]),);

        });

      }
    }



    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          child: SafeArea(
            child: Column(
              children: [
                TextField(controller: emailController,
                  decoration: InputDecoration(
                      labelText: 'Email'
                  ),
                ),TextField(controller: passwordController,
                  decoration: InputDecoration(
                      labelText: 'Password'
                  ),
                ),
                ElevatedButton(onPressed: log, child: Text('Login'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
