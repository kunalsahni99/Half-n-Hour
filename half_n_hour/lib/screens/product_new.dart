import 'package:HnH/screens/product_popular.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:HnH/screens/cart.dart';
import 'product_details.dart';
import './profile.dart';
import 'maps.dart';
import 'home_page.dart';
import 'package:HnH/components/photo.dart';

import 'package:flutter/foundation.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;
const String _kGalleryAssetsPackage = 'flutter_gallery_assets';

class ProductNew extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new home();
// TODO: implement createState

}

class home extends State<ProductNew> {
  List list = ['12', '11'];

  List<Photo> photos = <Photo>[
    Photo(
      imageUrl: 'images/veg.jpg',
      title: 'Fruits',
      category: 'Fruits & Vegetables',
      price: '75',
      Prod_id: '009',
      desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
    ),
    Photo(
      imageUrl: 'images/frozen.jpg',
      title: 'Peas',
      category: 'Frozen Veg',
      price: '100',
      Prod_id: '010',
      desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
    ),
    Photo(
      imageUrl: 'images/bev.jpg',
      title: 'Tea',
      category: 'Beverages',
      price: '100',
      Prod_id: '011',
      desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum"
    ),
    Photo(
      imageUrl: 'images/brand_f.jpg',
      title: 'Shaktibhog Atta',
      category: 'Brannded Food',
      price: '500',
      Prod_id: '012',
      desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
    ),
    Photo(
      imageUrl: 'images/be.jpg',
      title: 'Lipstick',
      category: 'Beauty & Personal Care',
      price: '200',
      Prod_id: '013',
      desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
    ),
    Photo(
      imageUrl: 'images/home.jpg',
      title: 'Table',
      category: 'Home Care & Fashion',
      price: '10000',
      Prod_id: '014',
      desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
    )
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

    setState((){
      if (uid != null) { // for google sign in
        uname = user.displayName;
        email = user.email;
        avatar = user.photoUrl;
      }
      else if (isLoggedIn) { // for email(signup)
        uname = user.displayName != null
            ? user.displayName.toString()
            : _preferences.getString("SignUname");

        email =
        user.email != null ? user.email.toString() : _preferences.getString(
            "SignEmail");
        avatar = user.photoUrl != null
            ? user.photoUrl.toString()
            : "https://cdn4.iconfinder.com/data/icons/avatars-gray/500/avatar-12-512.png";
      }
      else if (loggedwithMail) { // for email(login)
        print("hello" + user.displayName);
        uname = user.displayName != null
            ? user.displayName.toString()
            : _preferences.getString("LogUname");
        email =
        user.email != null ? user.email.toString() : _preferences.getString(
            "SignEmail");
        avatar = user.photoUrl != null
            ? user.photoUrl.toString()
            : "https://cdn4.iconfinder.com/data/icons/avatars-gray/500/avatar-12-512.png";
      }
      else if (loggedwithPhone) { // for phone
        uname = user.displayName != null
            ? user.displayName.toString()
            : _preferences.getString("Phone");
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
          NetworkImage('https://firebasestorage.googleapis.com/v0/b/half-n-hour-aedef.appspot.com/o/app%2Fcarousel%2Fi1.jpg?alt=media&token=ba548dea-24e2-41a1-ab49-66eccaf6c4ee'),
          NetworkImage('https://firebasestorage.googleapis.com/v0/b/half-n-hour-aedef.appspot.com/o/app%2Fcarousel%2Fi2.jpg?alt=media&token=368c9fd8-b1fc-4d7c-a254-5972f334f2c7'),
          NetworkImage('https://firebasestorage.googleapis.com/v0/b/half-n-hour-aedef.appspot.com/o/app%2Fcarousel%2Fi3.jpg?alt=media&token=7c18f1cc-dcfe-4c64-9b1c-621345c29d53'),
          NetworkImage('https://firebasestorage.googleapis.com/v0/b/half-n-hour-aedef.appspot.com/o/app%2Fcarousel%2Fi4.jpg?alt=media&token=f27e14f7-36ac-41bb-b8b5-555b027e3d7d'),
          NetworkImage('https://firebasestorage.googleapis.com/v0/b/half-n-hour-aedef.appspot.com/o/app%2Fcarousel%2Fi5.jpg?alt=media&token=ac9cc479-b34f-4b02-845b-d172096e54fe'),
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
                  color: Colors.black87,
                  fontWeight: FontWeight.bold
                )
            ),

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
                              color: Colors.black87,
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
                  accountName: Text(uname,
                    style: TextStyle(
                      color: Colors.black87
                    ),
                  ),
                  accountEmail: Text(email,
                    style: TextStyle(
                        color: Colors.black87
                    ),
                  ),
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
                      color: Colors.white70
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
                      leading: Icon(Icons.person, color: Colors.black87,)
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: ListTile(
                      title: Text('My Orders'),
                      leading: Icon(
                        Icons.shopping_basket, color: Colors.black87,)
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
                      leading: Icon(Icons.shopping_cart, color: Colors.black87,)
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
                      leading: Icon(Icons.map, color: Colors.black87,)
                  ),
                ),

                Divider(),

                InkWell(
                  onTap: () {},
                  child: ListTile(
                      title: Text('Settings'),
                      leading: Icon(Icons.settings, color: Colors.black87,)
                  ),
                ), InkWell(
                  onTap: () {},
                  child: ListTile(
                      title: Text('About'),
                      leading: Icon(Icons.help, color: Colors.black87,)
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
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()));
                          },
                          child: new Text(
                            'Categories',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black26,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        _verticalD(),
                        new GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
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
                              onTap: () {},
                              child: new Text(
                                'What\'s New',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )
                      ]),
                ),
                new Container(
                  alignment: Alignment.topCenter,
                  height: isIOS ? MediaQuery.of(context).size.height*photos.length/2.25 :
                  MediaQuery.of(context).size.height*photos.length/2.15,

                  child: new GridView.builder(
                      itemCount: photos.length,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(10.0),
                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1),
                      itemBuilder: (BuildContext context, int index) {
                        return new GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                    imageUrl: photos[index].imageUrl,
                                    title: photos[index].title,
                                    price: photos[index].price,
                                    Prod_id: photos[index].Prod_id,
                                    category: photos[index].category,
                                    desc: photos[index].desc,
                                  )
                              ));
                            },
                            child: new Container(
                                margin: EdgeInsets.all(5.0),
                                height: 100.0,
                                width: MediaQuery.of(context).size.width,
                                child: new Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0)
                                    ),
                                    elevation: 5.0,
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                            height:MediaQuery.of(context).size.width * 5,
                                            width: MediaQuery.of(context).size.width,
                                            alignment: Alignment.topCenter,
                                            child: Image.asset(
                                              photos[index].imageUrl,
                                              fit: BoxFit.fitWidth,
                                            )
                                        ),

                                        Container(
                                          padding: EdgeInsets.only(top: 10.0),
                                          alignment: Alignment.bottomCenter,
                                          child: ListTile(
                                            contentPadding: EdgeInsets.only(left: 10.0),
                                            title: Text(photos[index].title,
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 15.0
                                              ),
                                            ),
                                            subtitle: Container(
                                              padding: EdgeInsets.only(top: 10.0),
                                              child: Text("₹" + photos[index].price,
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 15.0
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                )
                            )

                        );
                      }),
                )

              ]),
            ),
          ),
        ));
  }





  _verticalD() => Container(
    margin: EdgeInsets.only(left: 5.0, right: 0.0, top: 10.0, bottom: 0.0),
  );


}
