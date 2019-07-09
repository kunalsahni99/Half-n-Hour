import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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

  const SlidingCard({
    Key key,
    @required this.imageUrl,
    @required this.name,
    @required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 24),
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
              )
          ),
          SizedBox(height: 8),
          Expanded(
            child: CardContent(
              name: name,
              price: price,
            ),
          )
        ],
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  final String name;
  final int price;

  const CardContent({
    Key key,
    @required this.name,
    @required this.price
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(name,
            style: TextStyle(
                fontSize: 20
            ),
          ),

          SizedBox(height: 8),
          Text(price.toString(),
            style: TextStyle(
            color: Colors.grey
            ),
          ),
        ],
      ),
    );
  }
}
