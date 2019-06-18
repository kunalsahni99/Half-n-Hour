import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

import 'signup.dart';


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
  SharedPreferences _preferences;
  final UserUpdateInfo userUpdateInfo = UserUpdateInfo();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String _message = '';
  String _verificationId;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Column(



      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

        SizedBox(height: 40.0,),
        new Container(
          alignment: Alignment.center,

          child: Text('LOGIN',style: TextStyle(
              color: Colors.orange,fontSize: 30.0,fontWeight: FontWeight.bold
          ),),
        ),
        SizedBox(height: 40.0,),

        Divider(color: Colors.grey,),



        TextFormField(
          controller: _phoneNumberController,
          decoration:

          InputDecoration(labelText: 'Phone number ',icon: Icon(Icons.phone,color: Colors.black38,),),

          validator: (String value) {
            if (value.isEmpty) {
              widget._scaffold.showSnackBar(SnackBar(
                content:
                const Text('Enter a valid No.'),
              ));
            }

          },
        ),
        SizedBox(height: 15.0,),

        new Container(

          alignment: Alignment.center,
          child: Material(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
            elevation: 5.0,
            child: MaterialButton(
              onPressed: (){
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
        SizedBox(height: 20.0,),
        TextField(
          controller: _smsController,
          decoration: InputDecoration(labelText: 'Verification code',icon: Icon(Icons.message,color: Colors.black38,),),
        ),
        SizedBox(height: 15.0,),
        new Container(
          alignment: Alignment.center,

          child: Material(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
            elevation: 5.0,
            child: MaterialButton(
              onPressed: (){
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

        SizedBox(height: 20.0,),
        Divider(color: Colors.grey,),
        SizedBox(height: 50.0,),

        new Container(

          alignment: Alignment.center,
          child: Material(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.pink.shade500,
            elevation: 8.0,
            child: MaterialButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SignUp()
                ));
              },
              minWidth: 250.0,
              child: Text('SignUp',

                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white,
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
        )
      ],
    );

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
      setState(() async{

        _message = 'Successfully signed in ';
        userUpdateInfo.displayName=_phoneNumberController.text;
        final FirebaseUser user = await auth.currentUser();
        await user.updateProfile(userUpdateInfo);

        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) =>  MyHomePage()
        ));
        await _preferences.setString("Pname",_phoneNumberController.text );
        await _preferences.setBool("LoginPhone",true);
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

  }
}
