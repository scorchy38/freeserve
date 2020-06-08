import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freeserve/main.dart';
import 'package:url_launcher/url_launcher.dart';

class Details extends StatefulWidget {
  final String mail;
  final String name;
  final String add1;
  final String add2;
  final String categories;
  const Details(this.mail, this.name, this.add1, this.add2, this.categories);
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String seats1, seats2;
  bool saveAttempt = false;
  @override
  void initState() {
    print(widget.mail);
    super.initState();
  }

  void book(String seat2, String seat4, String name, String add1, String add2,
      visitTime) {
    DatabaseReference dbRef = FirebaseDatabase.instance
        .reference()
        .child("Bookings")
        .child('${widget.mail.substring(0, 2)}${widget.mail.substring(1, 2)}')
        .push();

    dbRef.set({
      "Tables2": seat2,
      "Tables4": seat4,
      "DateTimeBook": DateTime.now().toString(),
      "VisitTime": visitTime,
      "Address1": add1,
      "Address2": add2,
      "Restro": name,
    });
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String visitTime;
    print('mail ${widget.mail}');
    return Scaffold(
      backgroundColor: Color(0xFF393244),
      appBar: AppBar(
        iconTheme: new IconThemeData(
          color: Color(0xFF94632F),
        ),
        elevation: 0,
        backgroundColor: Color(0xFF393244),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Image.asset(
          'images/Logo.png',
          scale: 1.9,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 80, top: 5),
            child: Text(
              'Details',
              style: TextStyle(
                fontFamily: 'Varela_Round',
                fontSize: 35,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(3.0, 3.0),
                    blurRadius: 3.0,
                    color: Colors.black45,
                  ),
                  Shadow(
                    offset: Offset(3.0, 3.0),
                    blurRadius: 3.0,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 30,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Color(0xFF604D5F),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontFamily: 'Varela_Round',
                      color: Colors.white,
                      fontSize: 35,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Address-  ',
                      style: TextStyle(
                          fontFamily: 'Varela_Round',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.add1}',
                      style: TextStyle(
                          fontFamily: 'Varela_Round',
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.add2,
                      style: TextStyle(
                        fontFamily: 'Varela_Round',
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Available tables for two- ',
                      style: TextStyle(
                          fontFamily: 'Varela_Round',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '4',
                      style: TextStyle(
                        fontFamily: 'Varela_Round',
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Available tables for four- ',
                      style: TextStyle(
                          fontFamily: 'Varela_Round',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '2',
                      style: TextStyle(
                        fontFamily: 'Varela_Round',
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 54, vertical: 10),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0XFFFFE600).withOpacity(0.35),
                              ),
                            ),
                            hintText: 'Tables for two',
                            helperText: 'Enter 0 if you don\'t need',
                            hintStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ),
                          style: TextStyle(color: Colors.white, fontSize: 24.0),
                          onChanged: (textValue) {
                            setState(() {
                              seats1 = textValue;
                            });
                          },
                          autovalidate: saveAttempt,
                          validator: (seatsv) {
                            if (seatsv.isEmpty) {
                              return 'This field cannot be blank';
                            } else if (int.parse(seatsv) > 4) {
                              return 'Seat limits exceed';
                            }
                            return null;
                          }),
                      TextFormField(
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0X5FFFFE600).withOpacity(0.35),
                              ),
                            ),
                            helperText: 'Enter 0 if you don\'t need',
                            hintText: 'Tables for four',
                            hintStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ),
                          style: TextStyle(color: Colors.white, fontSize: 24.0),
                          onChanged: (textValue) {
                            setState(() {
                              seats2 = textValue;
                            });
                          },
                          autovalidate: saveAttempt,
                          validator: (seatsv) {
                            if (seatsv.isEmpty) {
                              return 'This field cannot be blank';
                            } else if (int.parse(seatsv) > 2) {
                              return 'Seat limits exceed';
                            }
                            return null;
                          }),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Container(
                                          height: 200,
                                          child: CupertinoDatePicker(
                                            mode: CupertinoDatePickerMode
                                                .dateAndTime,
                                            initialDateTime: DateTime.now(),
                                            onDateTimeChanged:
                                                (DateTime newDateTime) {
                                              print(newDateTime);
                                              visitTime =
                                                  newDateTime.toString();
                                            },
                                            use24hFormat: false,
                                            minuteInterval: 1,
                                          ),
                                        ),
                                        actions: [
                                          FlatButton(
                                            child: Text("Select"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Card(
                                elevation: 1,
                                color: Color(0X5FFFFE600).withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  child: Text(
                                    'Select Date',
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
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  saveAttempt = true;
                                });
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();
                                  print(seats1);
                                  print(seats2);
                                  if (widget.mail != null) {
                                    book(seats1, seats2, widget.name,
                                        widget.add1, widget.add2, visitTime);
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Booking Done'),
                                            actions: [
                                              FlatButton(
                                                child: Text("Ok"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                Text('You are not logged in'),
                                            actions: [
                                              FlatButton(
                                                child: Text("Cancel"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                child: Text("Login"),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SignUpPage()));
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                }
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
                                    'Book',
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
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                _launchURL();
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
                                    'Visit Restro\'s\nWebsite',
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    const url = 'https://google.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
