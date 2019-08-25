import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: Colors.black87,
          ),
        ),
        title: Text('My Orders',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold
          ),
        ),
      ),

      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SingleOrder(
            OrdID: "ORD123456",
            OrdDate: "May 16th '19",
            OrdTotal: "₹ 200",
            imageUrl: "images/apple.jpg",
          ),

          SingleOrder(
            OrdID: "ORD121212",
            OrdDate: "Jul 18th '19",
            OrdTotal: "₹ 100",
            imageUrl: "images/eggs.jpg",
          ),

          SingleOrder(
            OrdID: "ORD987654",
            OrdDate: "Aug 10th '19",
            OrdTotal: "₹ 200",
            imageUrl: "images/bev.jpg",
          ),

          SingleOrder(
            OrdID: "ORD291019",
            OrdDate: "Jan 12th '19",
            OrdTotal: "₹ 50",
            imageUrl: "images/veg.jpg",
          ),

          SingleOrder(
            OrdID: "ORD180520",
            OrdDate: "Dec 8th '18",
            OrdTotal: "₹ 10",
            imageUrl: "images/lemons.jpg",
          ),
        ],
      )
    );
  }
}

class SingleOrder extends StatefulWidget {
  final String OrdID;
  final String OrdDate;
  final String OrdTotal;
  final String imageUrl;

  SingleOrder({
    this.OrdID,
    this.OrdDate,
    this.OrdTotal,
    this.imageUrl
  });

  @override
  _SingleOrderState createState() => _SingleOrderState();
}

class _SingleOrderState extends State<SingleOrder> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      elevation: 3.0,
      child: Container(
        padding: EdgeInsets.only(right: 10.0),
        width: MediaQuery.of(context).size.width - 20.0,
        height: 150.0,
        decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20.0)
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 120.0,
                      decoration: BoxDecoration(
                        color: Color(0xFF7A9BEE),
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(widget.OrdID,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: Text('Order placed on:\n${widget.OrdDate}'),
                    ),
                    
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: Text('Order Total:  ${widget.OrdTotal}'),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(width: 0.0),
            Expanded(
              flex: 1,
              child: Container(
                width: 75.0,
                height: 75.0,
                child: Image.asset(widget.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
