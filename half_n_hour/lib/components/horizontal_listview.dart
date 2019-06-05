import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Category(
            image_location: 'images/fruits.png',
            image_caption: 'Fruits'
          ),

          Category(
            image_location: 'images/vegetables.png',
            image_caption: 'Vegetables'
          ),

          Category(
            image_location: 'images/daily_goods.png',
            image_caption: 'Daily\ngoods'
          ),

          Category(
            image_location: 'images/medicines.png',
            image_caption: 'Medicines'
          ),

          Category(
            image_location: 'images/cosmetics.png',
            image_caption: 'Cosmetics'
          ),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String image_location;
  final String image_caption;

  Category({
    this.image_location,
    this.image_caption
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: (){},
        child: Container(
          width: 120.0,
          child: ListTile(
            title: Image.asset(image_location,
              width: 40.0,
              height: 40.0
            ),
            subtitle: Container(
              alignment: Alignment.topCenter,
              child: Text(image_caption)
            ),
          ),
        ),
      ),
    );
  }
}