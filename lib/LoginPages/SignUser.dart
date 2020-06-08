import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freeserve/DrawerPages/HomePage.dart';
import 'package:freeserve/LoginPages/Login.dart';
import 'package:freeserve/main.dart';

class SignUser extends StatefulWidget {
  @override
  _SignUserState createState() => _SignUserState();
}

class _SignUserState extends State<SignUser> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email, password;
  bool saveAttempt = false;
  final formKey = GlobalKey<FormState>();
  void _createUser(String email, String pw) {
    _auth
        .createUserWithEmailAndPassword(email: email, password: pw)
        .then((authResult) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomePage(email);
      }));
    }).catchError((err) {
      print(err);
      if (err.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('This email is already in use'),
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
    });
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
              "images/sign-up.png",
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
                            _createUser(email, password);
                          }
                        },
                        child: Card(
                          elevation: 7,
                          color: Color(0xFF99634F),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 45, vertical: 10),
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
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Card(
                          elevation: 7,
                          color: Color(0xFF94632F),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
