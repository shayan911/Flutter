import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class register extends StatelessWidget {
  const register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController= TextEditingController();
    final TextEditingController emailController= TextEditingController();
    final TextEditingController passwordController= TextEditingController();

    void reg() async{
      FirebaseAuth auth=FirebaseAuth.instance;
      FirebaseFirestore db=FirebaseFirestore.instance;
      final String username= usernameController.text;
      final String email= emailController.text;
      final String password= passwordController.text;
      try{
        final UserCredential user = await auth.createUserWithEmailAndPassword(email: email, password: password);
        await db.collection('users').doc(user.user?.uid).set({
          "email" : email,
          "username" :username
        });
        print('The user is registered');
      } catch(e){
        print('error');
      }
    }



    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          child: SafeArea(
            child: Column(
              children: [
                TextField(controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username'
                ),
                ),TextField(controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email'
                ),
                ),TextField(controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password'
                ),
                ),
                ElevatedButton(onPressed: reg, child: Text('Register'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
