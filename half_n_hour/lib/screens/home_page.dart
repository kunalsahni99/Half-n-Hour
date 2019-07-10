import 'package:HnH/screens/product_details.dart';

import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../animations/styling.dart';

import 'package:HnH/screens/cart.dart';
import './profile.dart';
import 'maps.dart';
import 'product_new.dart';
import 'package:HnH/components/photo.dart';

import 'package:flutter/foundation.dart';
import '../components//category.dart';
import '../components//brand.dart';
import '../components//home_category1.dart';
import 'addprod.dart';
import 'search.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;


class MyHomePage extends StatefulWidget {
  int totProd = 0;
  @override
  State<StatefulWidget> createState() => new home();
// TODO: implement createState

}

class home extends State<MyHomePage> {


  SharedPreferences _preferences;
  String uid, uname = "", email = "", avatar;
  bool hasUID = false, isLoggedIn, loggedwithMail, loggedwithPhone;
  final UserUpdateInfo userUpdateInfo = UserUpdateInfo();
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  final GlobalKey _fabKey = GlobalKey();


  CategoryService _categoryService = CategoryService();
  BrandService _brandService=BrandService();


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
      Firestore.instance.collection("cart").document(user.uid).collection("cartItem")
          .getDocuments().then((QuerySnapshot value){
        setState(() {
          widget.totProd = value.documents.length;
        });
      });
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

      category: 'Fruits & Vegetables',

    ),
    Photo(
      imageUrl: 'images/frozen.jpg',
      category: 'Frozen Veg',

    ),
    Photo(
      imageUrl: 'images/bev.jpg',

      category: 'Beverages',
    ),
    Photo(
      imageUrl: 'images/brand_f.jpg',

      category: 'Branded Food',
    ),
    Photo(
      imageUrl: 'images/be.jpg',

      category: 'Beauty & Personal Care',
    ),
    Photo(
      imageUrl: 'images/home.jpg',
      title: 'Furniture',
      category: 'Home Care & Fashion',
    ),
    Photo(
      imageUrl: 'images/nonveg.jpg',

      category: 'Non Veg',
    ),
    Photo(
      imageUrl: 'images/eggs.jpg',

      category: 'Dairy, Bakery & Eggs',
    ),
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
      child:  Carousel(
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
        animationCurve: Curves.easeInCubic,
        animationDuration: Duration(milliseconds: 1000),
        noRadiusForIndicator: true,
        overlayShadow: true,
        overlayShadowColors: Colors.black12,

        overlayShadowSize:0.5,
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
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => Search()));
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
                                    size: 20.0, color: Colors.orange.shade500),
                                new Positioned(
                                    top: 3.0,
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
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AddProduct()));


                  },
                  child: ListTile(
                      title: Text('Add products'),
                      leading: Icon(
                        Icons.add_circle,
                        color: Colors.black87,
                      )),
                ),
                InkWell(
                  onTap: () {_categoryAlert();},
                  child: ListTile(
                      title: Text('Add category'),
                      leading: Icon(
                        Icons.add_circle,
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
                            onTap: () {


                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeCategory(


                                        category: photos_popular[index].category,

                                      )));
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
          ),bottomNavigationBar: _bottomNavigation,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: _fab,

        ));
  }
  Widget get _bottomNavigation {
    final Animation<Offset> slideIn = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: ModalRoute.of(context).animation, curve: Curves.ease));
    final Animation<Offset> slideOut = Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1))
        .animate(CurvedAnimation(parent: ModalRoute.of(context).secondaryAnimation, curve: Curves.fastOutSlowIn));

    return SlideTransition(
      position: slideIn,
      child: SlideTransition(
        position: slideOut,
        child: BottomAppBar(
          color: AppTheme.grey,
          shape: AutomaticNotchedShape(RoundedRectangleBorder(), CircleBorder()),
          notchMargin: 8,
          child: SizedBox(
            height: 48,
            child: Row(
              children: <Widget>[
                IconButton(
                  iconSize: 48,
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[

                    ],
                  ),
                  onPressed: () => print('Tap!'),
                ),
                Spacer(),

              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget get _fab {
    return AnimatedBuilder(
      animation: ModalRoute.of(context).animation,
      child: FloatingActionButton(

            key: _fabKey,
            child: new IconButton(

              icon: Icon(Icons.shopping_cart),

            ),


            backgroundColor: AppTheme.orange,
            onPressed: () => Navigator.of(context).push<void>(
              Cart.route(context, _fabKey),
            ),
          ),


      builder: (BuildContext context, Widget fab) {
        final Animation<double> animation = ModalRoute.of(context).animation;
        return SizedBox(
          width: 54 * animation.value,
          height: 54 * animation.value,
          child: fab,
        );
      },
    );
  }

  _verticalD() => Container(
    margin: EdgeInsets.only(left: 5.0, right: 0.0, top: 10.0, bottom: 0.0),
  );
  void _categoryAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _categoryFormKey,
        child: TextFormField(
          controller: categoryController,
          validator: (value){
            if(value.isEmpty){
              return 'category cannot be empty';
            }
          },
          decoration: InputDecoration(
              hintText: "add category"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          if(categoryController.text != null){
            _categoryService.createCategory(categoryController.text);
          }
          Fluttertoast.showToast(msg: 'category created');
          Navigator.pop(context);
        }, child: Text('ADD')),
        FlatButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('CANCEL')),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }
}
