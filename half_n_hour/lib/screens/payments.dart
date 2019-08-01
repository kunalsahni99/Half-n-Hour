import 'package:flutter/material.dart';

class ChoosePayments extends StatefulWidget {
  @override
  ChoosePaymentsState createState() => ChoosePaymentsState();
}

class ChoosePaymentsState extends State<ChoosePayments> {

  @override
  Widget build(BuildContext context) {
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


    );
  }
}
