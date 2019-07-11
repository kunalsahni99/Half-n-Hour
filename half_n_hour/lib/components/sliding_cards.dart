import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../screens/product_details.dart';
class SlidingCardsView extends StatefulWidget {
  final String category;
  SlidingCardsView({
    this.category

});
  @override
  _SlidingCardsViewState createState() => _SlidingCardsViewState();
}

class _SlidingCardsViewState extends State<SlidingCardsView> {
  PageController pageController;
  double pageOffset = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.8);
    pageController.addListener(() {
      setState(() => pageOffset = pageController.page);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("products").where("category",isEqualTo: widget.category)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {

          default:
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,

              child: new PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: pageController,
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.documents.length,

                itemBuilder: (context, index){
                  final document = snapshot.data.documents[index];

                  return SlidingCard(
                    imageUrl: document['imageUrl'],
                    title: document['title'],
                    price:document['price'],
                    desc:document['desc'],
                    offset: pageOffset - index,
                    index: index,
                    category: widget.category,
                    prod_id: document['Prod_id'],

                  );
                },
              ),
            );
        }
      },
    );
  }
}

class SlidingCard extends StatelessWidget {
  final String title;
  final String category;
  final String imageUrl;
  final double offset;
  final int price;
  final String prod_id;
  final String desc;
  final index;

  const SlidingCard({
    Key key,
    @required this.title,
    @required this.category,
    @required this.imageUrl,
    @required this.offset,
    this.price,this.prod_id,this.desc,this.index
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));
    return Transform.translate(
      offset: Offset(-32 * gauss * offset.sign, 0),
      child: Container(
        child:InkWell(
          onTap:(){
            Navigator.push(context, FadeRouteBuilder(
                page: ProductDetails(
                  imageUrl: imageUrl,
                  title: title,
                  price: price,
                  category: category,
                  Prod_id: prod_id,
                  desc: desc,
                  index: index,
                )
            ));
          },
        child:Card(

        margin: EdgeInsets.only(left: 8, right: 8, bottom: 10),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              child: CachedNetworkImage(
                height: MediaQuery.of(context).size.height * 0.4,

                alignment: Alignment(-offset.abs(), 1),
                fit: BoxFit.fitHeight,
                placeholder: (context, val) => Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black87),
                  ),
                ),
                imageUrl: imageUrl,
              ),
            ),

            Expanded(
              child: CardContent(
                title: title,
                price: price,
                prod_id: prod_id,
                category: category,
                imageUrl: imageUrl,

                offset: gauss,
              ),
            ),
          ],
        ),
      ),
      )

    )); }
}
class FadeRouteBuilder<T> extends PageRouteBuilder<T>{
  final Widget page;

  FadeRouteBuilder({@required this.page})
      : super(
      transitionDuration: Duration(milliseconds:700),
      pageBuilder: (context, anim1, anim2) => page,
      transitionsBuilder: (context, a1, a2, child){
        return FadeTransition(opacity: a1 , child: child);
      }
  );
}

class CardContent extends StatelessWidget {
  final String title;
  final int price;
  final double offset;
  final String category;
  final String prod_id;
  final String imageUrl;


  const CardContent({
    Key key,
    @required this.title,
    @required this.price,
    @required this.offset,
    this.category,
    this.prod_id,this.imageUrl
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(


        padding: EdgeInsets.only(left: 10,right: 10),
        child:Container(
          alignment: Alignment.centerLeft,
        child: ListTile(
          title: Text(title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 15,fontWeight: FontWeight.bold
            ),
          ),


          subtitle: Container(
            padding: EdgeInsets.only(top: 2.0),
            child: Text("₹ " + price.toString(),
              style: TextStyle(
                  color: Colors.grey,fontWeight: FontWeight.bold
              ),
            ),
          ),

          trailing: MaterialButton(


            onPressed: ()async{
              FirebaseAuth auth = FirebaseAuth.instance;

              final FirebaseUser _user = await auth.currentUser();

              Firestore.instance
                  .collection("cart")
                  .document(_user.uid)
                  .collection("cartItem")
                  .document(prod_id.toString())
                  .setData({
                "imageUrl": imageUrl,
                "title": title,
                "price": price,
                "qty": 1,
                "Prod_id": prod_id
              });
              Fluttertoast.showToast(msg: "Added to cart");
            },
            textColor: Colors.white,
            color: Colors.black87,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            child: Text('Add to Cart'),
          ),
        )
    ));
  }
}
