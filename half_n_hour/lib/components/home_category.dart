import 'package:HnH/screens/sliding_cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/cupertino.dart';
import 'package:HnH/screens/cart.dart';
import 'exhibition_bottom_sheet.dart';
import 'dart:ui';

import 'package:flutter/foundation.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class HomeCategory extends StatefulWidget {
  final String category;

  HomeCategory({this.category,});

  @override
  State<StatefulWidget> createState() => new home_category();
}

class home_category extends State<HomeCategory> {
  int totProd=0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    theme.textTheme.headline.copyWith(color: Colors.black54);

    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Header(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 8),
                Container(
                    padding: EdgeInsets.only(top: 180),
                    child: SlidingCardsView(category: widget.category,))
              ],
            ),
          ),
          ExhibitionBottomSheet()
        ],
      )

    );
  }
}

class Header extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 250.0,
          width: double.infinity,
          color: Colors.yellow.withOpacity(0.2),
        ),
        Positioned(
          bottom: 50.0,
          right: 100.0,
          child: Container(
            height: 400.0,
            width: 400.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200.0),
              color: Color(0xFEE16D).withOpacity(0.4),
            ),
          ),
        ),
        Positioned(
          bottom: 100.0,
          left: 150.0,
          child: Container(
            height: 300.0,
            width: 300.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150.0),
              color: Color(0xFEE16D).withOpacity(0.5),
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 30, left: 30),
            child: ListTile(
              leading: Text('Products',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.close,
                  color: Colors.black87,
                  size: 28,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            )
        )
      ],
    );
  }
}

/*class CategoryProduct extends StatefulWidget {
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
}*/
