import 'package:HnH/screens/product_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

class SlidingCardsView extends StatefulWidget {
  final String category;

  SlidingCardsView({this.category});

  @override
  _SlidingCardsViewState createState() => _SlidingCardsViewState();
}

class _SlidingCardsViewState extends State<SlidingCardsView> {
  PageController pageController;
  double pageOffset = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      viewportFraction: 0.8
    );
    pageController.addListener((){
      pageOffset = pageController.page;
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
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
          case ConnectionState.waiting:
            return Center(child: new CircularProgressIndicator(
              backgroundColor: Colors.white70,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.black87),
            )
            );
          default:
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: new PageView.builder(
                controller: pageController,
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index){
                  final document = snapshot.data.documents[index];

                  return SlidingCard(
                    imageUrl: document['imageUrl'],
                    name: document['title'],
                    price: document['price'],
                    offset: pageOffset - index,
                    index: index,
                    cat: widget.category,
                    desc: document['desc'],
                    Prod_id: document['Prod_id'],
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
  final String name;
  final String imageUrl;
  final int price;
  final double offset;
  final int index;
  final String Prod_id;
  final String desc;
  final String cat;

  const SlidingCard({
    Key key,
    @required this.imageUrl,
    @required this.name,
    @required this.price,
    @required this.offset,
    @required this.index,
    @required this.cat,
    @required this.Prod_id,
    @required this.desc
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));

    return Transform.translate(
      offset: Offset(-32 * gauss * offset.sign, 0),
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => ProductDetails(
              imageUrl: imageUrl,
              title: name,
              price: price,
              category: cat,
              Prod_id: Prod_id,
              desc: desc,
              index: index,
            )
          ));
        },
        child: Tooltip(
          message: "Click this to view product details",
          child: Card(
            margin: EdgeInsets.only(left: 8, right: 8, bottom: 100),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32)
                    ),
                    child: Hero(
                      flightShuttleBuilder: (BuildContext flightContext,
                          Animation<double> animation,
                          HeroFlightDirection flightDirection,
                          BuildContext fromHeroContext,
                          BuildContext toHeroContext){
                        final Hero toHero = toHeroContext.widget;

                        return FadeTransition(
                          opacity: animation.drive(
                            Tween<double>(begin: 0.0, end: 1.0).chain(
                              CurveTween(
                                curve: Interval(0.0, 1.0,
                                  curve: ValleyQuadraticCurve()
                                )
                              )
                            ),
                          ),
                          child: toHero.child,
                        );
                      },
                      placeholderBuilder: (context, child){
                        return Opacity(opacity: 0.2, child: child,);
                      },
                      tag: 'prod $index',
                      child: CachedNetworkImage(
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.cover,
                        placeholder: (context, val) => Container(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(Colors.black87),
                          ),
                        ),
                        imageUrl: imageUrl,
                      ),
                    )
                ),
                SizedBox(height: 8),
                Expanded(
                  child: CardContent(
                    name: name,
                    price: price,
                    offset: gauss,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ValleyQuadraticCurve extends Curve {
  @override
  double transform(double t) {

    assert(t >= 0.0 && t <= 1.0);

    return 4 * math.pow(t - 0.5, 2);
  }
}

class CardContent extends StatelessWidget {
  final String name;
  final int price;
  final double offset;

  const CardContent({
    Key key,
    @required this.name,
    @required this.price,
    @required this.offset
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: ListTile(
        title: Text(name,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 20
          ),
        ),

        subtitle: Container(
          padding: EdgeInsets.only(top: 2.0),
          child: Text("₹ " + price.toString(),
            style: TextStyle(
              color: Colors.grey
            ),
          ),
        ),
        
        trailing: MaterialButton(
          onPressed: (){
            
          },
          textColor: Colors.white,
          color: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
          ),
          child: Text('Add to Cart'),
        ),
      )
    );
  }
}
