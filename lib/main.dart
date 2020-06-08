import 'package:flutter/material.dart';
import 'package:freeserve/DrawerPages/HomePage.dart';
import 'package:freeserve/LoginPages/SignUser.dart';

import 'LoginPages/Login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
        canvasColor: Color(0xFF5A4E6D),
      ),
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF393244),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 5),
              child: Text(
                'Welcome to\nFreeserve',
                style: TextStyle(
                    fontFamily: 'Varela_Round',
                    fontSize: 40,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Reserve for free.',
                style: TextStyle(
                    fontFamily: 'Varela_Round',
                    fontSize: 25,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Image.asset(
              "images/hotel.png",
              height: 250,
              width: 250,
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Best Places,\nBest Prices,\nNo middle charges.',
              style: TextStyle(
                fontFamily: 'Varela_Round',
                color: Colors.white,
                fontSize: 23,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 80),
                    child: Card(
                      elevation: 7,
                      color: Color(0xFF94632F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: 'Varela_Round',
                            color: Colors.white,
                            fontSize: 21,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUser()));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 80),
                    child: Card(
                      elevation: 7,
                      color: Color(0xFF99634F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Varela_Round',
                            color: Colors.white,
                            fontSize: 21,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(null)));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 80),
                    child: Card(
                      elevation: 7,
                      color: Color(0xFF94632F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 48, vertical: 10),
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontFamily: 'Varela_Round',
                            color: Colors.white,
                            fontSize: 21,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
