import 'package:flutter/material.dart';

class CartProducts extends StatefulWidget {
  @override
  _CartProductsState createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {
  var Products_on_Cart = [
    {
      "name": 'Fruits',
      "picture": 'images/products/fruits1.jpg',
      "price": '85',
      "size": 'M',
      "color": 'Black',
      "quantity": 1
    },
    {
      "name": 'Veggies',
      "picture": 'images/products/veg1.jpeg',
      "price": '50',
      "size": 'XL',
      "color": 'Red',
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
          cart_prod_size: Products_on_Cart[index]['size'],
          cart_prod_color: Products_on_Cart[index]['color'],
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
  final cart_prod_size;
  final cart_prod_color;
  final cart_prod_qty;

  SingleCartProduct({
    this.cart_prod_name,
    this.cart_prod_picture,
    this.cart_prod_price,
    this.cart_prod_size,
    this.cart_prod_color,
    this.cart_prod_qty
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset(cart_prod_picture,
        ),
        title: Text(cart_prod_name),
        subtitle: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Text('Size:'),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(cart_prod_size,
                    style: TextStyle(
                      color: Colors.pink
                    ),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 8.0, 8.0),
                  child: Text('Color:'),
                ),

                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(cart_prod_color,
                    style: TextStyle(
                      color: Colors.pink
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                    child: IconButton(
                      icon: Icon(Icons.remove_circle),
                      color: Colors.red,
                      onPressed: (){},
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 8.0, 0.0, 8.0),
                    child: Text('$cart_prod_qty')
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                    child: IconButton(
                      icon: Icon(Icons.add_circle),
                      color: Colors.green,
                      onPressed: (){},
                    ),
                  ),
                ),
              ],
            ),

            Container(
              alignment: Alignment.topLeft,
              child: Text('\$$cart_prod_price',
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink
                ),
              ),
            ),
          ],
        ),
        /*trailing: Column  (
          children: <Widget>[
            Expanded(
              child: IconButton(
                icon: Icon(Icons.arrow_drop_up),
                onPressed: (){},
              ),
            ),
            Expanded(
              child: Text('$cart_prod_qty')
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.arrow_drop_down),
                onPressed: (){},
              ),
            ),
          ],
        ),*/
        contentPadding: EdgeInsets.all(5.0)
      ),
    );
  }
}