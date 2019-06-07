import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:HnH/components/horizontal_listview.dart';
import 'package:HnH/components/products.dart';
import 'package:HnH/screens/cart.dart';
import './profile.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences _preferences;
  String uid = "", uname = "", email ="", avatar = "";
  bool hasUID = false;

  @override
  void initState() {
    super.initState();
    getValues();
  }

  void getValues()async{
    _preferences = await SharedPreferences.getInstance();
    uid = _preferences.getString("id");
    
    if (uid.isNotEmpty){
      uname = _preferences.getString("username") ?? 'Guest User';
      email = _preferences.getString("email") ?? 'guest@example.com';
      avatar = _preferences.getString("photoUrl");
      hasUID = true;
    }
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
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.pinkAccent,
        title: Text('Half n Hour'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search
            ),
            color: Colors.white,
            onPressed: (){},
          ),
          IconButton(
            icon: Icon(
              Icons.shopping_cart
            ),
            color: Colors.white,
            onPressed: (){
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
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Profile()
                  ));
                },
                child: ClipOval(
                  child: CachedNetworkImage(
                    placeholder: (context, val) => CircularProgressIndicator(),
                    imageUrl: avatar,
                  ),
                )
              ),
              decoration: BoxDecoration(
                color: Colors.pinkAccent
              ),
            ),
            // body
            InkWell(
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Profile()
                ));
              },
              child: ListTile(
                title: Text('My Account'),
                leading: Icon(Icons.person, color: Colors.pinkAccent,)
              ),
            ),
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('My Orders'),
                leading: Icon(Icons.shopping_basket, color: Colors.pinkAccent,)
              ),
            ),
            InkWell(
              onTap: (){
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
              onTap: (){},
              child: ListTile(
                title: Text('Favourites'),
                leading: Icon(Icons.favorite, color: Colors.pinkAccent,)
              ),
            ),

            Divider(),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Settings'),
                leading: Icon(Icons.settings, color: Colors.pinkAccent,)
              ),
            ),InkWell(
              onTap: (){},
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
    );
  }
}
