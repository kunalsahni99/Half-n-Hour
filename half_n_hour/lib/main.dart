import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './screens/login.dart';
import './screens/home_page.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Product Sans'
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  SharedPreferences sharedPreferences;
  bool loading = false,
      isLoggedIn = false, isLoggedInEmail = false;

  void initState(){
    super.initState();
    Timer(
      Duration(seconds: 5),
      (){
        isSignIn();
      }
    );
  }

  void isSignIn() async {
    setState(() {
      loading = true;
    });
    sharedPreferences = await SharedPreferences.getInstance();
    isLoggedIn = await googleSignIn.isSignedIn();
    isLoggedInEmail = sharedPreferences.getBool("isLoggedIn") ?? false;
    if (isLoggedIn) {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => MyHomePage()));
    }
    else if (isLoggedInEmail){
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => MyHomePage()));
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => Login()));
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            color: Colors.black.withOpacity(0.6),
            child: Image.asset('images/splash.jpg',
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: Image.asset('images/launcher_icon.png',
                          fit: BoxFit.cover,
                          height: 60.0,
                          width: 60.0,
                        )
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),

                      Text('Half n Hour',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text('Online Store\nfor Everyone',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}