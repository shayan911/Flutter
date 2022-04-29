import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/EditDialog.dart';
import 'package:untitled/Home.dart';


class Post extends StatefulWidget {
  final Map data;
  Post({required this.data});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    void delete() async{
      try{
      FirebaseFirestore db=FirebaseFirestore.instance;
      db.collection('posts').doc(widget.data['id']).delete();
    }catch(e){
        print(e);

    }

    }
    void edit(){

      FirebaseFirestore db=FirebaseFirestore.instance;
      showDialog(context: context,
          builder:(BuildContext context){
        return Edit(data: widget.data);
      });
    }
    return Container(decoration: BoxDecoration(
      border: Border.all(color: Colors.black,width: 1)
    ),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Image.network(widget.data['url'],width: 150,height: 150,)
        ,Text(widget.data['title']),Text(widget.data['description']),
          ElevatedButton(onPressed: delete, child: Text('Delete')),
          ElevatedButton(onPressed: edit, child: Text('Edit')),

        ],
      )
    );
  }
}
