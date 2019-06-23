
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:HnH/components/horizontal_listview.dart';
import 'package:HnH/components/products.dart';
import 'package:HnH/screens/cart.dart';
import './profile.dart';
import 'maps.dart';
import 'package:firebase_database/firebase_database.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences _preferences;
  String uid,
      uname = "",
      email = "",
      avatar;
  bool hasUID = false,
      isLoggedIn,
      loggedwithMail,
      loggedwithPhone;
  final UserUpdateInfo userUpdateInfo = UserUpdateInfo();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {

    super.initState();
    getValues();

  }

  Future<void> getValues() async {
    final FirebaseUser user = await auth.currentUser();
    _preferences = await SharedPreferences.getInstance();
    uid = await _preferences.getString("id") ?? null;
    isLoggedIn = await _preferences.getBool("isLoggedIn") ?? false;
    loggedwithMail = await _preferences.getBool("LoggedInwithMail") ?? false;
    loggedwithPhone = _preferences.getBool("LoginPhone") ?? false;
    setState(() async{
      if (uid != null) { // for google sign in
        uname = user.displayName;
        email = user.email;
        avatar = user.photoUrl;
      }
      else if (isLoggedIn) { // for email(signup)
        uname = user.displayName != null
            ? user.displayName.toString()
            : await _preferences.getString("SignUname");

        email =
        user.email != null ? user.email.toString() : await _preferences.getString(
            "SignEmail");
        avatar = user.photoUrl != null
            ? user.photoUrl.toString()
            : "https://cdn4.iconfinder.com/data/icons/avatars-gray/500/avatar-12-512.png";
      }
      else if (loggedwithMail) { // for email(login)
        print("hello" + user.displayName);
        uname = user.displayName != null
            ? user.displayName.toString()
            : await _preferences.getString("LogUname");
        email =
        user.email != null ? user.email.toString() : await _preferences.getString(
            "SignEmail");
        avatar = user.photoUrl != null
            ? user.photoUrl.toString()
            : "https://cdn4.iconfinder.com/data/icons/avatars-gray/500/avatar-12-512.png";
      }
      else if (loggedwithPhone) { // for phone
        uname = user.displayName != null
            ? user.displayName.toString()
            : await _preferences.getString("Phone");
        avatar = user.photoUrl != null
            ? user.photoUrl.toString()
            : "https://cdn4.iconfinder.com/data/icons/avatars-gray/500/avatar-12-512.png";
      }
      else {
        uname = "Guest User";
        email = "guest@example.com";
      }

    });


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
    Widget image_carousel = new Container(
      height: 200.0,
      child: Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('images/products/fruits1.jpg'),
          AssetImage('images/products/veg1.jpeg'),
          AssetImage('images/products/daily1.jpg'),
          AssetImage('images/products/med1.jpg'),
          AssetImage('images/products/cos1.jpg'),
        ],
        autoplay: false,
        dotSize: 4.0,
        indicatorBgPadding: 8.0,
        dotBgColor: Colors.transparent,
        //animationCurve: Curves.fastOutSlowIn,
        //animationDuration: Duration(milliseconds: 1000),
      ),
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.pinkAccent,
          title: Text('Half n Hour',
            style: TextStyle(
              fontWeight: FontWeight.bold
          ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                  Icons.search
              ),
              color: Colors.white,
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                  Icons.shopping_cart
              ),
              color: Colors.white,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Cart()
                ));
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              // header
              UserAccountsDrawerHeader(
                accountName: Text(uname),
                accountEmail: Text(email),
                currentAccountPicture: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Account()
                      ));
                    },
                    child: ClipOval(
                      child: CachedNetworkImage(
                        placeholder: (context, val) =>
                            CircularProgressIndicator(),
                        imageUrl: avatar != null
                            ? avatar
                            : "https://cdn4.iconfinder.com/data/icons/avatars-gray/500/avatar-12-512.png",
                      ),
                    )
                ),
                decoration: BoxDecoration(
                    color: Colors.pinkAccent
                ),
              ),
              // body
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Account()
                  ));
                },
                child: ListTile(
                    title: Text('My Account'),
                    leading: Icon(Icons.person, color: Colors.pinkAccent,)
                ),
              ),
              InkWell(
                onTap: () {},
                child: ListTile(
                    title: Text('My Orders'),
                    leading: Icon(
                      Icons.shopping_basket, color: Colors.pinkAccent,)
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Cart()
                  ));
                },
                child: ListTile(
                    title: Text('My Cart'),
                    leading: Icon(Icons.shopping_cart, color: Colors.pinkAccent,)
                ),
              ),
              InkWell(
                onTap: () async {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Maps()
                  ));
                },
                child: ListTile(
                    title: Text('Maps'),
                    leading: Icon(Icons.map, color: Colors.pinkAccent,)
                ),
              ),

              Divider(),

              InkWell(
                onTap: () {},
                child: ListTile(
                    title: Text('Settings'),
                    leading: Icon(Icons.settings, color: Colors.pinkAccent,)
                ),
              ), InkWell(
                onTap: () {},
                child: ListTile(
                    title: Text('About'),
                    leading: Icon(Icons.help, color: Colors.pinkAccent,)
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            image_carousel,
            Padding(
              //padding widget
                padding: const EdgeInsets.all(4.0),
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Categories'))
            ),

            // Horizontal List View begins here
            HorizontalList(),

            Padding(
              //padding widget
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Recent Products'))
            ),

            Flexible(
              child: Products(),
            )
          ],
        ),
      ),
    );
  }
}
