import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ProductDetails extends StatefulWidget {
  final product_detail_name;
  final product_detail_picture;
  final product_detail_new_price;
  final product_detail_old_price;

  ProductDetails({
    this.product_detail_name,
    this.product_detail_picture,
    this.product_detail_new_price,
    this.product_detail_old_price
  });

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Text('Product Detail')
        ),
        backgroundColor: Colors.pinkAccent,
        elevation: 0.0,
        actions: <Widget>[
         IconButton(
           icon: Icon(
            Icons.search
           ),
           color: Colors.white,
           onPressed: (){},
         ),
        ],
      ),
      
      body: ListView(
        children: <Widget>[
          Container(
            height: 300.0,
            child: GridTile(
              child: Container(
                color: Colors.white,
                child: Image.asset(widget.product_detail_picture),
              ),
              footer: Container(
                color: Colors.white70,
                child: ListTile(
                  leading: Text(widget.product_detail_name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0
                    ),
                  ),
                  title: Row(
                    children: <Widget>[
                       Expanded(
                         child: Text("\$${widget.product_detail_old_price}",
                          style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough
                          ), 
                        ),
                       ),
                       Expanded(
                         child: Text("\$${widget.product_detail_new_price}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.pinkAccent
                          )
                        ),
                       ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // the first buttons
          Row(
            children: <Widget>[
              // the size button
              Expanded(
                child: MaterialButton(
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text('Qty'),
                          content: Text('Choose the size'),
                          actions: <Widget>[
                            MaterialButton(
                              onPressed: (){
                                Navigator.of(context).pop(context);
                              },
                              child: Text('Close'),)
                          ],
                        );
                      }
                    );
                  },
                  color: Colors.white,
                  elevation: 0.2,
                  textColor: Colors.grey,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('Size'),
                      ),
                      Expanded(
                        child: Icon(Icons.arrow_drop_down),
                      ),
                    ],
                  ),
                ),
              ),
              // the size button
              Expanded(
                child: MaterialButton(
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text('Qty'),
                          content: Text('Choose the color'),
                          actions: <Widget>[
                            MaterialButton(
                              onPressed: (){
                                Navigator.of(context).pop(context);
                              },
                              child: Text('Close'),)
                          ],
                        );
                      }
                    );
                  },
                  color: Colors.white,
                  elevation: 0.2,
                  textColor: Colors.grey,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('Color'),
                      ),
                      Expanded(
                        child: Icon(Icons.arrow_drop_down),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: MaterialButton(
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text('Qty'),
                          content: Text('Choose the qty'),
                          actions: <Widget>[
                            MaterialButton(
                              onPressed: (){
                                Navigator.of(context).pop(context);
                              },
                              child: Text('Close'),)
                          ],
                        );
                      }
                    );
                  },
                  color: Colors.white,
                  elevation: 0.2,
                  textColor: Colors.grey,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('Size'),
                      ),
                      Expanded(
                        child: Icon(Icons.arrow_drop_down),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // the second button
          Row(
            children: <Widget>[
              // the size button
              Expanded(
                child: MaterialButton(
                  onPressed: (){},
                  color: Colors.pinkAccent,
                  elevation: 0.2,
                  textColor: Colors.white,
                  child: Text('Buy Now')  
                ),
              ),

              IconButton(
                icon: Icon(Icons.add_shopping_cart,
                  color: Colors.pinkAccent,
                ),
                onPressed: (){},
              ),

              IconButton(
                icon: Icon(Icons.favorite_border,
                  color: Colors.pinkAccent,
                ),
                onPressed: (){},
              ),
            ],
          ),

          Divider(),

          ListTile(
            title: Text('Product Details'),
            subtitle: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
          ),

          Divider(),

          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: Text('Name',
                  style: TextStyle(
                    color: Colors.grey),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(widget.product_detail_name),
              )
            ],
          ),

          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: Text('Brand',
                  style: TextStyle(
                    color: Colors.grey),
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
                child: Text('Conditions',
                  style: TextStyle(
                    color: Colors.grey),
                ),
              ),

              // remember to edit this
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text('New Product'),
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
        crossAxisCount: 2,),
      itemBuilder: (BuildContext context, int index){
        return SimilarSingleProd(
          prod_name: product_list[index]['name'],
          prod_picture: product_list[index]['picture'],
          prod_old_price: product_list[index]['old_price'],
          prod_price: product_list[index]['price'],
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

  SimilarSingleProd({
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
                        color: Colors.pinkAccent,
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