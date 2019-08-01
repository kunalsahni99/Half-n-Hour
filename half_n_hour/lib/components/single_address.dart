import 'package:flutter/material.dart';

class SingleAddress extends StatefulWidget {
  final String addLine1;
  final String addLine2;
  final String pin;
  final String Uname;

  SingleAddress({
    this.addLine1,
    this.addLine2,
    this.pin,
    this.Uname
  });

  @override
  _SingleAddressState createState() => _SingleAddressState();
}

class _SingleAddressState extends State<SingleAddress> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widget.Uname,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20.0
          ),
        ),

        Padding(
          padding: EdgeInsets.all(6.0),
        ),

        Text(widget.addLine1,
          style: TextStyle(
              color: Colors.black45
          ),
        ),

        _verticalDivider(),

        Text(widget.addLine2,
          style: TextStyle(
              color: Colors.black45
          ),
        ),

        _verticalDivider(),

        Text(widget.pin,
          style: TextStyle(
              color: Colors.black45
          ),
        ),
      ],
    );
  }

  _verticalDivider() => Container(
    padding: EdgeInsets.all(3.0),
  );
}
