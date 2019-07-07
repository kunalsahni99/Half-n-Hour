import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/photo.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'cart.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class ProductDetails extends StatefulWidget {
  final String imageUrl;
  final String category;
  final String title;
  final String desc;
  final int price;
  final String Prod_id;
  final int index;

  ProductDetails(
      {this.imageUrl,
        this.category,
        this.title,
        this.desc,
        this.price,
        this.Prod_id,
        this.index});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int currQty;
  int i = 1, totProd = 0;
  List<int> qtyList = [1, 2, 3, 5, 10, 15, 25];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<DropdownMenuItem<int>> _dropDownMenuItems;

  @override
  void initState() {
    super.initState();
    _dropDownMenuItems = getDropDownMenuItems();
    currQty = _dropDownMenuItems[0].value;
    getProd();
  }

  getProd()async{
    final FirebaseUser user = await _auth.currentUser();

    Firestore.instance.collection("cart").document(user.uid).collection("cartItem")
        .getDocuments().then((QuerySnapshot value){
      setState(() {
        totProd = value.documents.length;
      });
    });
  }

  List<DropdownMenuItem<int>> getDropDownMenuItems() {
    List<DropdownMenuItem<int>> items = new List();
    for (int qty in qtyList) {
      items.add(DropdownMenuItem(
        value: qty,
        child: Text(qty.toString()),
      ));
    }
    return items;
  }

  void changeDropDownItem(int selectedQty) {
    setState(() {
      currQty = selectedQty;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              'Product Detail',
              style:
              TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            )),
        backgroundColor: Colors.white70,
        leading: IconButton(
          icon: Icon(
            isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.black87,
            onPressed: () {},
          ),
          Padding(
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
      body: ListView(
        children: <Widget>[
          Container(
            height: 300.0,
            child: GridTile(
              child: Container(
                  color: Colors.white,
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
              footer: Container(
                color: Colors.white70,
                child: ListTile(
                  title: Text(
                    widget.title,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,color: Colors.black87),textAlign: TextAlign.center,
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text("₹ ${widget.price}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                                fontSize: 18.0)),
                      ),
                      Text(
                        'Qty: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                      ),
                      isIOS
                          ? GestureDetector(
                        onTap: () {
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
                              });
                        },
                        child: Text(currQty.toString()),
                      )
                          : DropdownButton(
                        value: currQty,
                        items: _dropDownMenuItems,
                        onChanged: changeDropDownItem,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          // the second button
          Row(
            children: <Widget>[
              // the size button
              Expanded(
                flex: 2,
                child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    onPressed: () {},
                    color: Colors.white70,
                    elevation: 0.2,
                    textColor: Colors.black87,
                    child: Text('Buy Now')),
              ),

              Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: Colors.black87,
                    ),
                    onPressed: () async {
                      FirebaseAuth auth = FirebaseAuth.instance;

                      final FirebaseUser _user = await auth.currentUser();

                      Firestore.instance
                          .collection("cart")
                          .document(_user.uid)
                          .collection("cartItem")
                          .document(widget.Prod_id.toString())
                          .setData({
                        "imageUrl": widget.imageUrl,
                        "title": widget.title,
                        "price": widget.price,
                        "qty": currQty,
                        "Prod_id": widget.Prod_id
                      });
                      Fluttertoast.showToast(msg: "Added to cart");
                    },
                  )),
            ],
          ),

          Divider(),

          ListTile(
            title: Text('Product Details'),
            contentPadding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
            subtitle: Text(widget.desc),
          ),

          Divider(),

          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: Text(
                  'Name',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(widget.title),
              )
            ],
          ),

          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: Text(
                  'Brand',
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              // remember to edit this
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text('Brand X'),
              )
            ],
          ),

          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: Text(
                  'Category',
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              // remember to edit this
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(widget.category),
              )
            ],
          ),

          Divider(),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Similar Products'),
          ),

          // similar products section
          Container(
            height: 340.0,
            child: SimilarProducts(),
          ),
        ],
      ),
    );
  }
}

class SimilarProducts extends StatefulWidget {
  @override
  _SimilarProductsState createState() => _SimilarProductsState();
}

class _SimilarProductsState extends State<SimilarProducts> {
  var product_list = [
    {
      "name": 'Fruits',
      "picture": 'images/products/fruits2.jpg',
      "old_price": '120',
      "price": '85',
    },
    {
      "name": 'Flour Powder',
      "picture": 'images/products/daily2.jpg',
      "old_price": '100',
      "price": '50',
    },
    {
      "name": 'Meds',
      "picture": 'images/products/med2.jpg',
      "old_price": '100',
      "price": '50',
    },
    {
      "name": 'Veggies',
      "picture": 'images/products/veg2.jpg',
      "old_price": '100',
      "price": '50',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: product_list.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (BuildContext context, int index) {
        return SimilarSingleProd(
          prod_name: product_list[index]['name'],
          prod_picture: product_list[index]['picture'],
          prod_old_price: product_list[index]['old_price'],
          prod_price: product_list[index]['price'],
          index: index,
        );
      },
    );
  }
}

class SimilarSingleProd extends StatelessWidget {
  final prod_name;
  final prod_picture;
  final prod_old_price;
  final prod_price;
  final int index;

  SimilarSingleProd(
      {this.prod_name,
        this.prod_price,
        this.prod_picture,
        this.prod_old_price,
        this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
          child: InkWell(
            onTap: ()async{
              FirebaseAuth auth =
                  FirebaseAuth.instance;

              final FirebaseUser _user =
              await auth
                  .currentUser();

              Firestore.instance
                  .collection("products")
                  .document(
                  photos[index]
                      .Prod_id
                      .toString())
                  .setData({
                "imageUrl":
                photos[index]
                    .imageUrl,
                "title":
                photos[index].title,
                "price":
                photos[index].price,

                "Prod_id": photos[index]
                    .Prod_id,
                "category":photos[index].category,
                "desc": photos[index].desc,
              });
              Navigator.of(context).push(new MaterialPageRoute(
                // passing the details of the product to Product Details screen
                  builder: (BuildContext context) => ProductDetails(
                    title: prod_name,
                    imageUrl: prod_picture,
                    price: prod_price,
                    index: index,
                  )));},
            child: GridTile(
              footer: Container(
                  color: Colors.white70,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          prod_name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                      ),
                      Text(
                        "₹ $prod_price",
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  )),
              child: Image.asset(
                prod_picture,
                fit: BoxFit.cover,
              ),
            ),
          )),
    );
  }
}