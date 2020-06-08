import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freeserve/Classes/reservation.dart';

class MyReservations extends StatefulWidget {
  final String mail;
  const MyReservations(this.mail);
  @override
  _MyReservationsState createState() => _MyReservationsState();
}

class _MyReservationsState extends State<MyReservations> {
  void book(String seat2, String seat4, visitTime) {
    DatabaseReference dbRef = FirebaseDatabase.instance
        .reference()
        .child("Bookings")
        .child('${widget.mail.substring(0, 2)}${widget.mail.substring(1, 2)}');

    dbRef.update({
      "Tables2": seat2,
      "Tables4": seat4,
      "DateTimeBook": DateTime.now().toString(),
      "VisitTime": visitTime,
    });
  }

  String seats1, seats2;
  bool saveAttempt = false;
  bool hasVisited = false;
  List<Reservation> reservations = [];
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    print(widget.mail);
    super.initState();

    DatabaseReference dailyitemsref = FirebaseDatabase.instance
        .reference()
        .child('Bookings')
        .child('${widget.mail.substring(0, 2)}${widget.mail.substring(1, 2)}');
    dailyitemsref.once().then((DataSnapshot snap) {
      // ignore: non_constant_identifier_names
      var KEYS = snap.value.keys;
      // ignore: non_constant_identifier_names
      var DATA = snap.value;
      reservations.clear();
      for (var key in KEYS) {
        Reservation d = new Reservation(
          DATA[key]['Restro'],
          DATA[key]['Address1'],
          DATA[key]['Address2'],
          DATA[key]['DateTimeBook'],
          DATA[key]['VisitTime'],
          DATA[key]['Tables2'],
          DATA[key]['Tables4'],
        );
        reservations.add(d);
      }
      setState(() {
        print(reservations.length);
      });
    });
  }

  double pHeight;
  @override
  Widget build(BuildContext context) {
    String visitTime = "";
    pHeight = MediaQuery.of(context).size.height;
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
            padding: EdgeInsets.only(right: 50, top: 5),
            child: Text(
              'Your\nReservations',
              style: TextStyle(
                fontFamily: 'Varela_Round',
                fontSize: 22,
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
        padding: const EdgeInsets.all(20),
        child: Container(
            height: pHeight - 200,
            child: reservations.length == 0
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: reservations.length,
                    itemBuilder: (_, index) {
                      return Column(
                        children: [
                          restroCard(
                            reservations[index].name,
                            reservations[index].add1,
                            reservations[index].add2,
                            reservations[index].bookingTime,
                            reservations[index].visitingTime,
                            reservations[index].seat2,
                            reservations[index].seat4,
                            visitTime,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                        ],
                      );
                    },
                  )),
      ),
    );
  }

  Widget restroCard(
    String name,
    String addressLine1,
    String addressLine2,
    String booking,
    String visiting,
    String tables2,
    String tables4,
    String visitTime,
  ) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: Color(0xFF604D5F),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Varela_Round',
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      addressLine1,
                      style: TextStyle(
                        fontFamily: 'Varela_Round',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      addressLine2,
                      style: TextStyle(
                        fontFamily: 'Varela_Round',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking-\n${booking.substring(0, 16)}',
                      style: TextStyle(
                        fontFamily: 'Varela_Round',
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Visit-\n$visiting',
                      style: TextStyle(
                        fontFamily: 'Varela_Round',
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Tables for two-$tables2',
                      style: TextStyle(
                        fontFamily: 'Varela_Round',
                        color: Color(0xFFAE9F1A),
                        fontSize: 19,
                      ),
                    ),
                    Text(
                      'Tables for four-$tables4',
                      style: TextStyle(
                        fontFamily: 'Varela_Round',
                        color: Color(0xFFAE9F1A),
                        fontSize: 19,
                      ),
                    ),
                  ],
                ),
                hasVisited
                    ? Text('You Visited\nthis place.')
                    : Column(
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          'Have you completed your visit?'),
                                      actions: [
                                        FlatButton(
                                          child: Text("Yes"),
                                          onPressed: () {
                                            setState(() {
                                              hasVisited = true;
                                              Navigator.of(context).pop();
                                            });
                                          },
                                        ),
                                        FlatButton(
                                          child: Text("No"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Text(
                              'Visited-->',
                              style: TextStyle(
                                fontFamily: 'Varela_Round',
                                color: Color(0xFF11287A),
                                fontSize: 19,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete'),
                                      content: Text(
                                          'Are you sure you want to delete this booking'),
                                      actions: [
                                        FlatButton(
                                          child: Text("Yes"),
                                          onPressed: () {
                                            DatabaseReference dbRef =
                                                FirebaseDatabase.instance
                                                    .reference()
                                                    .child("Bookings")
                                                    .child(
                                                        '${widget.mail.substring(0, 2)}${widget.mail.substring(1, 2)}');
                                            dbRef
                                                .once()
                                                .then((DataSnapshot snap) {
                                              // ignore: non_constant_identifier_names
                                              var KEYS = snap.value.keys;
                                              // ignore: non_constant_identifier_names
                                              var DATA = snap.value;
                                              for (var key in KEYS) {
                                                if (DATA[key]["VisitTime"] ==
                                                    visiting) {
                                                  dbRef.child(key).remove();
                                                }
                                              }
                                              setState(() {
                                                print(KEYS);
                                              });
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FlatButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Text(
                              'Delete-->',
                              style: TextStyle(
                                fontFamily: 'Varela_Round',
                                color: Color(0xFF11287A),
                                fontSize: 19,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Update Details'),
                                      content: Form(
                                        key: formKey,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                                decoration: InputDecoration(
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0XFFFFE600)
                                                          .withOpacity(0.35),
                                                    ),
                                                  ),
                                                  hintText: 'Tables for two',
                                                  helperText:
                                                      'Enter 0 if you don\'t need',
                                                  hintStyle: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                  ),
                                                ),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 24.0),
                                                onChanged: (textValue) {
                                                  setState(() {
                                                    seats1 = textValue;
                                                  });
                                                },
                                                autovalidate: saveAttempt,
                                                validator: (seatsv) {
                                                  if (seatsv.isEmpty) {
                                                    return 'This field cannot be blank';
                                                  } else if (int.parse(seatsv) >
                                                      4) {
                                                    return 'Seat limits exceed';
                                                  }
                                                  return null;
                                                }),
                                            TextFormField(
                                                decoration: InputDecoration(
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0X5FFFFE600)
                                                          .withOpacity(0.35),
                                                    ),
                                                  ),
                                                  helperText:
                                                      'Enter 0 if you don\'t need',
                                                  hintText: 'Tables for four',
                                                  hintStyle: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                  ),
                                                ),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 24.0),
                                                onChanged: (textValue) {
                                                  setState(() {
                                                    seats2 = textValue;
                                                  });
                                                },
                                                autovalidate: saveAttempt,
                                                validator: (seatsv) {
                                                  if (seatsv.isEmpty) {
                                                    return 'This field cannot be blank';
                                                  } else if (int.parse(seatsv) >
                                                      2) {
                                                    return 'Seat limits exceed';
                                                  }
                                                  return null;
                                                }),
                                            Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Container(
                                                                height: 200,
                                                                child:
                                                                    CupertinoDatePicker(
                                                                  mode: CupertinoDatePickerMode
                                                                      .dateAndTime,
                                                                  initialDateTime:
                                                                      DateTime
                                                                          .now(),
                                                                  onDateTimeChanged:
                                                                      (DateTime
                                                                          newDateTime) {
                                                                    print(
                                                                        newDateTime);
                                                                    visitTime =
                                                                        newDateTime
                                                                            .toString();
                                                                  },
                                                                  use24hFormat:
                                                                      false,
                                                                  minuteInterval:
                                                                      1,
                                                                ),
                                                              ),
                                                              actions: [
                                                                FlatButton(
                                                                  child: Text(
                                                                      "Select"),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    child: Card(
                                                      elevation: 1,
                                                      color: Color(0X5FFFFE600)
                                                          .withOpacity(0.3),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 30,
                                                                vertical: 10),
                                                        child: Text(
                                                          'Select Date',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Varela_Round',
                                                            color: Colors.white,
                                                            fontSize: 21,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        saveAttempt = true;
                                                      });
                                                      if (formKey.currentState
                                                          .validate()) {
                                                        formKey.currentState
                                                            .save();
                                                        print(seats1);
                                                        print(seats2);

                                                        book(seats1, seats2,
                                                            visitTime);
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Updated'),
                                                                actions: [
                                                                  FlatButton(
                                                                    child: Text(
                                                                        "Ok"),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                      }
                                                    },
                                                    child: Card(
                                                      elevation: 7,
                                                      color: Color(0xFF99634F),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30)),
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 30,
                                                                vertical: 10),
                                                        child: Text(
                                                          'Update',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Varela_Round',
                                                            color: Colors.white,
                                                            fontSize: 21,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
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
                                      actions: [
                                        FlatButton(
                                          child: Text("Done"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FlatButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Text(
                              'Update-->',
                              style: TextStyle(
                                fontFamily: 'Varela_Round',
                                color: Color(0xFF11287A),
                                fontSize: 19,
                              ),
                            ),
                          ),
                        ],
                      )
              ],
            )
          ],
        ),
      ),
    );
  }
}
