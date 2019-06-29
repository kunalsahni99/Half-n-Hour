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
      "name": 'This is a very very very very long text',
      "picture": 'images/products/fruits1.jpg',
      "price": '85',
      "quantity": 1
    },
    {
      "name": 'Parle Hide & Seek Chocolate and Cream',
      "picture": 'images/groceries.jpg',
      "price": '500',
      "quantity": 1
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
          padding: EdgeInsets.only(left: 5.0, right: 10.0),
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

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Text("₹ " + cart_prod_price,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(cart_prod_name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black26,
                              fontSize: 15.0
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline,
                                color: Colors.redAccent,
                              ),
                              onPressed: (){},
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(cart_prod_qty.toString(),
                                style: TextStyle(
                                    color: Colors.black45
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: IconButton(
                                icon: Icon(Icons.add_circle_outline,
                                  color: Colors.lightGreen,
                                ),
                                onPressed: (){},
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
