import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:HnH/screens/product_details.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  var product_list = [
    {
      "name": 'Fruits',
      "picture": 'images/products/fruits1.jpg',
      "old_price": '120',
      "price": '85',
    },
    {
      "name": 'Fruits',
      "picture": 'images/products/fruits2.jpg',
      "old_price": '100',
      "price": '50',
    },
    {
      "name": 'Veggies',
      "picture": 'images/products/veg1.jpeg',
      "old_price": '100',
      "price": '50',
    },
    {
      "name": 'Veggies',
      "picture": 'images/products/veg2.jpg',
      "old_price": '100',
      "price": '50',
    },
    {
      "name": 'Meds',
      "picture": 'images/products/med1.jpg',
      "old_price": '100',
      "price": '50',
    },
    {
      "name": 'Medicines',
      "picture": 'images/products/med2.jpg',
      "old_price": '100',
      "price": '50',
    },
    {
      "name": 'Lipstick',
      "picture": 'images/products/cos1.jpg',
      "old_price": '100',
      "price": '50',
    },
    {
      "name": 'Cream',
      "picture": 'images/products/cos2.jpg',
      "old_price": '100',
      "price": '50',
    },
    {
      "name": 'Milk',
      "picture": 'images/products/daily1.jpg',
      "old_price": '100',
      "price": '50',
    },
    {
      "name": 'Flour Powder',
      "picture": 'images/products/daily2.jpg',
      "old_price": '100',
      "price": '50',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: product_list.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,),
      itemBuilder: (BuildContext context, int index){
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: SingleProd(
            prod_name: product_list[index]['name'],
            prod_picture: product_list[index]['picture'],
            prod_old_price: product_list[index]['old_price'],
            prod_price: product_list[index]['price'],
          ),
        );
      },  
    );
  }
}

class SingleProd extends StatelessWidget {
  final prod_name;
  final prod_picture;
  final prod_old_price;
  final prod_price;

  SingleProd({
    this.prod_name,
    this.prod_price,
    this.prod_picture,
    this.prod_old_price
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        child: InkWell(
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(
              // passing the details of the product to Product Details screen
              builder: (BuildContext context) => ProductDetails(
                product_detail_name: prod_name,
                product_detail_picture: prod_picture,
                product_detail_new_price: prod_price,
                product_detail_old_price: prod_old_price,
              )
            )),
            child: GridTile(
              footer: Container(
                color: Colors.white70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(prod_name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0
                        ),
                      ),
                    ),

                    Text("\$$prod_price",
                      style: TextStyle(
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )
              ),
              child: Image.asset(prod_picture,
                fit: BoxFit.cover,
            ),
          ),
        )
      ),
    );
  }
}