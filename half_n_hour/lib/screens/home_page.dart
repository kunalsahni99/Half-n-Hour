
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
import 'product_new.dart';
import 'product_popular.dart';

import 'package:firebase_database/firebase_database.dart';





import 'package:flutter/foundation.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;
const String _kGalleryAssetsPackage = 'flutter_gallery_assets';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new home();
// TODO: implement createState

}

class Photo {
  Photo({
    this.assetName,
    this.assetPackage,
    this.title,
    this.caption,
  });

  final String assetName;
  final String assetPackage;
  final String title;
  final String caption;
}

class home extends State<MyHomePage> {
  List list = ['12', '11'];

  List<Photo> photos = <Photo>[
    Photo(
      assetName: 'images/veg.jpg',
      title: 'Fruits & Vegetables',


    ),
    Photo(
      assetName: 'images/frozen.jpg',
      title: 'Frozen Veg',
    ),
    Photo(
      assetName: 'images/bev.jpg',
      title: 'Beverages',
    ),
    Photo(
      assetName: 'images/brand_f.jpg',
      title: 'Brannded Food',
    ),
    Photo(
      assetName: 'images/be.jpg',
      title: 'Beauty & Personal Care',
    ),
    Photo(
      assetName: 'images/home.jpg',
      title: 'Home Care & Fashion',
    ),
    Photo(
      assetName: 'images/nonveg.jpg',
      title: 'Non Veg',
    ),
    Photo(
      assetName: 'images/eggs.jpg',
      title: 'Dairy, Bakery & Eggs',
    ),
  ];
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

  final List<String> items = ['Balbhadra', 'Maulik', 'Roshi'];
  static const double height = 366.0;
  String name ='My Wishlist';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final Orientation orientation = MediaQuery.of(context).orientation;
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle =
    theme.textTheme.headline.copyWith(color: Colors.black54);
    final TextStyle descriptionStyle = theme.textTheme.subhead;
    ShapeBorder shapeBorder;
    Widget image_carousel = new Container(
      height: 200.0,
      child: Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('images/groceries.jpg'),
          AssetImage('images/grthre.jpg'),
          AssetImage('images/grtwo.jpg'),
          AssetImage('images/brand_f.jpg'),
          AssetImage('images/home.jpg'),
        ],
        autoplay: true,
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
      appBar: new AppBar(
        backgroundColor: Colors.white70,

        title: Text("Half n Hour",style: TextStyle(
        color: Colors.deepOrange,fontWeight: FontWeight.bold)),

        actions: <Widget>[
      IconButton(
      tooltip: 'Search',
        icon: const Icon(Icons.search),
        color: Colors.black,
        onPressed: () async {
          final int selected = await showSearch<int>(
            context: context,
            //delegate: _delegate,
          );

        },
      ),
      new Padding(
        padding: const EdgeInsets.all(10.0),
        child: new Container(
          height: 150.0,
          width: 30.0,
          child: new GestureDetector(
              onTap: () {
        Navigator.of(context).push(
        new MaterialPageRoute(
        builder:(BuildContext context) =>
        Cart()
        )
        );
        },
          child: Stack(
            children: <Widget>[
              new IconButton(
                  icon: new Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                  onPressed: (){
                    Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder:(BuildContext context) =>
                                Cart()
                        )
                    );
                  }),
              list.length == 0
                  ? new Container()
                  : new Positioned(
                  child: new Stack(
                    children: <Widget>[
                      new Icon(Icons.brightness_1,
                          size: 20.0, color: Colors.orange.shade500),
                      new Positioned(
                          top: 4.0,
                          right: 5.5,
                          child: new Center(
                            child: new Text(
                              list.length.toString(),
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          )),
                    ],
                  )),
            ],
          ),
        ),
      ),
    )
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
                      color: Colors.redAccent
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

    body: new SingleChildScrollView(
    child: Container(
    child: new Column(children: <Widget>[
        _verticalD(),
      image_carousel,



    new Container(
    margin: EdgeInsets.only(top: 7.0),
    child: new Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
    _verticalD(),
    new GestureDetector(
    onTap: () {

    },
    child: new Text(
    'Categories',
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
              builder: (context) => ProductPopular()));
    },
    child: new Text(
    'Popular',
    style: TextStyle(
    fontSize: 20.0,
    color: Colors.black26,
    fontWeight: FontWeight.bold),
    ),
    ),
    _verticalD(),
    new Row(
    children: <Widget>[
    new GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductNew()));
    },
    child: new Text(
    'Whats New',
    style: TextStyle(
    fontSize: 20.0,
    color: Colors.black26,
    fontWeight: FontWeight.bold),
    ),
    ),
    ],
    )
    ]),
    ),
    new Container(
    alignment: Alignment.topCenter,
    height: 700.0,

    child: new GridView.builder(
    itemCount: photos.length,
    primary: false,
    physics: NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.all(10.0),
    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2),
    itemBuilder: (BuildContext context, int index) {
    return new GestureDetector(
    onTap: (){


    },

    child: new Container(
    margin: EdgeInsets.all(5.0),
    child: new Card(
    shape: shapeBorder,
    elevation: 5.0,
    child: new Container(
    //  mainAxisSize: MainAxisSize.max,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,

    children: <Widget>[
    SizedBox(
    height: 152.0,
    child: Stack(
    children: <Widget>[
    Positioned.fill(
    child: Image.asset(
    photos[index].assetName,
    fit: BoxFit.cover,
    )),
    Container(
    color: Colors.black38,
    ),
    Container(
    //margin: EdgeInsets.only(left: 10.0),
    padding: EdgeInsets.only(
    left: 3.0, bottom: 3.0),
    alignment: Alignment.bottomLeft,
    child: new GestureDetector(
    onTap: () {

    },
    child: new Text(
    photos[index].title,
    style: TextStyle(
    fontSize: 18.0,
    color: Colors.white,
    fontWeight:
    FontWeight.bold),
    ),
    ),
    ),


    ],
    ),
    ),

    // new Text(photos[index].title.toString()),
    ],
    ),
    ),
    )
    )

    );
    }),
    ),

    ]),
    ),
    ),
        ));
  }





  _verticalD() => Container(
    margin: EdgeInsets.only(left: 5.0, right: 0.0, top: 10.0, bottom: 0.0),
  );


}
