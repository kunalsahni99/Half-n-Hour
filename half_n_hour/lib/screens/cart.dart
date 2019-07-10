import 'package:HnH/components/cart_products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'as foundation;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../animations/fab_fill_transition.dart';
bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class Cart extends StatefulWidget {
  const Cart({Key key, @required this.sourceRect})
      : assert(sourceRect != null),
        super(key: key);

  static Route<dynamic> route(BuildContext context, GlobalKey key) {
    final RenderBox box = key.currentContext.findRenderObject();
    final Rect sourceRect = box.localToGlobal(Offset.zero) & box.size;

    return PageRouteBuilder<void>(
      pageBuilder: (BuildContext context, _, __) => Cart(sourceRect: sourceRect),
      transitionDuration: const Duration(milliseconds: 600),
    );
  }

  final Rect sourceRect;

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  String fabIcon = 'http://a.rgbimg.com/cache1CzrYE/users/t/ta/tacluda/600/qa7Ndkk.jpg';
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Price>(context);
    return FabFillTransition(
        source: widget.sourceRect,
        icon: fabIcon,

    child: Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white70,
        title: InkWell(
          onTap: () => Navigator.pop(context),
          child: Text('My Cart',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87
            ),
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
                subtitle: Text('₹ ${cart.totPrice}'),
              ),
            ),

            Expanded(
              child: MaterialButton(
                  onPressed: (){},
                  color: Colors.white70,
                  child: Text('Check Out',
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    )
    );}
}

class SingleCartProduct extends StatefulWidget {
  final String cart_prod_name;
  final String cart_prod_picture;
  final int cart_prod_price;
  final int cart_prod_qty;
  final String cart_prod_id;

  SingleCartProduct({
    this.cart_prod_name,
    this.cart_prod_picture,
    this.cart_prod_price,
    this.cart_prod_qty,
    this.cart_prod_id
  });

  @override
  _SingleCartProductState createState() => _SingleCartProductState();
}

class _SingleCartProductState extends State<SingleCartProduct> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int currQty, temp;

  @override
  void initState() {
    super.initState();
    currQty = widget.cart_prod_qty;
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Price>(context);

    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 5.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        elevation: 3.0,
        child: Container(
          padding: EdgeInsets.only(left: 5.0, right: 10.0),
          width: MediaQuery.of(context).size.width - 20.0,
          height: 150.0,
          decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(20.0)
          ),
          child: Row(
            children: <Widget>[
              SizedBox(width: 0.0),
              Container(
                height: 150.0,
                width: 125.0,
                child:ClipRRect(



                  borderRadius: BorderRadius.circular(15.0),
                  child: CachedNetworkImage(
                      fit: BoxFit.cover,
                    placeholder: (context, val) => Container(


                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.black87),
                      ),
                    ),
                    imageUrl: widget.cart_prod_picture,
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Text("₹ " + widget.cart_prod_price.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(widget.cart_prod_name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black26,
                              fontSize: 15.0
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline,
                                color: Colors.redAccent,
                              ),
                              onPressed: ()async{
                                final FirebaseUser user = await _auth.currentUser();

                                if (currQty <= 1){
                                  setState(() {
                                    Firestore.instance.collection("cart").document(user.uid).collection("cartItem")
                                        .document(widget.cart_prod_id.toString()).delete();
                                  });
                                }
                                else{
                                  setState(() {
                                    currQty--;
                                  });
                                }
                                cart.decrease(widget.cart_prod_price);

                                Firestore.instance.collection("cart").document(user.uid).collection("cartItem")
                                    .document(widget.cart_prod_id.toString())
                                    .updateData({'qty': currQty});
                              },
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(currQty.toString(),
                                style: TextStyle(
                                    color: Colors.black45
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: IconButton(
                                icon: Icon(Icons.add_circle_outline,
                                  color: Colors.lightGreen,
                                ),
                                onPressed: ()async{
                                  final FirebaseUser user = await _auth.currentUser();

                                  if (currQty >= 25){
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text("You can't add more of this item"),
                                    ));
                                  }
                                  else{
                                    setState(() {
                                      currQty++;
                                      cart.increase(widget.cart_prod_price);
                                    });
                                  }


                                  Firestore.instance.collection("cart").document(user.uid).collection("cartItem")
                                      .document(widget.cart_prod_id.toString())
                                      .updateData({'qty': currQty});
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Price extends ChangeNotifier{
  int totPrice = 0;

  void increase(int price){
    totPrice += price;
    notifyListeners();
  }

  void setPrice(int price){
    totPrice = price;
    notifyListeners();
  }

  void decrease(int price){
    totPrice -= price;
    notifyListeners();
  }
}
