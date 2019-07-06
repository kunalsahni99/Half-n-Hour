import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:HnH/screens/cart.dart';
import './profile.dart';
import 'categories.dart';
import 'maps.dart';
import 'product_new.dart';
import 'package:HnH/components/photo.dart';

import 'package:flutter/foundation.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;
const String _kGalleryAssetsPackage = 'flutter_gallery_assets';

class MyHomePage extends StatefulWidget {
  int totProd = 0;
  @override
  State<StatefulWidget> createState() => new home();
// TODO: implement createState

}

class home extends State<MyHomePage> {
  List list = ['12', '11'];

  SharedPreferences _preferences;
  String uid, uname = "", email = "", avatar;
  bool hasUID = false, isLoggedIn, loggedwithMail, loggedwithPhone;
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
    uid = _preferences.getString("id") ?? null;
    isLoggedIn = _preferences.getBool("isLoggedIn") ?? false;
    loggedwithMail = _preferences.getBool("LoggedInwithMail") ?? false;
    loggedwithPhone = _preferences.getBool("LoginPhone") ?? false;

    setState(() {
      if (uid != null) {
        // for google sign in
        uname = user.displayName;
        email = user.email;
        avatar = user.photoUrl;
      } else if (isLoggedIn) {
        // for email(signup)
        uname = user.displayName != null
            ? user.displayName.toString()
            : _preferences.getString("SignUname");

        email = user.email != null
            ? user.email.toString()
            : _preferences.getString("SignEmail");
        avatar = user.photoUrl != null
            ? user.photoUrl.toString()
            : "https://cdn4.iconfinder.com/data/icons/avatars-gray/500/avatar-12-512.png";
      } else if (loggedwithMail) {
        // for email(login)
        print("hello" + user.displayName);
        uname = user.displayName != null
            ? user.displayName.toString()
            : _preferences.getString("LogUname");
        email = user.email != null
            ? user.email.toString()
            : _preferences.getString("SignEmail");
        avatar = user.photoUrl != null
            ? user.photoUrl.toString()
            : "https://cdn4.iconfinder.com/data/icons/avatars-gray/500/avatar-12-512.png";
      } else if (loggedwithPhone) {
        // for phone
        uname = user.displayName != null
            ? user.displayName.toString()
            : _preferences.getString("Phone");
        avatar = user.photoUrl != null
            ? user.photoUrl.toString()
            : "https://cdn4.iconfinder.com/data/icons/avatars-gray/500/avatar-12-512.png";
      } else {
        uname = "Guest User";
        email = "guest@example.com";
      }

      Firestore.instance.collection("cart").document(user.uid).collection("cartItem")
          .getDocuments().then((QuerySnapshot value){
        setState(() {
          widget.totProd = value.documents.length;
        });
      });
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
        ) ??
        false;
  }

  final List<String> items = ['Balbhadra', 'Maulik', 'Roshi'];
  static const double height = 366.0;
  String name = 'My Wishlist';

  List<Photo> photos_popular = <Photo>[
    Photo(
        imageUrl: 'images/veg.jpg',
        title: 'Fruits',
        category: 'Fruits & Vegetables',
        Prod_id: 1,
        price: '100',
        desc:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
    Photo(
        imageUrl: 'images/frozen.jpg',
        title: 'Peas',
        category: 'Frozen Veg',
        Prod_id: 2,
        price: '100',
        desc:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
    Photo(
        imageUrl: 'images/bev.jpg',
        title: 'Juice',
        category: 'Beverages',
        Prod_id: 3,
        price: '100',
        desc:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
    Photo(
        imageUrl: 'images/brand_f.jpg',
        title: 'Grocery',
        category: 'Branded Food',
        Prod_id: 4,
        price: '100',
        desc:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
    Photo(
        imageUrl: 'images/be.jpg',
        title: 'Cosmetics',
        category: 'Beauty & Personal Care',
        Prod_id: 5,
        price: '100',
        desc:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
    Photo(
        imageUrl: 'images/home.jpg',
        title: 'Furniture',
        category: 'Home Care & Fashion',
        Prod_id: 6,
        price: '100',
        desc:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
    Photo(
        imageUrl: 'images/nonveg.jpg',
        title: 'Chicken',
        category: 'Non Veg',
        Prod_id: 7,
        price: '100',
        desc:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
    Photo(
        imageUrl: 'images/eggs.jpg',
        title: 'Cake',
        category: 'Dairy, Bakery & Eggs',
        Prod_id: 8,
        price: '100',
        desc:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final Orientation orientation = MediaQuery.of(context).orientation;
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle =
        theme.textTheme.headline.copyWith(color: Colors.black54);
    final TextStyle descriptionStyle = theme.textTheme.subhead;
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
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
      ),
    );

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: new AppBar(
            iconTheme: IconThemeData(color: Colors.black87),
            backgroundColor: Colors.white70,
            title: Text("Half n Hour",
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold)),
            actions: <Widget>[
              IconButton(
                tooltip: 'Search',
                icon: const Icon(Icons.search),
                color: Colors.black87,
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
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => Cart()));
                    },
                    child: Stack(
                      children: <Widget>[
                        new IconButton(
                            icon: new Icon(
                              Icons.shopping_cart,
                              color: Colors.black87,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (BuildContext context) => Cart()));
                            }),
                        widget.totProd == 0
                            ? new Container()
                            : new Positioned(
                                child: new Stack(
                                children: <Widget>[
                                  new Icon(Icons.brightness_1,
                                      size: 20.0,
                                      color: Colors.orange.shade500),
                                  new Positioned(
                                      top: 4.0,
                                      right: 5.5,
                                      child: new Center(
                                        child: new Text(
                                          widget.totProd.toString(),
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
                  accountName: Text(
                    uname,
                    style: TextStyle(color: Colors.black87),
                  ),
                  accountEmail: Text(
                    email,
                    style: TextStyle(color: Colors.black87),
                  ),
                  currentAccountPicture: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Account()));
                      },
                      child: ClipOval(
                        child: CachedNetworkImage(
                          placeholder: (context, val) =>
                              CircularProgressIndicator(),
                          imageUrl: avatar != null
                              ? avatar
                              : "https://cdn4.iconfinder.com/data/icons/avatars-gray/500/avatar-12-512.png",
                        ),
                      )),
                  decoration: BoxDecoration(color: Colors.white70),
                ),
                // body
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Account()));
                  },
                  child: ListTile(
                      title: Text('My Account'),
                      leading: Icon(
                        Icons.person,
                        color: Colors.black87,
                      )),
                ),
                InkWell(
                  onTap: () {},
                  child: ListTile(
                      title: Text('My Orders'),
                      leading: Icon(
                        Icons.shopping_basket,
                        color: Colors.black87,
                      )),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Cart()));
                  },
                  child: ListTile(
                      title: Text('My Cart'),
                      leading: Icon(
                        Icons.shopping_cart,
                        color: Colors.black87,
                      )),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Maps()));
                  },
                  child: ListTile(
                      title: Text('Maps'),
                      leading: Icon(
                        Icons.map,
                        color: Colors.black87,
                      )),
                ),

                Divider(),

                InkWell(
                  onTap: () {},
                  child: ListTile(
                      title: Text('Settings'),
                      leading: Icon(
                        Icons.settings,
                        color: Colors.black87,
                      )),
                ),
                InkWell(
                  onTap: () {},
                  child: ListTile(
                      title: Text('About'),
                      leading: Icon(
                        Icons.help,
                        color: Colors.black87,
                      )),
                ),
              ],
            ),
          ),
          body: new SingleChildScrollView(
            child: Container(
              child: new Column(children: <Widget>[
                image_carousel,
                new Container(
                  margin: EdgeInsets.only(top: 7.0),
                  child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _verticalD(),
                        new GestureDetector(
                          onTap: () {},
                          child: new Text(
                            'Categories',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        _verticalD(),

                        new Row(
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductNew()));
                              },
                              child: new Text(
                                'What\'s New',
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
                      itemCount: photos_popular.length,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(10.0),
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        return new GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => CategoriesList(title: photos_popular[index].category,)
                              ));
                            },
                            child: new Container(
                                margin: EdgeInsets.all(5.0),
                                child: new Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  elevation: 5.0,
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned.fill(
                                          child: Image.asset(
                                        photos_popular[index].imageUrl,
                                        fit: BoxFit.fitHeight,
                                      )),
                                      Container(
                                        color: Colors.black26,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 3.0, bottom: 3.0),
                                        alignment: Alignment.bottomLeft,
                                        child: new Text(
                                          photos_popular[index].category,
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                )));
                      }),
                ),
              ]),
            ),
          ),
        ));
  }

  _verticalD() => Container(
        margin: EdgeInsets.only(left: 10.0, right: 5.0, top: 10.0, bottom: 0.0),
      );
}