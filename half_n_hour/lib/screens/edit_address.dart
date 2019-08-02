import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' as foundation;

import '../components/single_address.dart';
import 'check_out.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class EditAddress extends StatefulWidget {
  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  String address1Line1 = "", address1Line2 = "", address1pin = "";
  String address2Line1 = "", address2Line2 = "", address2pin = "";
  String username = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  SharedPreferences _preferences;
  int delAdd;
  bool isLoading;

  TextEditingController _address1Line1Controller = new TextEditingController();
  TextEditingController _address1Line2Controller = new TextEditingController();
  TextEditingController _pincode1Controller = new TextEditingController();

  TextEditingController _address2Line1Controller = new TextEditingController();
  TextEditingController _address2Line2Controller = new TextEditingController();
  TextEditingController _pincode2Controller = new TextEditingController();
  final Form1Key = GlobalKey<FormState>();
  final Form2Key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getPrefs();
    setState(() {
      isLoading = true;
    });
    Timer(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void getPrefs() async {
    _preferences = await SharedPreferences.getInstance();
    final FirebaseUser user = await auth.currentUser();

    address1Line1 = _preferences.getString("address1Line1") ?? "";
    address1Line2 = _preferences.getString("address1Line2") ?? "";
    address1pin = _preferences.getString("address1pin") ?? "";

    address2Line1 = _preferences.getString("address2Line1") ?? "";
    address2Line2 = _preferences.getString("address2Line2") ?? "";
    address2pin = _preferences.getString("address2pin") ?? "";

    delAdd = _preferences.getInt("DelAdd") ?? 1;
    setState(() {
      username = user.displayName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Address',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5.0),
          ),
          showAddress(),
          Container(
            alignment: Alignment.center,
            child: Visibility(
              visible: isLoading,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget showAddress() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () async{
              if (address1Line1 != ""){
                await _preferences.setInt("DelAdd", 1);
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => CheckOut()
                ));
              }
              else{
                addAddress1(false);
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 2.5,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: (address1Line1 != "") ?
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                                child: SingleAddress(
                                  addLine1: address1Line1,
                                  addLine2: address1Line2,
                                  pin: address1pin,
                                  Uname: username,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.topRight,
                                padding: EdgeInsets.only(left: isIOS ? 100.0 : 60.0),
                                child: IconButton(
                                    icon: Icon(Icons.edit,
                                      color: Colors.black54,
                                    ),
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
                                  color: Colors.black87,
                                  size: 30.0,
                                ),
                                onPressed: ()async{
                                  addAddress1(false);
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
                        ),
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.all(20.0),
            child: Divider(),
          ),

          InkWell(
            onTap: () async{
              if (address2Line1 != ""){
                await _preferences.setInt("DelAdd", 2);
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => CheckOut()
                ));
              }
              else{
                addAddress2(false);
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 2.5,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                ),
                child: (address2Line1 != "") ?
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                        child: SingleAddress(
                          addLine1: address2Line1,
                          addLine2: address2Line2,
                          pin: address2pin,
                          Uname: username,
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.topRight,
                        padding: EdgeInsets.only(left: isIOS ? 100.0 : 60.0),
                        child: IconButton(
                            icon: Icon(Icons.edit,
                              color: Colors.black54,
                            ),
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
                          color: Colors.black87,
                          size: 30.0,
                        ),
                        onPressed: ()async{
                          addAddress2(false);
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
                ),
              ),
            ),
          )
        ],
      ),
    );
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
                title: Text(isEdit ? "Edit" : "Add new address"),
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
                    child: Text(isEdit ? "Edit" : "Add"),
                    onPressed: ()async{
                      Navigator.pop(context);
                      setState(() {
                        isLoading = true;
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
                          isLoading = false;
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
                    child: Text(isEdit ? "Edit" : "Add"),
                    onPressed: ()async{
                      Navigator.pop(context);
                      setState(() {
                        isLoading = true;
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
                          isLoading = false;
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
}
