import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';

import 'home_page.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  SharedPreferences sharedPreferences;
  bool loading = false, isConnected;

  Future handleSignIn() async {
    sharedPreferences = await SharedPreferences.getInstance();
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
            await sharedPreferences.setString("id", firebaseUser.uid);
            await sharedPreferences.setString("username", firebaseUser.displayName);
            await sharedPreferences.setString("email", firebaseUser.email);
            await sharedPreferences.setString("photoUrl", firebaseUser.photoUrl);
          }
          else {
            await sharedPreferences.setString("id", documents[0]['id']);
            await sharedPreferences.setString("username", documents[0]['username']);
            await sharedPreferences.setString("email", documents[0]['email']);
            await sharedPreferences.setString("photoUrl", documents[0]['profilePicture']);
          }
          print(documents[0]['id']);
          print(documents[0]['username']);
          print(documents[0]['email']);
          print(documents[0]['profilePicture']);

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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset('images/splash.jpg',
            fit: BoxFit.fill,
            width: width,
            height: height,
          ),

          Container(
            color: Colors.black.withOpacity(0.5),
            width: double.infinity,
            height: double.infinity,
          ),

          Container(
            padding: EdgeInsets.only(top: 70.0),
            alignment: Alignment.topCenter,
            child: Image.asset('images/launcher_icon.png',
                height: 100.0,
                width: 100.0
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white.withOpacity(0.4),
                          elevation: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: TextFormField(
                              controller: _emailTextController,
                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(
                                  color: Colors.white
                                ),
                                icon: Icon(Icons.email,
                                  color: Colors.white,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.white
                                ),
                                border: InputBorder.none
                              ),
                              style: TextStyle(
                                  color: Colors.white
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value){
                                if (value.isEmpty){
                                  Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                  RegExp regex = new RegExp(pattern);
                                  if (!regex.hasMatch(value)){
                                    return "Please enter a valid email address";
                                  }
                                  else{
                                    return null;
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white.withOpacity(0.4),
                          elevation: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: TextFormField(
                              controller: _passwordTextController,
                              decoration: InputDecoration(
                                  labelText: "Password",
                                  labelStyle: TextStyle(
                                      color: Colors.white
                                  ),
                                  icon: Icon(Icons.lock_outline,
                                    color: Colors.white,
                                  ),
                                  hintStyle: TextStyle(
                                      color: Colors.white
                                  ),
                                  border: InputBorder.none
                              ),
                              style: TextStyle(
                                color: Colors.white
                              ),
                              obscureText: true,
                              validator: (value){
                                if (value.isEmpty){
                                  return "Password cannot be empty";
                                }
                                else if (value.length < 6){
                                  return "Password needs to be atleast 6 characters long";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.pink.shade500,
                          elevation: 0.0,
                          child: MaterialButton(
                            onPressed: (){},
                            minWidth: MediaQuery.of(context).size.width,
                            child: Text('Sign in',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0
                              ),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Forgot Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 70.0),
                        child: Row(
                          children: <Widget>[
                            Text("Don't have an account? ",
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 2.0),
                              child: InkWell(
                                child: Text('Sign up!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => SignUp()
                                  ));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      Divider(color: Colors.white,),
                      Text('OR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Colors.white,
                            elevation: 0.1,
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
                    ],
                  ),
                ),
              ),
            ),
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
      ),
    );
  }
}
