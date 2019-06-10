import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices{
  SharedPreferences _preferences;
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String ref = "users";

  createUser(String id, Map value)async{
    _preferences = await SharedPreferences.getInstance();
    await _preferences.setString("UID", id);
    _database.reference().child("$ref/$id")
        .set(value)
        .catchError((e){
          print(e.toString());
        });
  }
}