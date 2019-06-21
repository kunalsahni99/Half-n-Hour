import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';

import 'home_page.dart';

import 'signup.dart';
import 'package:shared_preferences/shared_preferences.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;


class SignInPage extends StatefulWidget {
  final String title = 'Login';

  @override
  State<StatefulWidget> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return FlatButton(
              child: const Text('Sign out'),
              textColor: Theme.of(context).buttonColor,
              onPressed: () async {
                final FirebaseUser user = await _auth.currentUser();
                if (user == null) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: const Text('No one has signed in.'),
                  ));
                  return;
                }
                _signOut();
                final String uid = user.uid;
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(uid + ' has successfully signed out.'),
                ));
              },
            );
          })
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[

            _PhoneSignInSection(Scaffold.of(context)),

          ],
        );
      }),
    );
  }

  // Example code for sign out.
  void _signOut() async {
    await _auth.signOut();
  }
}



class _PhoneSignInSection extends StatefulWidget {
  _PhoneSignInSection(this._scaffold);

  final ScaffoldState _scaffold;
  @override
  State<StatefulWidget> createState() => _PhoneSignInSectionState();
}

class _PhoneSignInSectionState extends State<_PhoneSignInSection> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  final UserUpdateInfo userUpdateInfo = UserUpdateInfo();

  String _message = '';
  String _verificationId;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.ltr,
        children: <Widget>[


          new Container(
            height: 100,
            width: MediaQuery.of(context).size.width,

            child: new Card(
                elevation: 5,
                child:Column(

                  children: <Widget>[

                  ],
                )
            ),
          ),


          new Container(

              margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
              alignment: Alignment.center,
              height: 350.0,
              child: new Card(

                  elevation: 5.0,
                  child: Column(
                    children: <Widget>[



                      TextFormField(
                        controller: _phoneNumberController,
                        decoration:

                        InputDecoration(labelText: 'Phone number ',
                          icon: Icon(Icons.phone, color: Colors.black38,),),

                        validator: (String value) {
                          if (value.isEmpty) {
                            widget._scaffold.showSnackBar(SnackBar(
                              content:
                              const Text('Enter a valid No.'),
                            ));
                          }
                        },
                      ),
                      SizedBox(height: 20.0,),

                      new Container(

                        alignment: Alignment.center,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                          elevation: 5.0,
                          child: MaterialButton(
                            onPressed: () {
                              _verifyPhoneNumber();
                            },
                            minWidth: 70,


                            child: Text('Send  Code',

                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.pink,

                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.0,),
                      TextField(
                        controller: _smsController,
                        decoration: InputDecoration(
                          labelText: 'Verification code',
                          icon: Icon(Icons.message, color: Colors.black38,),),
                      ),
                      SizedBox(height: 20.0,),
                      new Container(
                        alignment: Alignment.center,

                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                          elevation: 5.0,
                          child: MaterialButton(
                            onPressed: () {
                              _signInWithPhoneNumber();
                            },
                            minWidth: 70.0,
                            child: Text('Verify Code',

                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.pink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0
                              ),
                            ),
                          ),
                        ),
                      ),

                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          _message,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ))),
          SizedBox(height: 5.0,),
          new Container(
            margin: EdgeInsets.fromLTRB(10,0,10,0),
            alignment: Alignment.center,
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.pinkAccent,
              elevation: 5.0,
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SignUp()
                  ));
                },
                minWidth: MediaQuery.of(context).size.width,
                child: Text('Sign  Up',

                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0
                  ),
                ),
              ),
            ),
          ),
          new Container(
            height: 70,
            margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
            width: MediaQuery.of(context).size.width,

            child: new Card(
                elevation: 5,
                child:Column(

                  children: <Widget>[

                  ],
                )
            ),
          ),
        ]);
  }

  // Exmaple code of how to veify phone number
  void _verifyPhoneNumber() async {
    setState(() {
      _message = '';
    });
    if(_phoneNumberController.text.isEmpty)
    {
      widget._scaffold.showSnackBar(SnackBar(
        content:
        const Text('Enter a valid No.'),
      ));
    }
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);
      setState(() async {
        SharedPreferences _preferences=await SharedPreferences.getInstance();
        _preferences.setBool("LoginPhone", true);
        _preferences.setString("Phone",_phoneNumberController.text);

        final FirebaseUser user = await _auth.currentUser();
        userUpdateInfo.displayName=_phoneNumberController.text;
        await user.updateProfile(userUpdateInfo);

        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) =>  MyHomePage()
        ));

        Fluttertoast.showToast(msg: "Welcome"+_phoneNumberController.text,
            fontSize: 14.0,
            backgroundColor: Colors.black87
        );
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        Fluttertoast.showToast(msg: "Invalid Number",
            fontSize: 14.0,
            backgroundColor: Colors.black87
        );
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      widget._scaffold.showSnackBar(SnackBar(
        content:
        const Text('Please check your phone for the verification code.'),
      ));
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber:'+91'+_phoneNumberController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  // Example code of how to sign in with phone.
  void _signInWithPhoneNumber() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _smsController.text,
    );
    if(_phoneNumberController.text.isEmpty)
    {
      widget._scaffold.showSnackBar(SnackBar(
        content:
        const Text('Enter a valid No.'),
      ));
    }
    else if(_smsController.text.isEmpty)
    {
      widget._scaffold.showSnackBar(SnackBar(
        content:
        const Text('Enter a valid Code'),
      ));
    }
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        _message = 'Successfully signed in, uid: ' + user.uid;

        final FirebaseDatabase _database = FirebaseDatabase.instance;
        _database.reference().child("users").child(user.uid)
            .once().then((DataSnapshot snapShot){
          Map<dynamic, dynamic> value = snapShot.value;
          if (value["address_1"] != null){
            _preferences.setString("address1", value["address_1"]);
          }
          if (value["address_2"] != null){
            _preferences.setString("address2", value["address_2"]);
          }
        });

        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) =>  MyHomePage()
        ));


      } else {
        _message = 'Sign in failed';
      }
    });
  }
}