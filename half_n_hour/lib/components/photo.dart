import 'package:flutter/material.dart';
import 'dart:collection';


List<Photo> photos = <Photo>[
  Photo(
      imageUrl: 'images/veg.jpg',
      title: 'Fruits',
      category: 'Fruits & Vegetables',
      price: '75',
      Prod_id: 0,
      desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
  ),
  Photo(
      imageUrl: 'images/frozen.jpg',
      title: 'Peas',
      category: 'Frozen Veg',
      price: '100',
      Prod_id: 1,
      desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
  ),
  Photo(
      imageUrl: 'images/bev.jpg',
      title: 'Tea',
      category: 'Beverages',
      price: '100',
      Prod_id: 2,
      desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum"
  ),
  Photo(
      imageUrl: 'images/brand_f.jpg',
      title: 'Shaktibhog Atta',
      category: 'Brannded Food',
      price: '500',
      Prod_id: 3,
      desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
  ),
  Photo(
      imageUrl: 'images/be.jpg',
      title: 'Lipstick',
      category: 'Beauty & Personal Care',
      price: '200',
      Prod_id: 4,
      desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
  ),
  Photo(
      imageUrl: 'images/home.jpg',
      title: 'Table',
      category: 'Home Care & Fashion',
      price: '10000',
      Prod_id: 5,
      desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
  ),
  Photo(
      imageUrl: 'images/eggs.jpg',
      title: 'Cake',
      category: 'Dairy, Bakery & Eggs',
      Prod_id: 6,
      price: '200',
      desc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
  ),
];

class CartModel extends ChangeNotifier{
  final List<Photo> _items = [];

  UnmodifiableListView<Photo> get items => UnmodifiableListView(_items);

  void add(Photo photo){
    _items.add(photo);
    print(photo);
    notifyListeners();
  }
}

@immutable
class Photo {
  Photo({
    this.Prod_id,
    this.imageUrl,
    this.price,
    this.title,
    this.desc,
    this.category,
    this.qty
  });

  final String imageUrl;
  final String category;
  final String title;
  final String desc;
  final String price;
  final int Prod_id;
  final int qty;
}