
import 'package:cloud_firestore/cloud_firestore.dart';
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
                              CircularProgressIndicator(),
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
                          return new CircularProgressIndicator();
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
                              );
                            }).toList(),
                          );
                      }
                    },
                  ),
                )

              ]),
            ),
          ),
        );
  }

  _verticalD() => Container(
    margin: EdgeInsets.only(left: 10.0, right: 0.0, top: 10.0, bottom: 0.0),
  );
}

class SingleProduct extends StatefulWidget {
  final String imageUrl;
  final String title;
  final int price;
  final String Prod_id;
  final String category;
  final String desc;

  SingleProduct({
    this.imageUrl,
    this.title,
    this.price,
    this.Prod_id,
    this.category,
    this.desc
  });

  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  @override
  Widget build(BuildContext context) {
    return new Container(

    child: new GestureDetector(
        onTap: ()async{

                             /* FirebaseAuth auth =
                                  FirebaseAuth.instance;

                              final FirebaseUser _user =
                                  await auth
                                  .currentUser();

                              Firestore.instance
                                  .collection("products")
                                  .document(
                                  widget
                                      .Prod_id
                                      .toString())
                                  .setData({
                                "imageUrl":
                                widget
                                    .imageUrl,
                                "title":
                                widget.title,
                                "price":
                                widget.price,

                                "Prod_id": widget
                                    .Prod_id,
                                "category":widget.category,
                                "desc": widget.desc,
                              });*/

          Firestore.instance
              .collection("products")
              .document(
              widget.Prod_id
                  .toString())
              .get().then((DocumentSnapshot ds){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductDetails(

                      imageUrl: ds.data["imageUrl"],
                      title: ds.data["title"],
                      price: ds.data["price"],
                      Prod_id: ds.data["Prod_id"],
                      category: ds.data["category"],
                      desc: ds.data["desc"],
                    )));});

          /*Future<Null> uploadFile(String filepath) async {
                                final ByteData bytes = await rootBundle.load(filepath);
                                final Directory tempDir = Directory.systemTemp;
                                final String fileName = "${Random().nextInt(10000)}.jpg";
                                final File file = File('${tempDir.path}/$fileName');
                                file.writeAsBytes(bytes.buffer.asInt8List(), mode: FileMode.write);

                                final StorageReference ref = FirebaseStorage.instance.ref().child('products/${photos[index].category}/${photos[index].Prod_id}/_prodpicture.jpg');
                                final StorageUploadTask uploadTask = ref.putFile(file);
                                await uploadTask.onComplete.then((TaskSnapShot)async{
                                  URL = await TaskSnapShot.ref.getDownloadURL();
                                  Firestore.instance
                                      .collection("cart")
                                      .document(_user.uid)
                                      .collection("cartItem")
                                      .document(photos[index].Prod_id.toString())
                                      .updateData({
                                    "imageUrl":
                                    URL
                                      });


                                });
                              }*/
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
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:NetworkImage(widget.imageUrl.toString()),
                              fit: BoxFit.cover
                          )
                      ),
                    ),

                    Container(

                      padding: EdgeInsets.only(top: 287.0),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        color: Colors.white70,
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
                                  color: Colors.black26,
                                  fontSize: 16.0,fontWeight: FontWeight.w900
                              ),
                            ),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: MaterialButton(
                              onPressed: ()async{
                                try {
                                  FirebaseAuth auth =
                                      FirebaseAuth.instance;

                                  final FirebaseUser _user =
                                  await auth
                                      .currentUser();

                                  Firestore.instance
                                      .collection("cart")
                                      .document(_user.uid)
                                      .collection(
                                      "cartItem")
                                      .document(
                                      widget
                                          .Prod_id
                                          .toString())
                                      .setData({
                                    "imageUrl":
                                    widget
                                        .imageUrl,
                                    "title":
                                    widget.title,
                                    "price":
                                    widget.price,
                                    "qty":1,

                                    "Prod_id": widget
                                        .Prod_id
                                  });
                                  Fluttertoast.showToast(
                                      msg: "Added to cart");
                                } catch (e) {
                                  Fluttertoast.showToast(
                                      msg:
                                      "Error in Adding");
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

    ));

  }
}
