import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freeserve/LoginPages/SignUser.dart';

import '../DrawerPages/HomePage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email, password;
  bool saveAttempt = false;
  final formKey = GlobalKey<FormState>();
  void _signIn(String email, String pw) {
    _auth
        .signInWithEmailAndPassword(email: email, password: pw)
        .then((authResult) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomePage(email);
      }));
    }).catchError(
      (err) {
        print(err);
        if (err.code == 'ERROR_USER_NOT_FOUND') {
          showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text(
                      'This email is not yet registered. Create an account.'),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              });
        }
        if (err.code == 'ERROR_WRONG_PASSWORD') {
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text(
                    'Password is incorrect. Please enter correct password.'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        }
        if (err.code == 'ERROR_NETWORK_REQUEST_FAILED') {
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text(
                    'Your internet connection is either not available or too slow.'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        }
      },
    );
  }

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
                'Welcome\nBack!',
                style: TextStyle(
                    fontFamily: 'Varela_Round',
                    fontSize: 40,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Image.asset(
              "images/login.png",
              height: 250,
              width: 250,
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 35,
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 54),
                    child: TextFormField(
                      onChanged: (textValue) {
                        setState(() {
                          email = textValue;
                        });
                      },
                      autovalidate: saveAttempt,
                      validator: (emailValue) {
                        if (emailValue.isEmpty) {
                          return 'This field cannot be blank';
                        }
                        RegExp regExp = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                        if (regExp.hasMatch(emailValue)) {
                          return null;
                        }

                        return 'Please enter a valid email';
                      },
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0XFFFFE600).withOpacity(0.35),
                          ),
                        ),
                        hintText: 'Enter Email',
                        hintStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 24.0),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 54),
                    child: TextFormField(
                      onChanged: (textValue) {
                        setState(() {
                          password = textValue;
                        });
                      },
                      autovalidate: saveAttempt,
                      validator: (pwValue) =>
                          pwValue.isEmpty ? 'This field cannot be blank' : null,
                      obscureText: true,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0XFFFFE600).withOpacity(0.35),
                          ),
                        ),
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 24.0),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            saveAttempt = true;
                          });
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                            print(email);
                            _signIn(email, password);
                          }
                        },
                        child: Card(
                          elevation: 7,
                          color: Color(0xFF94632F),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 45, vertical: 10),
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
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUser()));
                        },
                        child: Card(
                          elevation: 7,
                          color: Color(0xFF99634F),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
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
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
