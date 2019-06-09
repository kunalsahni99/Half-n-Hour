import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/users.dart';
import './home_page.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  UserServices _userServices = UserServices();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _confirmpasswordTextController = TextEditingController();
  String gender, groupValue = 'male';

  SharedPreferences preferences;
  bool loading = false, hidePass = true, exists = false, ConHidePass = true;
  bool _autoValidate;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset('images/splash.jpg',
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
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
                        // name
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.4),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: ListTile(
                                title: TextFormField(
                                  controller: _nameTextController,
                                  decoration: InputDecoration(
                                    labelText: "Name",
                                    labelStyle: TextStyle(
                                        color: Colors.white
                                    ),
                                    icon: Icon(Icons.person,
                                      color: Colors.white,
                                    ),
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                  validator: (value){
                                    if (value.isEmpty){
                                      return "Name cannot be empty";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Material(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white.withOpacity(0.4),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: RadioListTile(
                                      groupValue: groupValue,
                                      onChanged: (e) => valueChanged(e),
                                      value: 'Male',
                                      title: Text('Male',
                                        style: TextStyle(
                                          color: Colors.white
                                        ),
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: RadioListTile(
                                      groupValue: groupValue,
                                      onChanged: (e) => valueChanged(e),
                                      value: 'Female',
                                      title: Text('Female',
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // email
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.4),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: ListTile(
                                title: TextFormField(
                                  controller: _emailTextController,
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    labelStyle: TextStyle(
                                        color: Colors.white
                                    ),
                                    icon: Icon(Icons.email,
                                      color: Colors.white,
                                    ),
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        color: Colors.white
                                    ),
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
                        ),

                        // password
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.4),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: ListTile(
                                title: TextFormField(
                                  controller: _passwordTextController,
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    labelStyle: TextStyle(
                                        color: Colors.white
                                    ),
                                    icon: Icon(Icons.lock_outline,
                                      color: Colors.white,
                                    ),
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                  obscureText: hidePass,
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
                                trailing: IconButton(
                                  icon: Icon(Icons.remove_red_eye),
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
                                ),
                              ),
                            ),
                          ),
                        ),

                        // confirm password
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.4),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: ListTile(
                                title: TextFormField(
                                  controller: _confirmpasswordTextController,
                                  decoration: InputDecoration(
                                    labelText: "Confirm Password",
                                    labelStyle: TextStyle(
                                        color: Colors.white
                                    ),
                                    icon: Icon(Icons.lock,
                                      color: Colors.white,
                                    ),
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                  obscureText: ConHidePass,
                                  validator: (value){
                                    if (value.isEmpty || _passwordTextController.text != value){
                                      return "Passwords don't match";
                                    }
                                    return null;
                                  },
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.remove_red_eye),
                                  onPressed: (){
                                    setState(() {
                                      if (ConHidePass){
                                        ConHidePass = false;
                                      }
                                      else{
                                        ConHidePass = true;
                                      }
                                    });
                                  },
                                ),
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
                              onPressed: ()async{
                                validateForm();
                              },
                              minWidth: MediaQuery.of(context).size.width,
                              child: Text('Sign up',
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
                          padding: const EdgeInsets.only(left: 70.0, top: 8.0),
                          child: Row(
                            children: <Widget>[
                              Text("Already have an account?",
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 2.0),
                                child: InkWell(
                                  child: Text(' Login!',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
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

  valueChanged(e){
    setState(() {
      if (e == 'Male'){
        groupValue = e;
        gender = e;
      }
      else if (e == 'Female'){
        groupValue = e;
        gender = e;
      }
    });
  }

  Future<void> validateForm()async{
    FormState formState = _formKey.currentState;
    bool isConnected;
    var conResult = await Connectivity().checkConnectivity();
    if (conResult == ConnectivityResult.mobile || conResult == ConnectivityResult.wifi){
      isConnected = true;
    }
    else{
      isConnected = false;
    }

    if (isConnected){
      if (formState.validate()){
        formState.reset();
        FirebaseUser user = await firebaseAuth.currentUser();
        setState(() {
          loading = true;
        });
        if (user == null){
          try{
            FirebaseUser currentUser = await firebaseAuth.createUserWithEmailAndPassword(
                email: _emailTextController.text, password: _passwordTextController.text)
                .then((user){
              Map value = {
                "username": _nameTextController.text,
                "email": _emailTextController.text,
                "userId": user.uid,
                "gender": gender
              };
              _userServices.createUser(value);
            });
          }
          catch (e){
            exists = true;
            print(e.toString());
          }
        }

        if (exists){
          setState(() {
            loading = false;
            exists = false;
          });
          Fluttertoast.showToast(msg: "User already exists");
        }
        else{
          preferences = await SharedPreferences.getInstance();
          await preferences.setBool("isLoggedIn", true);
          await preferences.setString("id", user.uid);
          await preferences.setString("username", user.displayName);
          await preferences.setString("email", user.email);
          await preferences.setString("id", user.photoUrl);

          setState(() {
            loading = false;
            exists = false;
          });
          print("something");
          Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) =>  MyHomePage()
          ));
        }
      }
    }
    else{
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
}
