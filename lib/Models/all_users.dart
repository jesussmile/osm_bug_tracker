//import 'package:flutter/material.dart';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Users {
  String id;
  String email;
  String name;
  String phone;

  Users({this.id, this.email, this.name, this.phone});

  // Users.getKey(String key) {
  //   id = key;
  //   print("Users $key");
  // }

  Users.fromSnapShot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key;
    email = dataSnapshot.value["email"];
    name = dataSnapshot.value["name"];
    phone = dataSnapshot.value["phone"];
    print("Users email $email");
    print("Users name $name");
    print("Users phone $phone");
  }

  // print ("Users $key");
}
