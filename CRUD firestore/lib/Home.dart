import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/post.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart'as path;
import 'dart:io';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController titleController = TextEditingController();

  TextEditingController descController = TextEditingController();
  String? imagePath;

  final Stream<QuerySnapshot> _postStream =
  FirebaseFirestore.instance.collection('posts').snapshots();

  @override
  Widget build(BuildContext context) {
    Future imagepick() async {
      final ImagePicker _picker = ImagePicker();
      // Pick an image
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        imagePath=image!.path;
      });
    }

    void submit() async{
      try{

        String title = titleController.text;
        String desc= descController.text;
        String Imagename = path.basename(imagePath!);
        final storage = FirebaseStorage.instance;
        final storageRef = FirebaseStorage.instance.ref();
        final picsRef = storageRef.child(Imagename);
        File file=File(imagePath!);
        // storageRef.putFile(file);
        // FirebaseStorage storageRef=FirebaseStorage.instance;
        // Reference reference = storageRef.ref().child('image');

        await picsRef.putFile(file);
        String url = await picsRef.getDownloadURL();
        FirebaseFirestore db=FirebaseFirestore.instance;
        //uploadtask being asyn by nature doesnt need await .. can be uploaded by below
        // UploadTask uploadTask= picsRef.putFile(file);
        //.set when id is known .add when unknown
        await db.collection('posts').add({
          "title" : title,
          "description" :desc,
          "url": url
        });

        print('post uploaded successfully');
        titleController.clear();
        descController.clear();
      }catch(e){
        print(e);
      }
    }

    return Scaffold(
        body: Container(padding: EdgeInsets.symmetric(horizontal: 10),
            child: SafeArea(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Enter title'),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: 'Enter description'),
              ),
              ElevatedButton(onPressed: imagepick, child: Text('Upload Image')),
              ElevatedButton(onPressed: submit, child: Text('Submit')),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: _postStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text("Loading");
                        }
                        return ListView(
                          children:
                              snapshot.data!.docs.map((DocumentSnapshot document) {
                            Map data = document.data()! as Map;
                            String id=document.id;
                            data['id']=id;
                            return Post(data: data);
                          }).toList(),
                        );
                      }),
                ),
              )
            ],
          ),
        )));
  }
}
