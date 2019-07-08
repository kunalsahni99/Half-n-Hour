
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:HnH/screens/cart.dart';
import 'package:HnH/components/photo.dart';
import 'package:HnH/screens/product_details.dart';
import 'package:cached_network_image/cached_network_image.dart';


import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';


bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;


class HomeCategory extends StatefulWidget {

  final String category;


  HomeCategory(
      {
        this.category,
      });


  @override
  State<StatefulWidget> createState() => new home_category();
// TODO: implement createState

}

class home_category extends State<HomeCategory> {
  int totProd=0;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final Orientation orientation = MediaQuery.of(context).orientation;
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle =
    theme.textTheme.headline.copyWith(color: Colors.black54);
    final TextStyle descriptionStyle = theme.textTheme.subhead;
    ShapeBorder shapeBorder;





      return new Scaffold(

        appBar: new AppBar(
          iconTheme: IconThemeData(color: Colors.black87),
          backgroundColor: Colors.white70,

          title: Text(widget.category,
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


        body: new SingleChildScrollView(

          child: new Column(children: <Widget>[



            new Container(

              alignment: Alignment.topCenter,
              height: isIOS ? MediaQuery.of(context).size.height*photos.length/2.25 :
              MediaQuery.of(context).size.height,

              child:  StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection("products").where("category",isEqualTo: widget.category)
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
                    default:
                      return new GridView.count(
                        primary: false,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(10.0),
                        crossAxisCount: 2,
                        childAspectRatio: 2/3,


                        children:
                        snapshot.data
                            .documents.map((DocumentSnapshot document) {

                          return new
                          CategoryProduct(
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

    );
  }

  _verticalD() => Container(
    margin: EdgeInsets.only(left: 10.0, right: 0.0, top: 10.0, bottom: 0.0),
  );
}

class CategoryProduct extends StatefulWidget {
  final String imageUrl;
  final String title;
  final int price;
  final String Prod_id;
  final String category;
  final String desc;

  CategoryProduct({
    this.imageUrl,
    this.title,
    this.price,
    this.Prod_id,
    this.category,
    this.desc
  });

  @override
  _CategoryProductState createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  @override
  Widget build(BuildContext context) {
    return new Container(



        child: new GestureDetector(

            onTap: ()async{


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




            },
            child: new Container(



                margin: EdgeInsets.fromLTRB(3, 5, 3, 5),


                child: new Material(

                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0)
                    ),
                    elevation: 8.0,
                    child: Stack(


                      children: <Widget>[
                        Container(
                          height:MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Stack(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(40.0),
                                  child: CachedNetworkImage(
                                    placeholder: (context, val) => Container(
                                      width: 100,
                                      height: 100,
                                      child: CircularProgressIndicator(
                                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.black87),
                                      ),
                                    ),
                                    imageUrl: widget.imageUrl,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Container(


                          padding: EdgeInsets.fromLTRB(0,180,0,0),

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
                                    fontSize: 15.0
                                ),
                              ),
                              subtitle: Container(
                                padding: EdgeInsets.fromLTRB(0,10,0,5),
                                child: Text("₹" + widget.price.toString(),
                                  style: TextStyle(
                                      color: Colors.black26,
                                      fontSize: 16.0,fontWeight: FontWeight.w900
                                  ),
                                ),
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 20.0),

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
