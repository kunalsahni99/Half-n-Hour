import 'dart:math' as math;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const double minHeight = 120;
const double iconStartSize = 44;
const double iconEndSize = 120;
const double iconStartMarginTop = 36;
const double iconEndMarginTop = 80;
const double iconsVerticalSpacing = 24;
const double iconsHorizontalSpacing = 16;

class ExhibitionBottomSheet extends StatefulWidget {
  @override
  _ExhibitionBottomSheetState createState() => _ExhibitionBottomSheetState();
}

class _ExhibitionBottomSheetState extends State<ExhibitionBottomSheet> with SingleTickerProviderStateMixin{
  AnimationController _controller;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String UID;
  int totProd = 0;

  double get maxHeight => MediaQuery.of(context).size.height;
  double get headerTopMargin => lerp(20, 20 + MediaQuery.of(context).padding.top);

  double get headerFontSize => lerp(14, 24);
  double get itemBorderRadius => lerp(8, 24);

  double get iconLeftBorderRadius => itemBorderRadius;

  double get iconRightBorderRadius => lerp(8, 0);

  double get iconSize => lerp(iconStartSize, iconEndSize);

  double iconTopMargin(int index) => lerp(iconStartMarginTop,
      iconEndMarginTop + index * (iconsVerticalSpacing + iconEndSize)) + headerTopMargin;

  double iconLeftMargin(int index) => lerp(index * (iconsHorizontalSpacing + iconStartSize), 0);

  double lerp(double min, double max) =>
      lerpDouble(min, max, _controller.value);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 600)
    );
    getUID();
  }

  void getUID()async{
    final FirebaseUser user = await auth.currentUser();

    setState(() {
      UID = user.uid;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle(){
    final bool isOpen = _controller.status == AnimationStatus.completed;
    _controller.fling(velocity: isOpen ? -2 : 2);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child){
        return Positioned(
          height: lerp(minHeight, maxHeight),
          left: 0,
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: _toggle,
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragEnd: _handleDragEnd,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16))
              ),
              child: Stack(
                children: <Widget>[
                  CartButton(),
                  SheetHeader(
                    fontSize: headerFontSize,
                    topMargin: headerTopMargin,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection("cart")
                        .document(UID)
                        .collection("cartItem")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState){
                        case (ConnectionState.waiting):
                          return Center(child: new CircularProgressIndicator(
                            backgroundColor: Colors.white70,
                            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                          );
                        default:
                          return Stack(
                            overflow: Overflow.clip,
                            children: snapshot.data.documents.map((document){
                              return _buildFullItem(document['title'], document['price'], snapshot.data.documents.indexOf(document));
                            }
                            ).toList(),
                          );
                      }
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection("cart")
                        .document(UID)
                        .collection("cartItem")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState){
                        case (ConnectionState.waiting):
                          return Center(child: new CircularProgressIndicator(
                            backgroundColor: Colors.white70,
                            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                          );
                        default:
                          return Stack(
                            overflow: Overflow.clip,
                            children: snapshot.data.documents.map((document){
                              return _buildIcon(document['imageUrl'], snapshot.data.documents.indexOf(document));
                            }
                            ).toList(),
                          );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleDragUpdate(DragUpdateDetails details){
    _controller.value -= details.primaryDelta / maxHeight;
  }

  void _handleDragEnd(DragEndDetails details){
    if (_controller.isAnimating || _controller.status == AnimationStatus.completed) return;

    final double flingVelocity = details.velocity.pixelsPerSecond.dy / maxHeight;
    if (flingVelocity < 0.0){
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    }
    else if (flingVelocity > 0.0){
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    }
    else _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
  }

  Widget _buildIcon(String imageUrl, int index){
    return Positioned(
      height: iconSize,
      width: iconSize,
      top: iconTopMargin(index),
      left: iconLeftMargin(index),
      child: ClipRRect(
        borderRadius: BorderRadius.horizontal(
            left: Radius.circular(iconLeftBorderRadius),
            right: Radius.circular(iconRightBorderRadius)
        ),
        child: CachedNetworkImage(
          placeholder: (context, val) => CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.black87),
          ),
          imageUrl: imageUrl,
        )
      ),
    );
  }

  Widget _buildFullItem(String title, int price, int index){
    return ExpandedEventItem(
      topMargin: iconTopMargin(index),
      leftMargin: iconLeftMargin(index),
      height: iconSize,
      isVisible: _controller.status == AnimationStatus.completed,
      borderRadius: itemBorderRadius,
      title: title,
      price: price,
    );
  }
}

final List<Event> events = [
  Event('steve-johnson.jpeg', 'Title 1', '20'),
  Event('efe-kurnaz.jpg', 'Title 2', '40'),
  Event('rodion-kutsaev.jpeg', 'Title 3', '50'),
];

class Event{
  final String imageUrl;
  final String title;
  final String price;

  Event(this.imageUrl, this.title, this.price);
}

class ExpandedEventItem extends StatelessWidget {
  final double topMargin;
  final double leftMargin;
  final double height;
  final bool isVisible;
  final double borderRadius;
  final String title;
  final int price;

  const ExpandedEventItem(
      {Key key,
        this.topMargin,
        this.leftMargin,
        this.height,
        this.isVisible,
        this.borderRadius,
        this.title,
        this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topMargin,
      left: leftMargin,
      right: 0,
      height: height,
      child: AnimatedOpacity(
        opacity: isVisible ? 1 : 0,
        duration: Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: Colors.white
          ),
          padding: EdgeInsets.only(left: height).add(EdgeInsets.all(8)),
          child: Column(
            children: <Widget>[
              Text(title,
                style: TextStyle(
                    fontSize: 16
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Text('Qty: 1',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.grey.shade600
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(price.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        color: Colors.grey
                    ),
                  )
                ],
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}

class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 24,
      child: IconButton(
        icon: Icon(Icons.shopping_cart,
          color: Colors.white,
          size: 28,
        ),
        onPressed: (){},
      ),
    );
  }
}


class SheetHeader extends StatelessWidget {
  final double fontSize;
  final double topMargin;

  const SheetHeader(
      {Key key, @required this.fontSize, @required this.topMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topMargin,
      child: Text('My Cart',
        style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w500
        ),
      ),
    );
  }
}
