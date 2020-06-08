import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freeserve/DrawerPages/MyReservations.dart';
import 'package:freeserve/Classes/Restros.dart';
import 'package:freeserve/main.dart';
import 'Details/Details.dart';

class HomePage extends StatefulWidget {
  final String mail;
  const HomePage(this.mail);
  @override
  _HomePageState createState() => _HomePageState();
}

String searchmail;
List<Restros> searchList = [];
List<Restros> recentSearchList = [];

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }

  List<Restros> restros = [];

  @override
  void initState() {
    print(widget.mail);
    super.initState();

    DatabaseReference dailyitemsref =
        FirebaseDatabase.instance.reference().child('Restros');
    dailyitemsref.once().then((DataSnapshot snap) {
      // ignore: non_constant_identifier_names
      var KEYS = snap.value.keys;
      // ignore: non_constant_identifier_names
      var DATA = snap.value;
      restros.clear();
      for (var key in KEYS) {
        Restros d = new Restros(DATA[key]['Name'], DATA[key]['Address1'],
            DATA[key]['Address2'], DATA[key]['Categories'], 1);
        restros.add(d);
      }
      setState(() {
        print(restros.length);
      });
    });
  }

  double pHeight;
  @override
  Widget build(BuildContext context) {
    print(widget.mail);

    searchmail = widget.mail;

    final drawerHeader = UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Color(0xFF5A4E6D),
      ),
      arrowColor: Colors.yellow,
      accountName: Text(
        'Welcome to Freeserve!',
        style: TextStyle(
            fontFamily: 'Varela_Round', fontSize: 24, color: Colors.white),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Color(0xFF5A4E6D),
        child: Image.asset(
          'images/Logo.png',
        ),
      ),
      accountEmail: Text(
        "support@freeserve.com",
        style: TextStyle(fontFamily: 'Varela_Round', color: Colors.white),
      ),
    );
    //Nav Drawer items
    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
        Divider(
          color: Colors.white,
          thickness: 0.5,
        ),
        ListTile(
          title: Text(
            'Create New Reservation',
            style: TextStyle(
              color: Color(0xFF000000),
              fontFamily: 'sf_pro',
              fontSize: 20,
            ),
          ),
          onTap: () => Navigator.pop(context, true),
        ),
        ListTile(
          title: Text(
            'Your Reservations',
            style: TextStyle(
              color: Color(0xFF000000),
              fontFamily: 'sf_pro',
              fontSize: 20,
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyReservations(widget.mail)));
          },
        ),
        SizedBox(
          height: 380,
        ),
        Divider(
          thickness: 0.5,
          color: Colors.white,
        ),
        ListTile(
            title: Center(
              child: Text(
                'Sign Out',
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontFamily: 'sf_pro',
                  fontSize: 20,
                ),
              ),
            ),
            onTap: () {
              widget.mail != null
                  ? showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Sign Out"),
                          content: Text("Are you sure you want to sign out?"),
                          actions: [
                            FlatButton(
                              child: Text("No"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text("Sign Out"),
                              onPressed: () {
                                _signOut();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpPage()));
                              },
                            )
                          ],
                        );
                      })
                  : showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Sign Out"),
                          content: Text("You need to be logged in first."),
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
            }),
      ],
    );
    pHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFF393244),
      appBar: AppBar(
        iconTheme: new IconThemeData(
          color: Color(0xFF94632F),
        ),
        elevation: 0,
        backgroundColor: Color(0xFF393244),
        title: Image.asset(
          'images/Logo.png',
          scale: 1.9,
        ),
        actions: [
          Text(
            'Create New\nReservation',
            style: TextStyle(
              fontFamily: 'Varela_Round',
              fontSize: 24,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(
                    1.0,
                    1.0,
                  ),
                  blurRadius: 3.0,
                  color: Colors.black45,
                ),
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 3.0,
                  color: Colors.black45,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 30,
          ),
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                populateSearchList2();
                showSearch(context: context, delegate: DataSearch());
              }),
          SizedBox(
            width: 10,
          )
        ],
      ),
      drawer: Drawer(
        key: _drawerKey,
        child: drawerItems,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 30, top: 24),
              child: Text(
                'All Restros',
                style: TextStyle(
                  fontFamily: 'Varela_Round',
                  color: Colors.white,
                  fontSize: 30,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      color: Colors.black45,
                    ),
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                  height: pHeight - 234,
                  child: restros.length == 0
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: restros.length,
                          itemBuilder: (_, index) {
                            int i = index;
                            return Column(
                              children: [
                                restroCard(
                                    restros[index].name,
                                    restros[index].add1,
                                    restros[index].add2,
                                    restros[index].categories,
                                    i + 1),
                                SizedBox(
                                  height: 24,
                                ),
                              ],
                            );
                          },
                        )),
            ),
          ],
        ),
      ),
    );
  }

  Widget restroCard(String name, String addressLine1, String addressLine2,
      String categories, int imageNumber) {
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
                Image.asset(
                  'images/image$imageNumber.png',
                  scale: 5,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  categories,
                  style: TextStyle(
                    fontFamily: 'Varela_Round',
                    color: Color(0xFFAE9F1A),
                    fontSize: 19,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Details(widget.mail, name,
                                addressLine1, addressLine2, categories)));
                  },
                  child: Text(
                    'Reserve-->',
                    style: TextStyle(
                      fontFamily: 'Varela_Round',
                      color: Color(0xFF11287A),
                      fontSize: 19,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

int flag = 0;

void populateSearchList2() {
  DatabaseReference dailyitemsref =
      FirebaseDatabase.instance.reference().child('Restros');
  dailyitemsref.once().then((DataSnapshot snap) {
    // ignore: non_constant_identifier_names
    var KEYS = snap.value.keys;
    // ignore: non_constant_identifier_names
    var DATA = snap.value;
    searchList.clear();
    for (var key in KEYS) {
      Restros d = new Restros(DATA[key]['Name'], DATA[key]['Address1'],
          DATA[key]['Address2'], DATA[key]['Categories'], 1);
      searchList.add(d);
    }
  });
  recentSearchList.clear();
  for (int i = 0; i < 5; i++) {
    recentSearchList.add(searchList[i]);
  }
}

class DataSearch extends SearchDelegate<String> {
  String itemSelectedName;
  @override
  List<Widget> buildActions(BuildContext context) {
// Actions for app bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on the left of the appbar
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  double pHeight;
  @override
  Widget buildResults(BuildContext context) {
    pHeight = MediaQuery.of(context).size.height;

    //show some result based on selection
    populateSearchList2();
    for (int i = 0; i < searchList.length; i++) {
      if (searchList[i].name == itemSelectedName) {
        flag = 1;

        return Details(searchmail, searchList[i].name, searchList[i].add1,
            searchList[i].add2, searchList[i].categories);
      }
    }
    if (flag == 0) {
      return Text('No Results');
    }
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something
    List<Restros> showList = [];
//    final showList = query.isEmpty ? recentSearchList : searchList;
    if (query.isEmpty) {
      showList = recentSearchList;
    } else {
      List<Restros> temp = [];
      for (int i = 0; i < searchList.length; i++) {
        if (searchList[i].name.startsWith(query)) {
          temp.add(searchList[i]);
        }
      }
      showList = temp;
    }

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          itemSelectedName = showList[index].name;

          showResults(context);
        },
//        title: Text(showList[index].name),
        title: RichText(
            text: TextSpan(
                text: showList[index].name.substring(0, query.length),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
              TextSpan(
                  text: showList[index].name.substring(query.length),
                  style: TextStyle(color: Colors.grey))
            ])),
      ),
      itemCount: showList.length,
    );
  }
}
