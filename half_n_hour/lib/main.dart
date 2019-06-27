import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;

import './screens/home_page.dart';
import './screens/onboard.dart';
import 'package:flutter/rendering.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return isIOS ?
        CupertinoApp(
          debugShowCheckedModeBanner: false,
          title: 'Half n Hour',
          theme: CupertinoThemeData(
            primaryColor: Colors.pinkAccent,
            barBackgroundColor: Colors.pinkAccent
          ),
          home: SplashScreen(),
        )
        :MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Half n Hour',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.pinkAccent,
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
      isLoggedIn, SignupEmail, isLoggedInEmail, isLoggedInPhone;

  void initState(){
    super.initState();
    Timer(
      Duration(seconds: 2),
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
    isLoggedIn = await googleSignIn.isSignedIn() ?? false;
    SignupEmail = sharedPreferences.getBool("isLoggedIn") ?? false;
    isLoggedInEmail = sharedPreferences.getBool("LoggedInwithMail") ?? false;
    isLoggedInPhone = sharedPreferences.getBool("loggedwithPhone") ?? false;

    if (isLoggedIn || isLoggedInEmail || SignupEmail || isLoggedInPhone) {
      if (isIOS){
        Navigator.pushReplacement(context, CupertinoPageRoute(
          builder: (context) => MyHomePage()
        ));
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => MyHomePage()));
      }
    }
    else{
      if (isIOS){
        Navigator.pushReplacement(context, CupertinoPageRoute(
            builder: (context) => OnBoarding()));
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => OnBoarding()));
      }
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isIOS ?
        CupertinoPageScaffold(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Color(0xff622F74),
                    gradient: LinearGradient(
                        colors: [Color(0xff6094e8), Color(0xffde5cbc)],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft
                    )
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
        )

        : Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Color(0xff622F74),
                gradient: LinearGradient(
                    colors: [Color(0xff6094e8), Color(0xffde5cbc)],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft
                )
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