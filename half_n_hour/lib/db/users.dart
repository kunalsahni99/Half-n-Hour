import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserServices{
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String ref = "users";

  var CartList = [];

  void createUser(String id, Map value){
    _database.reference().child("$ref/$id")
        .set(value)
        .catchError((e){
          print(e.toString());
        });
  }

  Future<Widget> ShowDialog(BuildContext context){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return AlertDialog(
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black87)
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text('Please wait...',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
