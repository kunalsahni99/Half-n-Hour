import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: isIOS ? true : false,
        title: Text("About Us"),
        backgroundColor: Colors.pinkAccent,
        leading: IconButton(
          icon: Icon(isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
