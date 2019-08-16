import 'dart:async';
import 'package:HnH/screens/cart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:provider/provider.dart';

import './screens/home_page.dart';
import './screens/check_out.dart';
import './screens/onboard.dart';
import 'package:flutter/rendering.dart';
import 'package:rect_getter/rect_getter.dart';

bool get isIOS => foundation.defaultTargetPlatform == TargetPlatform.iOS;

void main() => runApp(HalfnHour());

class FadeRouteBuilder<T> extends PageRouteBuilder<T>{
  final Widget page;

  FadeRouteBuilder({@required this.page})
      : super(
      transitionDuration: Duration(milliseconds: 1000),
      pageBuilder: (context, anim1, anim2) => page,
      transitionsBuilder: (context, a1, a2, child){
        return FadeTransition(opacity: a1 , child: child);
      }
  );
}

class HalfnHour extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Price>(
      builder: (context) => Price(),
      child: isIOS ?
          CupertinoApp(
            debugShowCheckedModeBanner: false,
            title: 'Half n Hour',
            routes: {
              '/home': (_) => MyHomePage()
            },
            theme: CupertinoThemeData(
              primaryColor: Colors.white70,
              barBackgroundColor: Colors.white70
            ),
            home: SplashScreen()
          )
          :MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Half n Hour',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: Colors.white,
              fontFamily: 'Product Sans',
            ),
            routes: {
              '/home': (_) => MyHomePage()
            },
            home: SplashScreen()
          ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  SharedPreferences sharedPreferences;
  bool loading = false,
      isLoggedIn, SignupEmail, isLoggedInEmail, isLoggedInPhone;
  GlobalKey rectGetterKey = RectGetter.createGlobalKey();
  final Duration animationDuration = Duration(milliseconds: 300);

  Rect rect;

  void initState(){
    super.initState();
    Timer(
      Duration(seconds: 5),
      (){
        isSignIn();
      }
    );
  }

  void isSignIn() async {
    setState(() {
      loading = true;
    });
    sharedPreferences = await SharedPreferences.getInstance();
    isLoggedIn = await googleSignIn.isSignedIn() ?? false;
    SignupEmail = sharedPreferences.getBool("isLoggedIn") ?? false;
    isLoggedInEmail = sharedPreferences.getBool("LoggedInwithMail") ?? false;
    isLoggedInPhone = sharedPreferences.getBool("loggedwithPhone") ?? false;

    if (isLoggedIn || isLoggedInEmail || SignupEmail || isLoggedInPhone) {
      _onTimeOut(MyHomePage());
    }
    else{
      _onTimeOut(OnBoarding());
    }

    setState(() {
      loading = false;
    });
  }

  Widget _ripple(){
    if (rect == null){
      return Container();
    }
    return AnimatedPositioned(
      duration: animationDuration,
      left: rect.left,
      right: MediaQuery.of(context).size.width - rect.right,
      top: rect.top,
      bottom: MediaQuery.of(context).size.height - rect.bottom,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
            color: Colors.white,
        ),
      ),
    );
  }

  void _onTimeOut(Widget page) async{
    setState(() => rect = RectGetter.getRectFromKey(rectGetterKey));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() =>
      rect = rect.inflate(1.3 * MediaQuery.of(context).size.longestSide));
      Future.delayed(animationDuration, () {_goToNextPage(page);});
    });
  }

  void _goToNextPage(Widget page){
    Navigator.pushReplacement(context, FadeRouteBuilder(page: page))
        .then((_) => setState(() => rect = null));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Scaffold(
           body: Stack(
             children: <Widget>[
               Container(
                 color: Colors.deepOrange,
               ),

               Padding(
                 padding: const EdgeInsets.only(top: 100.0),
                 child: Center(
                   child: Column(
                     children: <Widget>[
                       RectGetter(
                         key: rectGetterKey,
                         child: Image.asset('images/main_icon.png',
                           width: 300.0,
                           height: 300.0,
                         ),
                       ),

                       Text('Half n Hour',
                         style: TextStyle(
                           color: Colors.white,
                           fontSize: 30.0,
                           fontWeight: FontWeight.bold
                         ),
                       ),
                       
                       Padding(
                         padding: EdgeInsets.only(top: 80.0),
                         child: GridTile(
                           child: Container(
                             width: double.infinity,
                             height: 50.0,
                             color: Colors.white,
                             child: Padding(
                               padding: const EdgeInsets.only(top: 10.0),
                               child: Text('A DOORSTEP SERVICE PROVIDER',
                                 textAlign: TextAlign.center,
                                 style: TextStyle(
                                     color: Colors.deepOrange,
                                     fontWeight: FontWeight.bold,
                                     fontSize: 20.0
                                 ),
                               ),
                             ),
                           ),
                         )
                       ),

                       Padding(
                         padding: EdgeInsets.only(top: 20.0),
                         child: Text('Anytime Anywhere Anything',
                           style: TextStyle(
                               color: Colors.white,
                               fontWeight: FontWeight.bold,
                               fontSize: 20.0
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
             ],
           )
        ),
        _ripple()
      ],
    );
  }
}
