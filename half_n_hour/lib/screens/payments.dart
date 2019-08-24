import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../db/users.dart';
import 'dart:async';
import 'order_confirm.dart';
import 'cart.dart';

import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChoosePayments extends StatefulWidget {
  int totPrice, qty, price;
  bool isCart;
  String orderId;
  String title, imageUrl, Prod_id;

  ChoosePayments({
    this.totPrice,
    this.orderId,
    this.title,
    this.imageUrl,
    this.Prod_id,
    this.qty,
    this.price,
    @required this.isCart
  });
  @override
  ChoosePaymentsState createState() => ChoosePaymentsState();
}

class ChoosePaymentsState extends State<ChoosePayments> {
  int radVal = 1, totProd = 0;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String UID = "";
  static const platform = const MethodChannel("razorpay_flutter");

  Razorpay _razorpay;

  void handleRadioValue(int value){
    setState(() {
      radVal = value;
    });
  }

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getUID();
  }

  void getUID() async{
    final FirebaseUser user = await _auth.currentUser();
    setState(() {
      UID = user.uid;
    });

    Firestore.instance.collection("cart").document(UID).collection("cartItem").getDocuments().then((snapShot){
      setState(() {
        totProd = snapShot.documents.length;
      });
    });
  }


  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_4sA6oV5NKIjDIq',
      'amount': widget.totPrice*100,
      'name': 'Half n Hour PVT LTD',
      'description': 'OrderId: ${widget.orderId}',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void addToFireBase()async{
    final FirebaseUser user = await _auth.currentUser();

    if(widget.isCart){      // products are in cart collection in FireStore
      Firestore.instance.collection("cart").document(user.uid).collection("cartItem").getDocuments().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.documents) {
          Firestore.instance.collection("orders").document(user.uid).collection(widget.orderId).add({
            'prod_name': ds['title'],
            'prod_picture': ds['imageUrl'],
            'prod_price': ds['price'],
            'prod_qty': ds['qty'],
            'prod_id': ds['Prod_id'],
          });
          ds.reference.delete();
        }});
    }
    else{   // user has chosen the 'Buy Now' option
      Firestore.instance.collection("orders").document(user.uid).collection(widget.orderId).add({
        'prod_name': widget.title,
        'prod_picture': widget.imageUrl,
        'prod_price': widget.price,
        'prod_qty': widget.qty,
        'prod_id': widget.Prod_id,
      });
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response){
    goToOrderConfirm();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIos: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIos: 4);
  }

  void goToOrderConfirm(){
    UserServices().ShowDialog(context);
    addToFireBase();
    Timer(
        Duration(seconds: 2),
            (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => OrderConfirm(orderId: widget.orderId,)
          ));
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Price>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Payments',
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold
            ),
          ),
          backgroundColor: Colors.white70,
        ),

        body: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              height: 200.0,
              child: Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ListTile(
                        leading: Radio(
                          value: 1,
                          groupValue: radVal,
                          onChanged: handleRadioValue,
                        ),

                        title: Text('RazorPay',
                          style: TextStyle(
                              fontSize: 20.0
                          ),
                        ),

                        subtitle: Text('Pay using banks, Paytm etc.',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0
                          ),
                        ),

                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ListTile(
                        leading: Radio(
                          value: 2,
                          groupValue: radVal,
                          onChanged: handleRadioValue,
                        ),

                        title: Text('Cash on Delivery',
                          style: TextStyle(
                              fontSize: 20.0
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
              height: 275.0,
              child: Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                      child: Text('Price Details',
                        style: TextStyle(
                            fontSize: 15.0
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Divider(color: Colors.grey),
                    ),

                    ListTile(
                      title: Text('Price ($totProd ${totProd == 1 ? 'item' : 'items'})',
                        style: TextStyle(
                            fontSize: 15.0
                        ),
                      ),

                      trailing: Text('₹ ' + cart.totPrice.toString(),
                        style: TextStyle(
                            fontSize: 15.0
                        ),
                      ),
                    ),

                    ListTile(
                      title: Text('Delivery Charges',
                        style: TextStyle(
                            fontSize: 15.0
                        ),
                      ),

                      trailing: Text('Free',
                        style: TextStyle(
                            fontSize: 15.0
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Divider(color: Colors.grey),
                    ),

                    ListTile(
                      title: Text('Amount Payable',
                        style: TextStyle(
                            fontSize: 15.0
                        ),
                      ),

                      trailing: Text('₹ ' + cart.totPrice.toString(),
                        style: TextStyle(
                            fontSize: 15.0
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),

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
                    height: 50.0,
                    onPressed: radVal == 1 ?openCheckout: goToOrderConfirm,
                    color: Colors.white70,
                    child: Text(radVal == 1 ? 'Continue' : 'Place Order',
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0
                      ),
                    )
                ),
              )
            ],
          ),
        )
    );
  }
}
