import 'dart:async';
import 'package:animation_exp/chat_box.dart';
import 'package:animation_exp/SwipeAnimation/data.dart';
import 'package:animation_exp/SwipeAnimation/dummyCard.dart';
import 'package:animation_exp/SwipeAnimation/activeCard.dart';
import 'package:animation_exp/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class CardDemo extends StatefulWidget {
  @override
  CardDemoState createState() => new CardDemoState();
}

class CardDemoState extends State<CardDemo> with TickerProviderStateMixin {
  AnimationController _buttonController;
  Animation<double> rotate;
  Animation<double> right;
  Animation<double> bottom;
  Animation<double> width;
  int flag = 0;

  List data = imageData;
  List selectedData = [];
  void initState() {
    super.initState();

    _buttonController = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);

    rotate = new Tween<double>(
      begin: -0.0,
      end: -40.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    rotate.addListener(() {
      setState(() {
        if (rotate.isCompleted) {
          var i = data.removeLast();
          data.insert(0, i);

          _buttonController.reset();
        }
      });
    });

    right = new Tween<double>(
      begin: 0.0,
      end: 400.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    bottom = new Tween<double>(
      begin: 15.0,
      end: 100.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    width = new Tween<double>(
      begin: 20.0,
      end: 25.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  Future<Null> _swipeAnimation() async {
    try {
      await _buttonController.forward();
    } on TickerCanceled {}
  }

  dismissImg(DecorationImage img) {
    setState(() {
      data.remove(img);
    });
  }

  addImg(DecorationImage img) {
    setState(() {
      data.remove(img);
      selectedData.add(img);
    });
  }

  swipeRight() {
    if (flag == 0)
      setState(() {
        flag = 1;
      });
    _swipeAnimation();
  }

  swipeLeft() {
    if (flag == 1)
      setState(() {
        flag = 0;
      });
    _swipeAnimation();
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;

    double initialBottom = 15.0;
    var dataLength = data.length;
    double backCardPosition = initialBottom + (dataLength - 1) * 10 + 10;
    double backCardWidth = -7.0 * (data.length);
    var pagename = ["Discover", "Chat", "Reconsider", "Profile"];
    var pages = [
      new Container(
        color: new Color.fromRGBO(50, 50, 50, 1.0),
        alignment: Alignment.center,
        child: dataLength > 0
            ? new Stack(
                alignment: AlignmentDirectional.center,
                children: data.map((item) {
                  if (data.indexOf(item) == dataLength - 1) {
                    return cardDemo(
                        item,
                        bottom.value,
                        right.value,
                        0.0,
                        backCardWidth + 10,
                        rotate.value,
                        rotate.value < -10 ? 0.1 : 0.0,
                        context,
                        dismissImg,
                        flag,
                        addImg,
                        swipeRight,
                        swipeLeft);
                  } else {
                    backCardPosition = backCardPosition - 10;
                    backCardWidth = backCardWidth + 10;

                    return cardDemoDummy(item, backCardPosition, 0.0, 0.0,
                        backCardWidth, 0.0, 0.0, context);
                  }
                }).toList())
            : new Text("No Products Left",
                style: new TextStyle(color: Colors.white, fontSize: 35.0)),
      ),
      new Chat(),
      new Container(),
      new Profile(),
    ];

    return (new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(50, 50, 50, 1.0),
        centerTitle: true,
        // leading: new Container(
        // margin: const EdgeInsets.all(15.0),
        // child: new Icon(
        //   Icons.equalizer,
        //   color: Colors.cyan,
        //   size: 30.0,
        // ),
        // ),
        // actions: <Widget>[
        //   new GestureDetector(
        //     onTap: () {
        //       Navigator.push(
        //           context,
        //           new MaterialPageRoute(
        //               builder: (context) => new PageMain()));
        //     },
        //     child: new Container(
        //         margin: const EdgeInsets.all(15.0),
        //         child: new Icon(
        //           Icons.portrait,
        //           color: Colors.white,
        //           size: 30.0,
        //         )),
        //   ),
        // ],
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              pagename[_selectedIndex].toUpperCase(),
              style: new TextStyle(
                  fontSize: 15.0,
                  // letterSpacing: 3.5,
                  fontWeight: FontWeight.bold),
            ),
            // new Container(
            //   width: 15.0,
            //   height: 15.0,
            //   margin: new EdgeInsets.only(bottom: 20.0),
            //   alignment: Alignment.center,
            //   child: new Text(
            //     dataLength.toString(),
            //     style: new TextStyle(fontSize: 10.0),
            //   ),
            //   decoration: new BoxDecoration(
            //       color: Colors.red, shape: BoxShape.circle),
            // )
          ],
        ),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        // type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text('Discover'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text('Chat'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            title: Text('Reconsider'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.portrait),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    ));
  }
}
