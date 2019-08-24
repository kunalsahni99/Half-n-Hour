import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart' as Random;

import 'cart.dart';
import 'edit_address.dart';
import '../components/single_address.dart';
import 'payments.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class CheckOut extends StatefulWidget {
  final bool isCart;
  final String imageUrl;
  final String title;
  final int price;
  final int qty;
  final String id;

  CheckOut({
    @required this.isCart,
    this.imageUrl,
    this.title,
    this.price,
    this.qty,
    this.id
  });

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  double height = 100.0;
  int radVal = 0, delAdd;
  SharedPreferences _preferences;
  FirebaseAuth auth = FirebaseAuth.instance;
  String address1Line1 = "", address1Line2 = "", address1pin = "";
  String address2Line1 = "", address2Line2 = "", address2pin = "";
  String username = "", UID = "";
  bool isLoading;

  @override
  void initState(){
    super.initState();
    getPrefs();
    setState(() {
      isLoading = true;
    });
    Timer(
      Duration(seconds: 1),
      (){
        setState(() {
          isLoading = false;
        });
      }
    );
  }

  Future<Null> getPrefs() async{
    _preferences = await SharedPreferences.getInstance();
    final FirebaseUser user = await auth.currentUser();

    address1Line1 = _preferences.getString("address1Line1") ?? "";
    address1Line2 = _preferences.getString("address1Line2") ?? "";
    address1pin = _preferences.getString("address1pin") ?? "";

    address2Line1 = _preferences.getString("address2Line1") ?? "";
    address2Line2 = _preferences.getString("address2Line2") ?? "";
    address2pin = _preferences.getString("address2pin") ?? "";

    delAdd = _preferences.getInt("DelAdd") ?? 1;
    setState(() {
      username = user.displayName;
      UID = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Price>(context);

    return WillPopScope(
      onWillPop: () async{
        if (!widget.isCart){
          cart.setPrice(0);
        }
        Navigator.pop(context);
        return null;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              if (!widget.isCart){
                cart.setPrice(0);
              }
              Navigator.pop(context);
            },
            icon: Icon(isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
          ),
          title: Text('Order Summary',
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          backgroundColor: Colors.white70,
        ),

        body: SingleChildScrollView(
          physics: widget.isCart ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: (address1Line1 == "" && address2Line1 == "") ? height : 150.0,
                  padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                    ),
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                        ),
                        showAddress(),
                        Container(
                          alignment: Alignment.center,
                          child: Visibility(
                            visible: isLoading,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                // list of products in the cart
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 20.0),
                  child: Text('Products',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20.0
                    ),
                  ),
                ),

                Container(
                  alignment: Alignment.topCenter,
                  height: 700.0,
                  child: showProducts()
                )
              ],
            ),
          )
        ),

        bottomNavigationBar: Container(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  title: Text('Total'),
                  subtitle: Text('₹ ${cart.totPrice}'),
                ),
              ),

              Expanded(
                child: MaterialButton(
                    height: 50.0,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ChoosePayments(totPrice: cart.totPrice,
                          orderId: "ORD" + Random.randomAlphaNumeric(8).toUpperCase(),
                          isCart: widget.isCart,
                          title: widget.title,
                          imageUrl: widget.imageUrl,
                          qty: widget.qty,
                          Prod_id: widget.id,
                          price: widget.price,
                        )
                      ));
                    },
                    color: Colors.white70,
                    child: Text('Continue',
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0
                      ),
                    )
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  Widget showAddress(){
    if (address1Line1 == "" && address2Line1 == ""){
      return Container(
        padding: EdgeInsets.only(left: 50.0, top: 50.0),
        child: MaterialButton(
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => EditAddress()
            ));
          },
          color: Colors.black54,
          child: Text('Add a delivery address',
            style: TextStyle(
              color: Colors.white
            ),
          ),
          padding: EdgeInsets.only(left: 50.0, right: 50.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
          ),
        ),
      );
    }

    else{
      return Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(left: 20.0, top: 5.0),
              child: address1Line1 != "" && delAdd == 1 ?
              SingleAddress(
                addLine1: address1Line1,
                addLine2: address1Line2,
                pin: address1pin,
                Uname: username,
              ) :
              SingleAddress(
                addLine1: address2Line1,
                addLine2: address2Line2,
                pin: address2pin,
                Uname: username,
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.edit,
                  color: Colors.black54,
                ),
                onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => EditAddress(isCart: widget.isCart,)
                  ));
                },
              ),
            ),
          )
        ],
      );
    }
  }

  Widget showProducts(){
    return widget.isCart ?
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection("cart")
              .document(UID)
              .collection("cartItem")
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: new CircularProgressIndicator(
                  backgroundColor: Colors.white70,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black87),
                )
                );
              case ConnectionState.none:
                return Center(child: Text("Your Cart is empty"),);
              default:
                return new ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                    return new SingleCartProduct(
                      cart_prod_name: document['title'],
                      cart_prod_picture: document['imageUrl'],
                      cart_prod_price: document['price'],
                      cart_prod_qty: document['qty'],
                      cart_prod_id: document['Prod_id'],
                      isCart: false,
                    );
                  }).toList(),
                );
            }
          },
        ) :
        SingleCartProduct(
          cart_prod_name: widget.title,
          cart_prod_picture: widget.imageUrl,
          cart_prod_price: widget.price,
          cart_prod_qty: widget.qty,
          isCart: false,
          cart_prod_id: widget.id,
        );
  }
}
