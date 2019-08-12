import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/single_address.dart';
import 'cart.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class OrderConfirm extends StatefulWidget {

  @override
  _OrderConfirmState createState() => _OrderConfirmState();
}

class _OrderConfirmState extends State<OrderConfirm> {
  String address1Line1 = "", address1Line2 = "", address1pin = "";
  String address2Line1 = "", address2Line2 = "", address2pin = "";
  String username;
  int delAdd = 1;
  SharedPreferences _preferences;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getPrefers();
  }

  Future<Null> getPrefers() async{
    _preferences = await SharedPreferences.getInstance();
    final FirebaseUser user = await auth.currentUser();

    address1Line1 = _preferences.getString("address1Line1") ?? "";
    address1Line2 = _preferences.getString("address1Line2") ?? "";
    address1pin = _preferences.getString("address1pin") ?? "";

    address2Line1 = _preferences.getString("address2Line1") ?? "";
    address2Line2 = _preferences.getString("address2Line2") ?? "";
    address2pin = _preferences.getString("address2pin") ?? "";

    delAdd = _preferences.getInt("DelAdd") ?? 1;
    setState(() {
      username = user.displayName;
    });
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Price>(context);

    return WillPopScope(
      onWillPop: ()async{
        cart.setPrice(0);
        Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
        return null;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white70,
          leading: IconButton(
            icon: Icon(isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              color: Colors.black87,
            ),
            onPressed: (){
              cart.setPrice(0);
              Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
            },
          ),

          title: Text('Order Confirmation',
            style: TextStyle(
              color: Colors.black87
            ),
          ),
        ),

        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Image.asset('images/green_tick.gif',
                      fit: BoxFit.cover,
                    )
                ),

                Container(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Text('Order successfully placed!',
                          style: TextStyle(
                              fontSize: 20.0
                          ),
                        ),
                      ),
                      Text('Your order will be delivered between'),
                      Text('xx:am and xx:xx am',
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),

                      Text("We're pleased to confirm your order no"),
                      Text('ORDxxxxxxxxxx',
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          )
                      ),

                      Text('Thank you for shopping with Half Hour!')
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Divider(color: Colors.grey),
                ),

                Text('Delivery address:',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: address1Line1 != "" && delAdd == 1 ?
                                SingleAddress(
                                  addLine1: address1Line1,
                                  addLine2: address1Line2,
                                  pin: address1pin,
                                  Uname: username,
                                ) :
                                SingleAddress(
                                  addLine1: address2Line1,
                                  addLine2: address2Line2,
                                  pin: address2pin,
                                  Uname: username,
                                ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 50.0, right: 10.0),
                              child: MaterialButton(
                                onPressed: (){},
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                color: Color(0xFF7A9BEE),
                                textColor: Colors.white,
                                child: Text('Change',
                                  style: TextStyle(
                                      fontSize: 17.0
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}
