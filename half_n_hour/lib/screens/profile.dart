import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  SharedPreferences preferences;
  bool isLoggedIn = false, isLoggedInEmail;
  String _ButtText = 'Log Out';

  Future _signOut()async{
    try{
      preferences = await SharedPreferences.getInstance();
      isLoggedIn = await _googleSignIn.isSignedIn();
      isLoggedInEmail = preferences.getBool("isLoggedIn");
      await _auth.signOut();

      if (isLoggedIn){
        await _googleSignIn.signOut();
      }
      if (isLoggedInEmail){
        preferences.setBool("isLoggedIn", false);
      }
    }
    catch (e){
      e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('My account',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.pink.shade500,
              elevation: 0.0,
              child: MaterialButton(
                onPressed: (){
                  _signOut();
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => Login()
                  ));
                },
                minWidth: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Text(_ButtText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0
                  ),
                ),
              ), ),
        ),
      ),
    );
  }
}
