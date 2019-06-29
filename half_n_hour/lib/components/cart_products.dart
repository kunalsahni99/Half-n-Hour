import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class CartProducts extends StatefulWidget {

  final String imageUrl;
  final String title;
  final String qty;
  final String price;

  CartProducts({
    this.title,
    this.qty,
    this.price,
    this.imageUrl
  });

  @override
  _CartProductsState createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {
  var Products_on_Cart = [
    {
      "name": 'Orange',
      "picture": 'images/products/fruits1.jpg',
      "price": '85',
      "quantity": 1
    },
    {
      "name": 'Capsicum',
      "picture": 'images/products/veg1.jpeg',
      "price": '50',
      "quantity": 2
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: Products_on_Cart.length,
      itemBuilder: (context, index){
        return SingleCartProduct(
          cart_prod_name: Products_on_Cart[index]['name'],
          cart_prod_picture: Products_on_Cart[index]['picture'],
          cart_prod_price: Products_on_Cart[index]['price'],
          cart_prod_qty: Products_on_Cart[index]['quantity'],
        );
      },
    );
  }
}

class SingleCartProduct extends StatelessWidget {
  final cart_prod_name;
  final cart_prod_picture;
  final cart_prod_price;
  final cart_prod_qty;

  SingleCartProduct({
    this.cart_prod_name,
    this.cart_prod_picture,
    this.cart_prod_price,
    this.cart_prod_qty
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 5.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        elevation: 3.0,
        child: Container(
          padding: EdgeInsets.only(left: 15.0, right: 10.0),
          width: MediaQuery.of(context).size.width - 20.0,
          height: 150.0,
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20.0)
          ),
          child: Row(
            children: <Widget>[
              SizedBox(width: 10.0),
              Container(
                height: 150.0,
                width: 125.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(cart_prod_picture),
                    fit: BoxFit.contain
                  )
                ),
              ),

              SizedBox(width: 4.0),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("₹ " + cart_prod_price,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),

                    Text(cart_prod_name,
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black26
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
