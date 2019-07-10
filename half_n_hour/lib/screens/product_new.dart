import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;

import 'package:HnH/screens/cart.dart';
import 'product_details.dart';
import './profile.dart';
import 'maps.dart';
import 'home_page.dart';
import 'package:HnH/components/photo.dart';

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;


class ProductNew extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => new home();
// TODO: implement createState

}

class home extends State<ProductNew> {

  SharedPreferences _preferences;
  String uid,
      uname = "",
      email = "",
      avatar;
  int totProd =0;
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

      Firestore.instance.collection("cart").document(user.uid).collection("cartItem")
          .getDocuments().then((QuerySnapshot value){
        setState(() {
          totProd = value.documents.length;
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
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              // header
              UserAccountsDrawerHeader(
                accountName: Text(uname,
                  style: TextStyle(
                      color: Colors.black87,fontWeight: FontWeight.bold
                  ),
                ),
                accountEmail: Text(email,
                  style: TextStyle(
                      color: Colors.black26
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
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                            ),
                        imageUrl: avatar != null
                            ? avatar
                            : "https://cdn4.iconfinder.com/data/icons/avatars-gray/500/avatar-12-512.png",
                      ),
                    )
                ),
                decoration: BoxDecoration(
                    color: Colors.grey[300]
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
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()));
                      },
                      child: new Text(
                        'Categories   ',
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
              400.0,

              child:  StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection("products")
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Container(
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.only(bottom: 100.0),
                          child: new CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(Colors.black87),
                          )
                      );
                    default:
                      return new ListView(
                        children:
                        snapshot.data.documents.map((DocumentSnapshot document) {
                          return new SingleProduct(
                            title: document['title'],
                            imageUrl: document['imageUrl'],
                            price: document['price'],
                            category: document['category'],
                            Prod_id: document['Prod_id'],
                            index: snapshot.data.documents.indexOf(document),
                          );
                        }).toList(),
                      );
                  }
                },
              ),
            )
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
           Navigator.push(context, FadeRouteBuilder(page: Cart()));
          },
          child: Stack(
            children: <Widget>[
              Center(
                child: new IconButton(
                    icon: new Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    onPressed: (){
                      Navigator.of(context).push(
                          new MaterialPageRoute(
                              builder:(BuildContext context) =>
                                  Cart()
                          )
                      );
                    }),
              ),
              totProd == 0
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
                              totProd.toString(),
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
          backgroundColor: Colors.black87,
        ),
      ),
    );
  }

  _verticalD() => Container(
    margin: EdgeInsets.only(left: 10.0, right: 0.0, top: 10.0, bottom: 0.0),
  );
}

class FadeRouteBuilder<T> extends PageRouteBuilder<T>{
  final Widget page;

  FadeRouteBuilder({@required this.page})
      : super(
        transitionDuration: Duration(seconds: 1),
        pageBuilder: (context, anim1, anim2) => page,
        transitionsBuilder: (context, a1, a2, child){
          return FadeTransition(opacity: a1 , child: child);
        }
      );
}

class SingleProduct extends StatefulWidget {
  final String imageUrl;
  final String title;
  final int price;
  final String Prod_id;
  final String category;
  final String desc;
  final int index;

  SingleProduct({
    this.imageUrl,
    this.title,
    this.price,
    this.Prod_id,
    this.category,
    this.desc,
    @required this.index
  });

  @override
  _SingleProductState createState() => _SingleProductState();
}

class ValleyQuadraticCurve extends Curve {
  @override
  double transform(double t) {

    assert(t >= 0.0 && t <= 1.0);

    return 4 * math.pow(t - 0.5, 2);
  }
}

class _SingleProductState extends State<SingleProduct> {
  List<int> qtyList = [1, 2, 3, 5, 10, 15, 25];
  int currQty = 1, selected;

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new GestureDetector(
            onTap: ()async{
              Firestore.instance
                  .collection("products")
                  .document(
                  widget.Prod_id
                      .toString())
                  .get().then((DocumentSnapshot ds){
                Navigator.push(
                    context, FadeRouteBuilder(
                  page: ProductDetails(
                    imageUrl: ds.data["imageUrl"],
                    title: ds.data["title"],
                    price: ds.data["price"],
                    Prod_id: ds.data["Prod_id"],
                    category: ds.data["category"],
                    desc: ds.data["desc"],
                    index: widget.index,
                  )
                ));
              });
            },
            child: new Container(
                margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                padding: EdgeInsets.only(bottom: 50.0),
                child: new Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    elevation: 8.0,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height:MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Stack(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Hero(
                                    tag: 'prod ${widget.index}',
                                    child: CachedNetworkImage(
                                      placeholder: (context, val) => Container(
                                        width: 20.0,
                                        height: 20.0,
                                        child: CircularProgressIndicator(
                                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.black87),
                                        ),
                                      ),
                                      imageUrl: widget.imageUrl,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.only(top: 287.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white70
                            ),
                            alignment: Alignment.bottomCenter,
                            child: ListTile(
                              contentPadding: EdgeInsets.only(left: 10.0),
                              title: Text(widget.title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0
                                ),
                              ),
                              subtitle: Container(
                                padding: EdgeInsets.only(top: 12.0),
                                child: Text("₹" + widget.price.toString(),
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16.0,
                                  ),
                                ),
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: MaterialButton(
                                  onPressed: ()async{
                                    try {
                                      FirebaseAuth auth = FirebaseAuth.instance;
                                      final FirebaseUser _user = await auth.currentUser();

                                      isIOS ?
                                      showCupertinoModalPopup(
                                          context: context,
                                          builder: (context) {
                                            return CupertinoActionSheet(
                                              title: Text('Select quantity'),
                                              actions: <Widget>[
                                                CupertinoActionSheetAction(
                                                  child: Text('1'),
                                                  onPressed: () {
                                                    setState(() {
                                                      currQty = 1;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                CupertinoActionSheetAction(
                                                  child: Text('2'),
                                                  onPressed: () {
                                                    setState(() {
                                                      currQty = 2;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                CupertinoActionSheetAction(
                                                  child: Text('3'),
                                                  onPressed: () {
                                                    setState(() {
                                                      currQty = 3;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                CupertinoActionSheetAction(
                                                  child: Text('5'),
                                                  onPressed: () {
                                                    setState(() {
                                                      currQty = 5;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                CupertinoActionSheetAction(
                                                  child: Text('10'),
                                                  onPressed: () {
                                                    setState(() {
                                                      currQty = 10;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                CupertinoActionSheetAction(
                                                  child: Text('15'),
                                                  onPressed: () {
                                                    setState(() {
                                                      currQty = 15;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                CupertinoActionSheetAction(
                                                  child: Text('25'),
                                                  onPressed: () {
                                                    setState(() {
                                                      currQty = 25;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                              cancelButton:
                                              CupertinoActionSheetAction(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            );
                                          })
                                        : selected = await showGeneralDialog<int>(
                                        barrierColor: Colors.black.withOpacity(0.5),
                                        context: context,
                                        transitionBuilder: (context, a1, a2, widget){
                                          return Transform.scale(
                                            scale: a1.value,
                                            child: Opacity(
                                              opacity: a1.value,
                                              child: SimpleDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20.0)
                                                ),
                                                title: Center(child: Text('Select Quantity')),
                                                children: qtyList.map((value){
                                                  return Align(
                                                    alignment: Alignment.center,
                                                    child: new SimpleDialogOption(
                                                      onPressed: (){
                                                        Navigator.pop(context, value);

                                                        Fluttertoast.showToast(msg: "Added to cart");
                                                      },
                                                      child: Text(value.toString()),
                                                    ),
                                                  );
                                                }).toList()
                                              ),
                                            ),
                                          );
                                        },
                                        transitionDuration: Duration(milliseconds: 200),
                                        barrierDismissible: true,
                                        barrierLabel: "",
                                        pageBuilder: (context, anim1, anim2){}
                                      );
                                      if (selected != null){
                                        setState(() {
                                          currQty = selected;
                                        });

                                        Firestore.instance
                                            .collection("cart").document(_user.uid).collection("cartItem")
                                            .document(widget.Prod_id.toString())
                                            .setData({"imageUrl": widget.imageUrl,
                                          "title": widget.title,
                                          "price": widget.price,
                                          "qty": currQty,
                                          "Prod_id": widget.Prod_id});
                                      }
                                    } catch (e) {
                                      Fluttertoast.showToast(msg: "Error in Adding");
                                    }
                                  },
                                  color: Colors.black45,
                                  elevation: 3.0,
                                  textColor: Colors.white,
                                  child: Text("ADD",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                )
            )
        )
    );
  }
}
