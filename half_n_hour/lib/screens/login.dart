import 'package:HnH/db/users.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';

import 'home_page.dart';

import 'phone.dart';
import 'signup.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ShapeBorder shape;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  SharedPreferences _preferences;
  bool loading = false, isConnected;
  bool _autovalidate = false, hidePass = true;
  String _email, _password;

  String verificationId;



  Future handleSignIn() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      loading = true;
    });

    var conResult = await Connectivity().checkConnectivity();
    if (conResult == ConnectivityResult.mobile || conResult == ConnectivityResult.wifi){
      isConnected = true;
    }
    else{
      isConnected = false;
    }

    if (isConnected) {
      GoogleSignInAccount googleUser = await googleSignIn.signIn()
          .catchError((onError){
        setState(() {
          loading = false;
          print(onError.toString());
        });
      });

      if (googleUser != null){
        GoogleSignInAuthentication googleSignInAuthentication = await googleUser
            .authentication;
        final AuthCredential credential = GoogleAuthProvider.getCredential(
            idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
        final FirebaseUser firebaseUser =  await firebaseAuth.signInWithCredential(credential)
            .catchError((e){
          setState(() {
            loading = false;
            print(e.toString());
          });
        });

        if (firebaseUser != null) {
          final QuerySnapshot result = await Firestore.instance.collection("users")
              .where("id", isEqualTo: firebaseUser.uid)
              .getDocuments();
          final List<DocumentSnapshot> documents = result.documents;

          if (documents.length == 0) {
            // insert user to our collection
            Firestore.instance.collection("users")
                .document(firebaseUser.uid)
                .setData({
              "id": firebaseUser.uid,
              "username": firebaseUser.displayName,
              "email": firebaseUser.email,
              "profilePicture": firebaseUser.photoUrl
            });
            await _preferences.setString("id", firebaseUser.uid);
            await _preferences.setString("username", firebaseUser.displayName);
            await _preferences.setString("email", firebaseUser.email);
            await _preferences.setString("photoUrl", firebaseUser.photoUrl);
          }
          else {
            await _preferences.setString("id", documents[0]['id']);
            await _preferences.setString("username", documents[0]['username']);
            await _preferences.setString("email", documents[0]['email']);
            await _preferences.setString("photoUrl", documents[0]['profilePicture']);
          }

          final FirebaseDatabase _db = FirebaseDatabase.instance;
          _db.reference().child("users").child(firebaseUser.uid)
            .once().then((DataSnapshot snapShot){
              Map<dynamic, dynamic> value = snapShot.value;
              if (value["address_1"] != null){
                _preferences.setString("address1", value["address_1"]);
              }
              if (value["address_2"] != null){
                _preferences.setString("address2", value["address_2"]);
              }
          });

          Fluttertoast.showToast(msg: "Welcome ${firebaseUser.displayName}",
              fontSize: 14.0,
              backgroundColor: Colors.black87
          );
          setState(() {
            loading = false;
          });
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => MyHomePage()));
        }
        else {
          setState(() {
            loading = false;
          });
          Fluttertoast.showToast(msg: "Login Failed",
              fontSize: 14.0,
              backgroundColor: Colors.black87
          );
        }
      }
      else{
        setState(() {
          loading = false;
        });
      }
    }
    else{
      setState(() {
        loading = false;
      });
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text('No Connection'),
              content: Text('Please connect to a network to continue'),
              actions: <Widget>[
                FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('OK',
                    style: TextStyle(
                        color: Colors.blue
                    ),
                  ),
                )
              ],
            );
          }
      );
    }
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          key: scaffoldKey,
          appBar: new AppBar(
            title: Text('Half n Hour',
              style: TextStyle(
                  color: Colors.black87
              ),
            ),
            backgroundColor: Colors.white,
          ),
          body: SafeArea(
              child: new SingleChildScrollView(
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                      height: 50.0,
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 7.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new GestureDetector(
                            onTap: () {
                              /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => login_screen()));*/
                            },
                            child: new Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          _verticalD(),
                          new GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()));
                            },
                            child: new Text(
                              'Signup',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black26,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new SafeArea(
                        top: false,
                        bottom: false,
                        child: Stack(
                          children: <Widget>[
                            Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)
                                ),
                                elevation: 5.0,
                                child: Form(
                                    key: _formKey,
                                    autovalidate: _autovalidate,
                                    child: SingleChildScrollView(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            const SizedBox(height: 24.0),
                                            TextFormField(
                                              decoration: const InputDecoration(
                                                  border: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.black87,style: BorderStyle.solid),
                                                  ),
                                                  focusedBorder:  UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.black87,style: BorderStyle.solid),
                                                  ),
                                                  icon: Icon(Icons.email,color: Colors.black38,),
                                                  labelText: 'E-mail',
                                                  labelStyle: TextStyle(color: Colors.black54)
                                              ),
                                              keyboardType: TextInputType.emailAddress,
                                              validator: (val) =>
                                              !val.contains('@') ? 'Not a valid email.' : null,
                                              onSaved: (val) => _email = val,
                                            ),

                                            const SizedBox(height: 24.0),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 2,
                                                  child: TextFormField(
                                                    obscureText: hidePass,
                                                    decoration: const InputDecoration(
                                                        border: UnderlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.black87,style: BorderStyle.solid),
                                                        ),
                                                        focusedBorder:  UnderlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.black87,style: BorderStyle.solid),
                                                        ),
                                                        icon: Icon(Icons.lock,color: Colors.black38,),
                                                        labelText: 'Password',
                                                        labelStyle: TextStyle(color: Colors.black54)
                                                    ),

                                                    validator: (val) =>
                                                    val.length < 6 ? 'Password too short.' : null,
                                                    onSaved: (val) => _password = val,
                                                  ),
                                                ),

                                                IconButton(
                                                  icon: Icon(Icons.remove_red_eye,
                                                    color: Colors.black38,
                                                  ),
                                                  onPressed: (){
                                                    setState(() {
                                                      if (hidePass){
                                                        hidePass = false;
                                                      }
                                                      else{
                                                        hidePass = true;
                                                      }
                                                    });
                                                  },
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 35.0,),
                                            new Container(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[

                                                  new Container(
                                                    alignment: Alignment.bottomLeft,

                                                    margin: EdgeInsets.only(left: 10.0),

                                                    child: new GestureDetector(

                                                      onTap: () async {
                                                        _formKey.currentState.save();
                                                        try{
                                                          await firebaseAuth.sendPasswordResetEmail(email: _email);
                                                          showInSnackBar('Please check your email');}
                                                        catch (e){
                                                          String msg=e.toString();
                                                          showInSnackBar("No User Found!");
                                                        }



                                                      },
                                                      child: Text('FORGOT PASSWORD?',style: TextStyle(
                                                          color: Colors.blueAccent,fontSize: 13.0
                                                      ),),
                                                    ),
                                                  ),
                                                  new Container(
                                                    alignment: Alignment.bottomRight,
                                                    child: new InkWell(
                                                      splashColor: Colors.pinkAccent,
                                                      onTap: (){
                                                        _submit();
                                                      },
                                                      child: Text('LOGIN',style: TextStyle(
                                                          color: Colors.pinkAccent,fontSize: 20.0,fontWeight: FontWeight.bold
                                                      ),),
                                                    ),
                                                  ),




                                                ],
                                              ),
                                            ),


                                            Divider(color: Colors.grey,),
                                            SizedBox(height: 35.0,),
                                            new Container(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Material(
                                                  borderRadius: BorderRadius.circular(25.0),
                                                  color: Colors.white,
                                                  elevation: 5.0,
                                                  child: MaterialButton(
                                                      onPressed: (){
                                                        Navigator.push(context, MaterialPageRoute(
                                                            builder: (context) => SignInPage()
                                                        ));
                                                      },
                                                      minWidth: MediaQuery.of(context).size.width,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding: EdgeInsets.all(4.0),
                                                            child: Icon(Icons.phone),
                                                          ),

                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 38.0),
                                                          ),

                                                          Text('Sign in With Phone',
                                                            textAlign: TextAlign.left,
                                                            style: TextStyle(
                                                                color: Colors.black87,
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: 18.0
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Material(
                                                  borderRadius: BorderRadius.circular(25.0),
                                                  color: Colors.white,
                                                  elevation: 5.0,
                                                  child: MaterialButton(
                                                    onPressed: (){
                                                      handleSignIn();
                                                    },
                                                    minWidth: MediaQuery.of(context).size.width,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: const EdgeInsets.all(4.0),
                                                          child: Image.asset('images/g_logo.png',
                                                            width: 30.0,
                                                            height: 30.0,
                                                          ),
                                                        ),

                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 32.0),
                                                        ),
                                                        Text('Sign in with Google',
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                              color: Colors.black87,
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 18.0
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]
                                      ),
                                    )
                                )        //login,
                            ),
                            Visibility(
                              visible: loading ?? true,
                              child: Center(
                                child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.white.withOpacity(0.9),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                    )
                  ],
                ),
              )
          )
      ),
    );
  }

  void _submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();

      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      signIn();
    }
    else{
      showInSnackBar('Please fix the errors in red before submitting.');

    }
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(value)
    ));
  }

  Future signIn() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      loading = true;
    });
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      try{
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)
            .then((_firebaseUser){

          if (_firebaseUser.email != _email){
            Fluttertoast.showToast(msg: "Incorrect email or password");
          }
          else
          {
            _preferences.setBool("LoggedInwithMail", true);
            _preferences.setString("LogUname", _email);
            final FirebaseDatabase _database = FirebaseDatabase.instance;

            String address = "";
            _database.reference().child("users").once().then((DataSnapshot snapShot) {
              Map<dynamic, dynamic> values = snapShot.value;
              values.forEach((key, value)async {
                if (_email == value["email"]) {
                  print(value["email"]);
                  address = value["address_1"];
                  print(address);
                  _preferences.setString("address1", address);
                }
              });
            });

            Fluttertoast.showToast(msg: "Welcome back ${_firebaseUser.displayName}");
            Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) =>  MyHomePage()
            ));
          }
        });

        setState(() {
          loading = false;
        });
      }catch(e){
        setState(() {
          loading = false;
        });
        showInSnackBar('Invalid Email or Password.');
      }
    }
  }
  _verticalD() => Container(
    margin: EdgeInsets.only(left: 40.0),
  );
}