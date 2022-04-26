import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class API extends StatefulWidget {

  @override
  State<API> createState() => _APIState();
}

class _APIState extends State<API> {

  getuser() async{
    var   users=[];
    var response = await http.get(Uri.https('jsonplaceholder.typicode.com', 'users'));
    var json = jsonDecode(response.body);

    for(var i in json){
      Usermodel getdata = Usermodel(i['name'],i['username'],i['company']['name']);
      users.add(getdata);
    }
    return users;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future:getuser() ,
      builder: (context,AsyncSnapshot snapshot){
          if(snapshot.connectionState==ConnectionState.done){


               return ListView.builder(itemCount: snapshot.data.length,
                   itemBuilder: (context, i) {

 //Remember in snapshot.data[i].<var> . var is a variable that must be the same as defined
// below in the constructor of class Usermodel. This is because the getuser() returns a list
// namely "users" in which this constructor is called and each value gets stored in the initial parameters.
//
// Usermodel(i['name'],i['username'],i['company']['name']) this is actually = Usermodel(this.name,this.user,this.company)
//
// in other words i['name'] = name
// i['username'] = user
// i['company']['name'] = company
//
// The data returned from api contains dictionaries within list [{"name": "Leanne Graham"},{}....]
// i['name'] returns the value for key 'name' for every ith iteration and gets stored in variable name
// same applies for the succeeding values

                     return ListTile(title: Text(snapshot.data[i].name),
                     subtitle: Text(snapshot.data[i].company),);
                   });

    }else{ return CircularProgressIndicator();}
          }
      )
    );
  }
}

class Usermodel{
  var user;
  var company;
  var name;

  Usermodel(this.name,this.user,this.company);
}


// #another way to get api is below
// body: FutureBuilder(
//             future: getUser(),
//             builder: (context, AsyncSnapshot snapshot) {
//               if (snapshot.data == null) {
//                 return Container(child: Text("No Data in API"));
//               } else {
//                 return ListView.builder(
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (context, i) {
//                       return ListTile(
//                         title: Text(snapshot.data[i].name),
//                         subtitle: Text(snapshot.data[i].company),
//                       );
//                     });
//               }
//             })