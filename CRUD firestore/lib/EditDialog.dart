import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart'as path;
import 'dart:io';

import 'package:untitled/Home.dart';

class Edit extends StatefulWidget {
  final Map data;
  Edit({required this.data});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  String? imagePath;
    TextEditingController titleController = TextEditingController();
    TextEditingController descController = TextEditingController();
  @override
  void initState() {
    super.initState();
    titleController.text=widget.data['title'];
    descController.text=widget.data['description'];
  }

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
    void done() async{
      try{
        String Imagename = path.basename(imagePath!);
        final storage = FirebaseStorage.instance;
        final storageRef = FirebaseStorage.instance.ref();
        final picsRef = storageRef.child(Imagename);

        File file=File(imagePath!);

        await picsRef.putFile(file);
        String url = await picsRef.getDownloadURL();
        FirebaseFirestore db=FirebaseFirestore.instance;

        Map<String, dynamic> newPost ={
          "title": titleController.text,
          "description": descController.text,
          "url": url
        } ;
        await db.collection('posts').doc(widget.data['id']).set(newPost);
        Navigator.of(context).pop();

      }catch(e){
        print(e);
      }
    }

    return AlertDialog(content: Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Enter title'),
          ),
          TextField(
            controller: descController,
            decoration: InputDecoration(labelText: 'Enter description'),
          ),
          ElevatedButton(onPressed: imagepick, child: Text('Edit Image')),
          ElevatedButton(onPressed: done, child: Text('Done')),
        ],
      ),
    ),);
  }
}
