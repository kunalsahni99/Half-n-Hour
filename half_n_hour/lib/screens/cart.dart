import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'as foundation;
import 'package:flutter/cupertino.dart';

import 'package:HnH/components/cart_products.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white70,
        title: Text('My Cart',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
                Icons.search
            ),
            color: Colors.black87,
            onPressed: (){},
          ),
        ],
        leading: IconButton(
          icon: Icon(isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),

      body: CartProducts(),

      bottomNavigationBar: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: Text('Total'),
                subtitle: Text('\$230'),
              ),
            ),

            Expanded(
              child: MaterialButton(
                  onPressed: (){},
                  color: Colors.pinkAccent,
                  child: Text('Check Out',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}