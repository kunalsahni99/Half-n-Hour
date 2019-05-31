import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

import 'package:HnH/components/horizontal_listview.dart';
import 'package:HnH/components/products.dart';
import 'package:HnH/screens/cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Product Sans'
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  

  @override
  Widget build(BuildContext context) {
    Widget image_carousel = new Container(
      height: 200.0,
      child: Carousel(
          boxFit: BoxFit.cover,
          images: [
            AssetImage('images/c1.jpg'),
            AssetImage('images/m1.jpeg'),
            AssetImage('images/m2.jpg'),
            AssetImage('images/w1.jpeg'),
            AssetImage('images/w3.jpeg'),
            AssetImage('images/w4.jpeg'),
          ],
          autoplay: false,
          dotSize: 4.0,
          indicatorBgPadding: 8.0,
          dotBgColor: Colors.transparent,
          //animationCurve: Curves.fastOutSlowIn,
          //animationDuration: Duration(milliseconds: 1000),
        ),
    );
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.pink,
        title: Text('Half n Hour'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search
            ),
            color: Colors.white,
            onPressed: (){},
          ),
          IconButton(
            icon: Icon(
              Icons.shopping_cart
            ),
            color: Colors.white,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => Cart()
              ));
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            // header
            UserAccountsDrawerHeader(
              accountName: Text('Kunal Sahni'),
              accountEmail: Text('kunal.sahni1999@gmail.com'),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.pink
              ),
            ),
            // body 
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Home'),
                leading: Icon(Icons.home, color: Colors.pink,)
              ),
            ),
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('My Account'),
                leading: Icon(Icons.person, color: Colors.pink,)
              ),
            ),
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('My Orders'),
                leading: Icon(Icons.shopping_basket, color: Colors.pink,)
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Cart()
                ));
              },
              child: ListTile(
                title: Text('My Cart'),
                leading: Icon(Icons.shopping_cart, color: Colors.pink,)
              ),
            ),
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Favourites'),
                leading: Icon(Icons.favorite, color: Colors.pink,)
              ),
            ),

            Divider(),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Settings'),
                leading: Icon(Icons.settings, color: Colors.pink,)
              ),
            ),InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('About'),
                leading: Icon(Icons.help, color: Colors.pink,)
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          image_carousel,
          Padding(
            //padding widget
            padding: const EdgeInsets.all(4.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text('Categories'))
          ),
          
          // Horizontal List View begins here
          HorizontalList(),

          Padding(
            //padding widget
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text('Recent Products'))
          ),

          Flexible(
            child: Products(),
          )
        ],
      ),
    );
  }
}
