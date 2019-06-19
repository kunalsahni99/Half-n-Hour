import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import '../db/users.dart';
import './home_page.dart';
import './login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  ShapeBorder shape;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  UserServices _userServices = UserServices();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _firstnameTextController = TextEditingController();
  TextEditingController _lastnameTextController = TextEditingController();
  TextEditingController _phoneTextController = TextEditingController();

  String _email;
  String _password;
  String _firstname;
  String _lastname;
  String _phone;
  String gender, groupValue = 'male';

  SharedPreferences preferences;
  bool loading = false, hidePass = true, exists = false;
  bool _autovalidate = false;
  bool _formWasEdited = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    bool _obscureText = true;
    return new Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Half n Hour",
            style: TextStyle(
              color: Colors.black87
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
              color: Colors.black87,
            ),
            onPressed: () => Navigator.pop(context),
          ),
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
                            Navigator.pop(context);
                          },
                          child: new Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black26,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        _verticalD(),
                        new GestureDetector(
                          onTap: () {
                            /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => signup_screen()));*/
                          },
                          child: new Text(
                            'Signup',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black87,
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
                                            controller: _firstnameTextController,
                                            decoration: const InputDecoration(
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black87,style: BorderStyle.solid),
                                                ),
                                                focusedBorder:  UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black87,style: BorderStyle.solid),
                                                ),
                                                icon: Icon(Icons.person,color: Colors.black38,),
                                                labelText: 'First Name',
                                                labelStyle: TextStyle(color: Colors.black54)
                                            ),
                                            keyboardType: TextInputType.text,
                                            validator: (val) =>
                                            val.length < 1 ? 'Enter first name' : null,
                                            onSaved: (val) => _firstname = val,
                                          ),
                                          const SizedBox(height: 24.0),
                                          TextFormField(
                                            controller: _lastnameTextController,
                                            decoration: const InputDecoration(
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black87,style: BorderStyle.solid),
                                                ),
                                                focusedBorder:  UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black87,style: BorderStyle.solid),
                                                ),
                                                icon: Icon(Icons.perm_identity,color: Colors.black38,),
                                                labelText: 'Last Name',
                                                labelStyle: TextStyle(color: Colors.black54)
                                            ),
                                            keyboardType: TextInputType.text,
                                            validator: (val) =>
                                            val.length < 1 ? 'Enter last name' : null,
                                            onSaved: (val) => _lastname = val,
                                          ),
                                          const SizedBox(height: 24.0),
                                          TextFormField(
                                            controller: _emailTextController,
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
                                            validator: validateEmail,
                                            onSaved: (String val) {
                                              _email = val;
                                            },
                                          ),

                                          const SizedBox(height: 24.0),
                                          TextFormField(
                                            controller:  _phoneTextController,
                                            decoration: const InputDecoration(
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black87,style: BorderStyle.solid),
                                                ),
                                                focusedBorder:  UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black87,style: BorderStyle.solid),
                                                ),
                                                icon: Icon(Icons.phone_android,color: Colors.black38,),
                                                labelText: 'Phone',
                                                labelStyle: TextStyle(color: Colors.black54)
                                            ),
                                            keyboardType: TextInputType.phone,
                                            validator: validateMobile,
                                            onSaved: (String val) {
                                              _phone = val;
                                            },
                                          ),
                                          const SizedBox(height: 24.0),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                child: TextFormField(
                                                  controller: _passwordTextController,
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
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: <Widget>[

                                                new Container(
                                                  alignment: Alignment.bottomRight,
                                                  child: new InkWell(
                                                    splashColor: Colors.pinkAccent,
                                                    onTap: (){
                                                      validateForm();
                                                    },
                                                    child: Text('SIGNUP',style: TextStyle(
                                                        color: Colors.pinkAccent,fontSize: 20.0,fontWeight: FontWeight.bold
                                                    ),),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
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
                  ),
                ],
              ),
            )
        ));
  }
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
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
                "username": _firstnameTextController.text + " " + _lastnameTextController.text,
                "email": _emailTextController.text,
                "phone": _phoneTextController.text,
                "photoUrl": user.photoUrl ?? "https://cdn4.iconfinder.com/data/icons/avatars-gray/500/avatar-12-512.png"
              };
              _userServices.createUser(user.uid, value);
            });
          }
          on PlatformException catch(e){
            setState(() {
              exists = true;
            });
            print(e.toString());
          }
          on NullThrownError catch(E){
            print(E.toString());
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

          setState(() {
            loading = false;
            exists = false;
          });
          print("something");

          await preferences.setString("SignUname", (_firstnameTextController.text + " " + _lastnameTextController.text));
          await preferences.setString("SignEmail", _emailTextController.text);
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
  _verticalD() => Container(
    margin: EdgeInsets.only(left: 40.0),
  );

}
