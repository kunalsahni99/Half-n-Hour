
import 'sliding_cards.dart';

import 'package:flutter/material.dart';
import '../components/bottom_sheet.dart';

class HomeCategory extends StatelessWidget {
  final String category;
  HomeCategory({this.category});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 15),
                Header(category: category,),
                SizedBox(height: 25),


                SlidingCardsView(category:category),
              ],
            ),
          ),
          ExhibitionBottomSheet(),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String category;
  Header({
    this.category
});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Center(child:Text(
        category,
        style: TextStyle(color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
    ));
  }
}
