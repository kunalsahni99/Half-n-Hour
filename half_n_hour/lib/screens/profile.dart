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
  String avatar;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final UserUpdateInfo userUpdateInfo = UserUpdateInfo();
  final FirebaseAuth auth = FirebaseAuth.instance;


  SharedPreferences _preferences;

  @override
  void initState(){
    super.initState();
    getPrefs();
  }

  Future<Null> getPrefs() async{
    _preferences = await SharedPreferences.getInstance();
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      url = user.photoUrl ?? "https://cdn4.iconfinder.com/data/icons/avatars-gray/500/avatar-12-512.png";
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
      }
      else if (isSignUpWithEmail){
        _preferences.setBool("isLoggedIn", false);
        _preferences.remove("SignUname");
        _preferences.remove("SignEmail");
        _preferences.remove("photoUrl");
      }
      else if (isLoggedwithEmail){
        _preferences.setBool("LoggedInwithMail", false);
        _preferences.remove("LogUname");
        _preferences.remove("photoUrl");
      }
      else if (isLoggedWithPhone){
        _preferences.setBool("loggedwithPhone", false);
        _preferences.remove("Phone");
        _preferences.remove("photoUrl");
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
  @override

  String username = "hbk";
  String mobilenumber = '410-422-9171';
  String eid = 'NaomiASchultz@armyspy.com';


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

    Icon menu = new Icon(
      Icons.more_vert,
      color: Colors.black38,
    );
    bool checkboxValueA = true;
    bool checkboxValueB = false;
    bool checkboxValueC = false;

    //List<address> addresLst = loadAddress() as List<address> ;
    return new Scaffold(
      appBar: new AppBar(
        title: Text(
          'My Account',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: new Container(
          child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height/10),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.ltr,
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.all(7.0),
                    alignment: Alignment.topCenter,
                    height: MediaQuery.of(context).size.height / 2.25,
                    child: new Card(
                      elevation: 3.0,
                      child: Column(
                        children: <Widget>[
                          new Container(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: 100.0,
                                height: 100.0,
                                margin: const EdgeInsets.all(10.0),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    placeholder: (context, val) => CircularProgressIndicator(),
                                    imageUrl: url != null ? url : "https://cdn4.iconfinder.com/data/icons/avatars-gray/500/avatar-12-512.png",
                                  ),
                                ),
                              )),

                          new FlatButton(
                            onPressed: _selectAndUploadPicture,
                            child: Text(
                              'Change',
                              style:
                              TextStyle(fontSize: 13.0, color: Colors.blueAccent),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                                side: BorderSide(color: Colors.blueAccent)),
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
                                      username,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    _verticalDivider(),
                                    new Text(
                                      mobilenumber,
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5),
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
                                    onPressed: null),
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
                      height: MediaQuery.of(context).size.width / 1.75,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(7.0),
                            child: Card(
                              elevation: 3.0,
                              child: Row(
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
                                              'Naomi A. Schultz',
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            _verticalDivider(),
                                            new Text(
                                              '2585 Columbia Boulevard',
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.5),
                                            ),
                                            _verticalDivider(),
                                            new Text(
                                              'Salisbury',
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.5),
                                            ),
                                            _verticalDivider(),
                                            new Text(
                                              ' MD 21801',
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.5),
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

                                                  new Checkbox(
                                                    value: checkboxValueA,
                                                    onChanged: (bool value) {
                                                      setState(() {
                                                        checkboxValueA = value;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),

                                            )

                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                  new Container(
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                        icon: menu,
                                        color: Colors.black38,
                                        onPressed: null),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 1.5,
                            width: MediaQuery.of(context).size.width / 1.5,
                            margin: EdgeInsets.all(7.0),
                            child: Card(
                              elevation: 3.0,
                              child: Row(
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
                                              'Bradford R. Butler',
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            _verticalDivider(),
                                            new Text(
                                              '4528 Filbert Street',
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.5),
                                            ),
                                            _verticalDivider(),
                                            new Text(
                                              'Philadelphia',
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.5),
                                            ),
                                            _verticalDivider(),
                                            new Text(
                                              ' PA 19103',
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.5),
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
                                                      fontSize: 15.0,
                                                      color: Colors.black12,
                                                    ),

                                                  ),
                                                  _verticalD(),

                                                  new Checkbox(
                                                    value: checkboxValueB,
                                                    onChanged: (bool value) {
                                                      setState(() {
                                                        checkboxValueB = value;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),

                                            )
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                  new Container(
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                        icon: menu,
                                        color: Colors.black38,
                                        onPressed: null),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width / 1.5,
                            margin: EdgeInsets.all(7.0),
                            child: Card(
                              elevation: 3.0,
                              child: Row(
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
                                              'Elizabeth J. Schmidt',
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            _verticalDivider(),
                                            new Text(
                                              '3674 Oakway Lane',
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.5),
                                            ),
                                            _verticalDivider(),
                                            new Text(
                                              'Long Beach',
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.5),
                                            ),
                                            _verticalDivider(),
                                            new Text(
                                              'CA 90802',
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.5),
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
                                                      fontSize: 15.0,
                                                      color: Colors.black12,
                                                    ),

                                                  ),
                                                  _verticalD(),

                                                  new Checkbox(
                                                    value: checkboxValueC,
                                                    onChanged: (bool value) {
                                                      setState(() {
                                                        checkboxValueC = value;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),

                                            )
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                  new Container(
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                        icon: menu,
                                        color: Colors.black38,
                                        onPressed: null),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  new GestureDetector(
                    onTap: () async{
                      try{
                        _preferences = await SharedPreferences.getInstance();
                        String email = await _preferences.getString("SignEmail");
                        if (email.isEmpty){
                          email = await _preferences.getString("LogUname");
                        }

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
    padding: EdgeInsets.all(5.0),
  );

  _verticalD() => Container(
    margin: EdgeInsets.only(left: 3.0, right: 0.0, top: 0.0, bottom: 0.0),

  );

}
