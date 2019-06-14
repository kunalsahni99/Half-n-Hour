import 'package:flutter/material.dart';

class SetLoc extends StatefulWidget {
  @override
  _SetLocState createState() => _SetLocState();
}

class _SetLocState extends State<SetLoc> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 23.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset('images/location.png',
                fit: BoxFit.fill,
              ),
            ),
          )
        ],
      )
    );
  }
}