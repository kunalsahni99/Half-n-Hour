import 'package:HnH/screens/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartProducts extends StatefulWidget {
  @override
  _CartProductsState createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userid;
  @override
  void initState() {
    super.initState();
    getuid();
  }

  Future<Null> getuid() async {
    final FirebaseUser user = await _auth.currentUser();
    int sum = 0;
    var cart = Provider.of<Price>(context);
    Firestore.instance.collection("cart").document(user.uid).collection("cartItem")
        .getDocuments().then((snapShot){
      snapShot.documents.forEach((document){
        sum += document['price'] * document['qty'];
        setState(() {
          cart.totPrice = sum;
        });
      });
    });

    setState(() {
      userid = user.uid.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Price>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("cart")
          .document(userid)
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
              children:
              snapshot.data.documents.map((DocumentSnapshot document) {
                return Dismissible(
                  background: Container(
                    color: Colors.redAccent,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 30.0),
                      child: Icon(Icons.delete_sweep,
                        color: Colors.white,
                        size: 40.0,
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.redAccent,
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 30.0),
                      child: Icon(Icons.delete_sweep,
                        color: Colors.white,
                        size: 40.0,
                      ),
                    ),
                  ),
                  key: Key(document['Prod_id'].toString()),
                  onDismissed: (direction)async{
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final FirebaseUser user = await auth.currentUser();

                    Firestore.instance.collection("cart").document(user.uid).collection("cartItem")
                        .document(document['Prod_id'].toString()).delete().then((value){
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Product removed from cart"),
                      ));
                    });

                    setState(() {
                      cart.totPrice = cart.totPrice - (document['price'] * document['qty']);
                    });
                  },
                  child: new SingleCartProduct(
                    cart_prod_name: document['title'],
                    cart_prod_picture: document['imageUrl'],
                    cart_prod_price: document['price'],
                    cart_prod_qty: document['qty'],
                    cart_prod_id: document['Prod_id'],
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
