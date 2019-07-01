import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'login.dart';
import 'package:flutter/foundation.dart' as foundation;

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();

}

class _AccountState extends State<Account> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  bool isLoggedIn = false, isSignUpWithEmail, isLoggedwithEmail, isLoggedWithPhone;
  String UID, url;
  bool loading = false;
  File _image;
  String avatar="",uname="Guest User",eid="guest@example.com",pno="";
  String address1Line1 = "", address1Line2 = "", address1pin = "";
  String address2Line1 = "", address2Line2 = "", address2pin = "";
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final UserUpdateInfo userUpdateInfo = UserUpdateInfo();
  final FirebaseAuth auth = FirebaseAuth.instance;

  final Form1Key = GlobalKey<FormState>();
  final Form2Key = GlobalKey<FormState>();
  final Form3Key = GlobalKey<FormState>();

  TextEditingController _address1Line1Controller = new TextEditingController();
  TextEditingController _address1Line2Controller = new TextEditingController();
  TextEditingController _pincode1Controller = new TextEditingController();

  TextEditingController _address2Line1Controller = new TextEditingController();
  TextEditingController _address2Line2Controller = new TextEditingController();
  TextEditingController _pincode2Controller = new TextEditingController();

  TextEditingController _changeNameController = new TextEditingController();
  SharedPreferences _preferences;
  bool checkboxValueA ,  checkboxValueB ,a1,a2;

  @override
  void initState(){
    super.initState();
    getPrefs();

    checkboxValueA=a1??true;
    checkboxValueB=a2??false;
  }

  Future<Null> getPrefs() async {
    _preferences = await SharedPreferences.getInstance();
    final FirebaseUser user = await auth.currentUser();

    setState(() {
      url = user.photoUrl ??
          "https://cdn4.iconfinder.com/data/icons/avatars-gray/500/avatar-12-512.png";
      uname = user.displayName;
      eid = user.email != null ? user.email.toString() : _preferences.getString("Phone");
      address1Line1 = _preferences.getString("address1Line1") ?? "";
      address1Line2 = _preferences.getString("address1Line2") ?? "";
      address1pin = _preferences.getString("address1pin") ?? "";

      address2Line1 = _preferences.getString("address2Line1") ?? "";
      address2Line2 = _preferences.getString("address2Line2") ?? "";
      address2pin = _preferences.getString("address2pin") ?? "";
      a1 = _preferences.getBool("a1") ?? true;
      a2 = _preferences.getBool("a2") ?? false;
    });
  }

  Future _signOut()async{
    try{final FirebaseUser user = await auth.currentUser();
    isLoggedIn = await _googleSignIn.isSignedIn();       // google sign in
    isSignUpWithEmail = await _preferences.getBool("isLoggedIn") ?? false;  // email sign up
    isLoggedwithEmail = await _preferences.getBool("LoggedInwithMail")?? false;  // email log in
    isLoggedWithPhone = await _preferences.getBool("loggedwithPhone") ?? false;  // phone login in
    UID = await _preferences.getString("id") ?? "";
    await _auth.signOut();

    if (isLoggedIn){
      await _googleSignIn.signOut();
      _preferences.remove("id");
      _preferences.remove("username");
      _preferences.remove("email");
      _preferences.remove("photoUrl");
      _preferences.remove("address1Line1");
      _preferences.remove("address1Line2");
      _preferences.remove("address1pin");

      _preferences.remove("address2Line1");
      _preferences.remove("address2Line2");
      _preferences.remove("address2pin");
    }
    else if (isSignUpWithEmail){
      _preferences.setBool("isLoggedIn", false);
      _preferences.remove("SignUname");
      _preferences.remove("SignEmail");
      _preferences.remove("photoUrl");
      _preferences.remove("address1Line1");
      _preferences.remove("address1Line2");
      _preferences.remove("address1pin");

      _preferences.remove("address2Line1");
      _preferences.remove("address2Line2");
      _preferences.remove("address2pin");
    }
    else if (isLoggedwithEmail){
      _preferences.setBool("LoggedInwithMail", false);
      _preferences.remove("LogUname");
      _preferences.remove("photoUrl");
      _preferences.remove("address1Line1");
      _preferences.remove("address1Line2");
      _preferences.remove("address1pin");

      _preferences.remove("address2Line1");
      _preferences.remove("address2Line2");
      _preferences.remove("address2pin");
    }
    else if (isLoggedWithPhone){
      _preferences.setBool("loggedwithPhone", false);
      _preferences.remove("Phone");
      _preferences.remove("photoUrl");
      _preferences.remove("address1Line1");
      _preferences.remove("address1Line2");
      _preferences.remove("address1pin");

      _preferences.remove("address2Line1");
      _preferences.remove("address2Line2");
      _preferences.remove("address2pin");
    }
    else{
      Fluttertoast.showToast(msg: "You need to login first",
          fontSize: 14.0,
          backgroundColor: Colors.black87
      );
    }
    }
    catch (e){
      e.toString();
    }
  }

  addAddress1(bool isEdit){
    showGeneralDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget){
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                ),
                title: Text(isEdit ? "Edit" : "Add new address  "),
                content: Form(
                  key: Form1Key,
                  child: Container(
                    height: MediaQuery.of(context).size.height/3.5,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _address1Line1Controller,
                          decoration: InputDecoration(
                              hintText: "House No.",
                              helperText: "Ex: 23-C, MIG Flats",
                              hintMaxLines: 2
                          ),
                          validator: (val) => val.length == 0 ? "Enter valid address" : null,
                        ),
                        TextFormField(
                          controller: _address1Line2Controller,
                          decoration: InputDecoration(
                              hintText: "Sector, City",
                              helperText: "Ex: Sector-82, Noida",
                              hintMaxLines: 2
                          ),
                          validator: (val) => val.length == 0 ? "Enter valid address" : null,
                        ),
                        TextFormField(
                          controller: _pincode1Controller,
                          decoration: InputDecoration(
                              hintText: "Pincode",
                              helperText: "Ex: 201304",
                              hintMaxLines: 2
                          ),
                          validator: (val) => val.length != 6 ? "Enter valid pincode" : null,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Add"),
                    onPressed: ()async{
                      Navigator.pop(context);
                      setState(() {
                        loading = true;
                      });
                      FormState formState = Form1Key.currentState;
                      final FirebaseUser _user = await auth.currentUser();
                      final FirebaseDatabase _db = FirebaseDatabase.instance;

                      if (formState.validate()){
                        formState.save();
                        _db.reference().child("users").child(_user.uid).once().then((DataSnapshot snapshot){
                          if (snapshot.value != null){
                            _db.reference().child("users").child(_user.uid)
                                .update({
                              "address_1Line1": _address1Line1Controller.text,
                              "address_1Line2": _address1Line2Controller.text,
                              "address_1pin": _pincode1Controller.text
                            });
                            print("address1 updated");
                          }
                          else{
                            _db.reference().child("users").child(_user.uid)
                                .set({
                              "username": _user.displayName,
                              "email": _user.email,
                              "address_1Line1": _address1Line1Controller.text,
                              "address_1Line2": _address1Line2Controller.text,
                              "address_1pin": _pincode1Controller.text,
                              "phone": _user.phoneNumber,
                              "photoUrl": _user.photoUrl ??
                                  "https://cdn4.iconfinder.com/data/icons/avatars-gray/500/avatar-12-512.png"
                            });
                            print("address1 added");
                          }
                        });
                        _preferences.setString("address1Line1", _address1Line1Controller.text);
                        _preferences.setString("address1Line2", _address1Line2Controller.text);
                        _preferences.setString("address1pin", _pincode1Controller.text);
                        setState(() {
                          loading = false;
                          address1Line1 = _address1Line1Controller.text;
                          address1Line2 = _address1Line2Controller.text;
                          address1pin = _pincode1Controller.text;
                        });
                      }
                      else{
                        Fluttertoast.showToast(msg: "Enter valid details");
                      }
                    },
                  ),
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: "",
        pageBuilder: (context, animation1, animation2){}
    );
  }

  addAddress2(bool isEdit){
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        transitionBuilder: (context, a1, a2, widget){
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                ),
                title: Text(isEdit ? "Edit" : "Address new address"),
                content: Form(
                  key: Form2Key,
                  child: Container(
                    height: MediaQuery.of(context).size.height/3.5,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _address2Line1Controller,
                          decoration: InputDecoration(
                              hintText: "House No.",
                              helperText: "Ex: 23-C, MIG Flats",
                              hintMaxLines: 2
                          ),
                          validator: (val) => val.length == 0 ? "Enter valid address" : null,
                        ),
                        TextFormField(
                          controller: _address2Line2Controller,
                          decoration: InputDecoration(
                              hintText: "Sector, City",
                              helperText: "Ex: Sector-82, Noida",
                              hintMaxLines: 2
                          ),
                          validator: (val) => val.length == 0 ? "Enter valid address" : null,
                        ),
                        TextFormField(
                          controller: _pincode2Controller,
                          decoration: InputDecoration(
                              hintText: "Pincode",
                              helperText: "Ex: 201304",
                              hintMaxLines: 2
                          ),
                          validator: (val) => val.length != 6 ? "Enter valid pincode" : null,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Add"),
                    onPressed: ()async{
                      Navigator.pop(context);
                      setState(() {
                        loading = true;
                      });
                      FormState formState = Form2Key.currentState;
                      final FirebaseUser _user = await auth.currentUser();
                      final FirebaseDatabase _db = FirebaseDatabase.instance;

                      if (formState.validate()){
                        formState.save();
                        _db.reference().child("users").child(_user.uid).once().then((DataSnapshot snapshot){
                          if (snapshot.value != null){
                            _db.reference().child("users").child(_user.uid)
                                .update({
                              "address_2Line1": _address2Line1Controller.text,
                              "address_2Line2": _address2Line2Controller.text,
                              "address_2pin": _pincode2Controller.text
                            });
                            print("address2 updated");
                          }
                          else{
                            _db.reference().child("users").child(_user.uid)
                                .set({
                              "username": _user.displayName,
                              "email": _user.email,
                              "address_2Line1": _address2Line1Controller.text,
                              "address_2Line2": _address2Line2Controller.text,
                              "address_2pin": _pincode2Controller.text,
                              "phone": _user.phoneNumber,
                              "photoUrl": _user.photoUrl ??
                                  "https://cdn4.iconfinder.com/data/icons/avatars-gray/500/avatar-12-512.png"
                            });
                            print("address2 added");
                          }
                        });
                        _preferences.setString("address2Line1", _address2Line1Controller.text);
                        _preferences.setString("address2Line2", _address2Line2Controller.text);
                        _preferences.setString("address2pin", _pincode2Controller.text);
                        setState(() {
                          loading = false;
                          address2Line1 = _address2Line1Controller.text;
                          address2Line2 = _address2Line2Controller.text;
                          address2pin = _pincode2Controller.text;
                        });
                      }
                      else{
                        Fluttertoast.showToast(msg: "Enter valid details");
                      }
                    },
                  ),
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: "",
        pageBuilder: (context, animation1, animation2){}
    );
  }
  changeName(bool isEdit){
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        transitionBuilder: (context, a1, a2, widget){
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
                ),
                title: Text(isEdit ? "Edit" : "Change Name"),
                content: Form(
                  key: Form3Key,
                  child: Container(
                    height: MediaQuery.of(context).size.height/10,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _changeNameController,
                          decoration: InputDecoration(
                              hintText: "Name ",
                              helperText: "Ex: Paul Walker",
                              hintMaxLines: 2
                          ),
                          validator: (val) => val.length == 0 ? "Enter Valid Name" : null,
                        ),

                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Add"),
                    onPressed: ()async{
                      Navigator.pop(context);
                      setState(() {
                        loading = true;
                      });
                      FormState formState = Form3Key.currentState;
                      final FirebaseUser _user = await auth.currentUser();
                      final FirebaseDatabase _db = FirebaseDatabase.instance;

                      if (formState.validate()){
                        formState.save();
                        final UserUpdateInfo userUpdateInfo = UserUpdateInfo();
                        userUpdateInfo.displayName = _changeNameController.text;

                        await _user.updateProfile(userUpdateInfo);

                      }
                      else{
                        Fluttertoast.showToast(msg: "Enter valid name");
                      }
                    },
                  ),
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: "",
        pageBuilder: (context, animation1, animation2){}
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Icon ofericon = new Icon(
      Icons.edit,
      color: Colors.black38,
    );
    Icon keyloch = new Icon(
      Icons.vpn_key,
      color: Colors.black38,
    );
    Icon clear = new Icon(
      Icons.history,
      color: Colors.black38,
    );
    Icon logout = new Icon(
      Icons.do_not_disturb_on,
      color: Colors.black38,
    );

    return new Scaffold(
      appBar: new AppBar(
        title: Text('My Account',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87
          ),
        ),
        backgroundColor: Colors.white70,
        leading: IconButton(
          icon: Icon(isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: new Container(
          child: SingleChildScrollView(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.ltr,
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.all(7.0),
                    alignment: Alignment.topCenter,
                    height: 260.0,
                    child: new Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      elevation: 3.0,
                      child: Column(
                        children: <Widget>[
                          new Container(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: 100.0,
                                height: 100.0,
                                margin: const EdgeInsets.all(10.0),
                                // padding: const EdgeInsets.all(3.0),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    placeholder: (context, val) => CircularProgressIndicator(),
                                    imageUrl: url != null ? url : "https://cdn4.iconfinder.com/data/icons/avatars-gray/500/avatar-12-512.png",
                                  ),
                                ),
                              )),

                          new FlatButton(
                            onPressed: ()async{
                              final FirebaseUser User = await _auth.currentUser();
                              if (User != null){
                                _selectAndUploadPicture();
                              }
                              else{
                                Fluttertoast.showToast(msg: "You need to login first");
                              }
                            },
                            child: Text(
                              'Gallery',
                              style:
                              TextStyle(fontSize: 16.0, color: Colors.blueAccent,fontWeight: FontWeight.bold
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                                side: BorderSide(color: Colors.blueAccent)),
                            color: Colors.white,

                          ),
                          new FlatButton(
                            onPressed: ()async{
                              final FirebaseUser User = await _auth.currentUser();
                              if (User != null){
                                _takeAndUploadPicture();
                              }
                              else{
                                Fluttertoast.showToast(msg: "You need to login first");
                              }
                            },
                            child: Text(
                              'Camera',
                              style:
                              TextStyle(fontSize: 16.0, color: Colors.blueAccent,fontWeight: FontWeight.bold
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                                side: BorderSide(color: Colors.blueAccent)),
                            color: Colors.white,

                          ),

                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Container(
                                margin: EdgeInsets.only(
                                    left: 10.0, top: 20.0, right: 5.0, bottom: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    new Text (
                                      uname,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    _verticalDivider(),

                                    new Text(
                                      eid,
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5),
                                    )
                                  ],
                                ),
                              ),
                              new Container(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                    icon: ofericon,
                                    color: Colors.blueAccent,
                                    onPressed: ()async{  final FirebaseUser _user = await auth.currentUser();
                                    if (_user != null){
                                      changeName(true);
                                    }
                                    else{
                                      Fluttertoast.showToast(msg: "You need to login first");
                                    }

                                    })
                                ,
                              )
                            ],
                          ),
                          // VerticalDivider(),
                        ],
                      ),
                    ),
                  ),
                  new Container(
                    margin:
                    EdgeInsets.only(left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
                    child: new Text(
                      'Addresses',
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  new Container(
                      height: MediaQuery.of(context).size.width/1.75,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width/1.25,
                            margin: EdgeInsets.all(7.0),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)
                                ),
                                elevation: 3.0,
                                child:  address1Line1 != "" ?
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Column(
                                      children: <Widget>[
                                        new Container(
                                          margin: EdgeInsets.only(left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              new Text(
                                                uname,
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              _verticalDivider(),
                                              new Text(
                                                address1Line1,
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 13.0,
                                                    letterSpacing: 0.5),
                                              ),
                                              _verticalDivider(),
                                              new Text(
                                                address1Line2,
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 13.0,
                                                    letterSpacing: 0.5),
                                              ),
                                              _verticalDivider(),
                                              new Text(
                                                address1pin,
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 13.0,
                                                    letterSpacing: 0.5),
                                              ),

                                              Padding(
                                                padding: EdgeInsets.only(top: 10.0),
                                              ),

                                              new Container(
                                                margin: EdgeInsets.only(left: 00.0,top: 05.0,right: 0.0,bottom: 5.0),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    new Text(
                                                      'Delivery Address',
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.black26,
                                                      ),

                                                    ),
                                                    _verticalD(),

                                                    Switch(
                                                      value: checkboxValueA,
                                                      onChanged: (bool value)async{
                                                        setState(() {
                                                          checkboxValueA= a1 = value;
                                                          checkboxValueB=a2=!checkboxValueA;
                                                        });
                                                        await _preferences.setBool("a1", checkboxValueA);
                                                        await _preferences.setBool("a2", checkboxValueB);
                                                      },
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    new Container(
                                      alignment: Alignment.topRight,
                                      padding: EdgeInsets.only(left: isIOS ? 100.0 : 60.0),
                                      child: IconButton(
                                          icon: ofericon,
                                          color: Colors.black38,
                                          onPressed: ()async{
                                            final FirebaseUser _user = await auth.currentUser();
                                            if (_user != null){
                                              addAddress1(true);
                                            }
                                            else{
                                              Fluttertoast.showToast(msg: "You need to login first");
                                            }
                                          }
                                      ),
                                    )
                                  ],
                                ) :
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.add_circle,
                                          color: Colors.pinkAccent,
                                          size: 30.0,
                                        ),
                                        onPressed: ()async{
                                          final FirebaseUser _user = await auth.currentUser();
                                          if (_user != null){
                                            addAddress1(false);
                                          }
                                          else{
                                            Fluttertoast.showToast(msg: "You need to login first");
                                          }
                                        },
                                      ),
                                      Text("Add address",
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 13.0,
                                            letterSpacing: 0.5,
                                          )
                                      )
                                    ],
                                  ),
                                )
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width/1.25,
                            margin: EdgeInsets.all(7.0),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)
                                ),
                                elevation: 3.0,
                                child: address2Line1 != "" ?
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Column(
                                      children: <Widget>[
                                        new Container(
                                          margin:
                                          EdgeInsets.only(left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,

                                            children: <Widget>[
                                              new Text(
                                                uname,
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              _verticalDivider(),
                                              new Text(
                                                address2Line1,
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 13.0,
                                                    letterSpacing: 0.5),
                                              ),
                                              _verticalDivider(),
                                              new Text(
                                                address2Line2,
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 13.0,
                                                    letterSpacing: 0.5),
                                              ),
                                              _verticalDivider(),
                                              new Text(
                                                address2pin,
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 13.0,
                                                    letterSpacing: 0.5),
                                              ),

                                              Padding(
                                                padding: EdgeInsets.only(top: 10.0),
                                              ),
                                              new Container(
                                                margin: EdgeInsets.only(left: 00.0,top: 05.0,right: 0.0,bottom: 5.0),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    new Text(
                                                      'Delivery Address',
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.black26,
                                                      ),

                                                    ),
                                                    _verticalD(),

                                                    Switch(
                                                      value: checkboxValueB,
                                                      onChanged: (bool value)async{
                                                        setState(() {
                                                          print(value);
                                                          checkboxValueB=a2=value;

                                                          print(checkboxValueB);
                                                          checkboxValueA=a1=!checkboxValueB;
                                                        });
                                                        await _preferences.setBool("a1", checkboxValueA);
                                                        await _preferences.setBool("a2", checkboxValueB);
                                                      },
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                    new Container(
                                      alignment: Alignment.topRight,
                                      padding: EdgeInsets.only(left: isIOS ? 100.0 : 60.0),
                                      child: IconButton(
                                          icon: ofericon,
                                          color: Colors.black38,
                                          onPressed: ()async{
                                            final FirebaseUser _user = await auth.currentUser();
                                            if (_user != null){
                                              addAddress2(true);
                                            }
                                            else{
                                              Fluttertoast.showToast(msg: "You need to login first");
                                            }
                                          }
                                      ),
                                    )
                                  ],
                                ) :
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.add_circle,
                                          color: Colors.pinkAccent,
                                          size: 30.0,
                                        ),
                                        onPressed: ()async{
                                          final FirebaseUser _user = await auth.currentUser();
                                          if (_user != null){
                                            addAddress2(false);
                                          }
                                          else{
                                            Fluttertoast.showToast(msg: "You need to login first");
                                          }
                                        },
                                      ),
                                      Text("Add address",
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 13.0,
                                            letterSpacing: 0.5,
                                          )
                                      )
                                    ],
                                  ),
                                )
                            ),
                          ),
                        ],
                      )
                  ),
                  new GestureDetector(
                    onTap: () async{
                      try{
                        final FirebaseUser _user = await auth.currentUser();
                        String email = _user.email;

                        await firebaseAuth.sendPasswordResetEmail(email:email);

                        Fluttertoast.showToast(msg: "Check Your Email",
                            fontSize: 14.0,
                            backgroundColor: Colors.black87
                        );

                      }
                      catch (e){
                        Fluttertoast.showToast(msg: "User Not Found",
                            fontSize: 14.0,
                            backgroundColor: Colors.black87
                        );
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                      ),
                      elevation: 3.0,
                      child: Row(
                        children: <Widget>[
                          new IconButton(icon: keyloch, onPressed:(){ }),
                          _verticalD(),

                          new Text(
                            'Change Password',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  new GestureDetector(
                    onTap: (){_signOut();
                    Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => Login()
                    ));},
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                      ),
                      elevation: 4.0,
                      child: Row(
                        children: <Widget>[
                          new IconButton(icon: logout, onPressed:(){ }),
                          _verticalD(),

                          new Text(
                            'Log Out',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.redAccent,fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
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
              )
          )
      ),
    );
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(value)
    ));
  }

  Future _takeProfilePicture() async{
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState((){
      _image = image;
    });
  }

  Future _selectProfilePicture() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery).catchError((error){
      setState(() {
        loading = false;
      });
    });

    setState((){
      loading = true;
      _image = image;
    });
  }

  Future<void> _uploadProfilePicture() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String URL = "";

    final StorageReference ref = FirebaseStorage.instance.ref().child('users/${user.email}/${user.email}_profilePicture.jpg');
    final StorageUploadTask uploadTask = ref.putFile(_image);
    await uploadTask.onComplete.then((TaskSnapShot)async{
      URL = await TaskSnapShot.ref.getDownloadURL();
      userUpdateInfo.photoUrl=URL;
      final FirebaseUser user = await auth.currentUser();
      await user.updateProfile(userUpdateInfo);
      setState(() {
        url = URL;
        loading = false;
      });
    });

    print(URL.toString());
  }

  void _selectAndUploadPicture() async{
    await _selectProfilePicture();
    await _uploadProfilePicture();
  }

  void _takeAndUploadPicture() async{
    await _takeProfilePicture();
    await _uploadProfilePicture();
  }
  _verticalDivider() => Container(
    padding: EdgeInsets.all(3.0),
  );

  _verticalD() => Container(
    margin: EdgeInsets.only(left: 3.0, right: 0.0, top: 0.0, bottom: 0.0),

  );

}