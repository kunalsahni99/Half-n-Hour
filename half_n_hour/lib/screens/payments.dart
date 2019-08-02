import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'cart.dart';

class ChoosePayments extends StatefulWidget {
  @override
  ChoosePaymentsState createState() => ChoosePaymentsState();
}

class ChoosePaymentsState extends State<ChoosePayments> {
  int radVal = 1, totProd = 0;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String UID = "";

  void handleRadioValue(int value){
    setState(() {
      radVal = value;
    });
  }

  @override
  void initState() {
    super.initState();
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
                    onPressed: (){

                    },
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
