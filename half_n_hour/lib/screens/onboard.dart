import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

import './home_page.dart';
import './login.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();

}

class _OnBoardingState extends State<OnBoarding>{
  bool loading = false;

  final pages = [
    PageViewModel(
        pageColor: const Color(0xFF8BC34A),
        bubble: Image.asset('images/fruits.png'),
        body: Column(
          children: <Widget>[
            Text('Get Fruits and Vegetables in just',
              style: TextStyle(
                  color: Colors.white
              ),
            ),
            Text('Half n Hour',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
        title: Text('Groceries'),
        mainImage: Image.asset('images/daily.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        )
    ),

    PageViewModel(
      pageColor: const Color(0xFF03A9F4),
      bubble: Image.asset('images/daily_goods.png'),
      body: Text('Hassle-free delivery of your daily needs'),
      title: Text('Daily Goods'),
      mainImage: Image.asset(
        'images/daily_goods.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
    ),

    PageViewModel(
      pageColor: const Color(0xFF607D8B),
      bubble: Image.asset('images/medicines.png'),
      body: Text('Get medicines at the comfort of your home'),
      title: Text('Medicines'),
      mainImage: Image.asset(
        'images/med.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Builder(
            builder: (context) => IntroViewsFlutter(
              pages,
              onTapDoneButton: (){
                setState(() {
                  loading = true;
                });
                Timer(
                    Duration(seconds: 1),
                        (){
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => MyHomePage()
                      ));
                    }
                );
              },
              onTapSkipButton: (){
                setState(() {
                  loading = true;
                });
                Timer(
                  Duration(seconds: 1),
                  (){
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => Login()
                    ));
                  }
                );
              },
              pageButtonTextStyles: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0
              ),
            ),
          ),

          Visibility(
            visible: loading ?? true,
            child: Center(
              child: Container(
                alignment: Alignment.center,
                color: Colors.white.withOpacity(0.9),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
