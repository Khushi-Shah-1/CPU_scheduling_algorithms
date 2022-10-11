import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:os_project/PageReplacement.dart';
import 'package:os_project/animation1.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:os_project/swiper_pagination.dart';
import 'package:os_project/ui%20pages/About%20Us.dart';
import 'Algorithm page.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() {
  runApp(MaterialApp(
    title: 'First',
    // Start the app with the "/" named route. In this case, the app starts
    // on the FirstScreen widget.
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/': (context) => FirstScreen(),
      '/second': (context) => IntroTwoPage(),
      '/third': (context) => WaveDemoApp(),
      '/fourth': (context) => PageReplacement(),
      //'/fifth':(context)=> AboutUs(),
    },
  ));
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/homepage.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                /*Container(
                  width: 320,
                  alignment: Alignment.center,
                  child: Text(
                    " ",
                    style: TextStyle(fontSize: 100.0, color: Colors.black),
                  ),
                ),
                Container(
                  child: RotateAnimatedTextKit(
                    onTap: () {
                      print("Tap Event");
                    },
                    text: [
                      "",
                    ],
                    textStyle: TextStyle(fontSize: 28.0, color: Colors.black),
                    textAlign: TextAlign.start,
                    transitionHeight: 86,
                  ),
                  height: MediaQuery.of(context).size.height * 0.4,
                ),*/

                Container(
                  height: MediaQuery.of(context).size.height * 0.565,
                  padding: EdgeInsets.only(bottom: 0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: RaisedButton(
                      color: Color(0xFF22456D),
                      child: Text(
                        'LAUNCH',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        // Navigate to the second screen using a named route.
                        Navigator.pushNamed(context, '/second');
                      },
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  // width: 320,
                  //alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AboutUs()),
                        ); // Add your onPressed code here!
                      },
                      label: Text(
                        'ABOUT US',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      icon: Icon(Icons.group_outlined, color: Colors.black),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ))));
  }
}

class IntroTwoPage extends StatefulWidget {
  static final String path = "lib/intro2.dart";
  @override
  _IntroTwoPageState createState() => _IntroTwoPageState();
}

class _IntroTwoPageState extends State<IntroTwoPage> {
  final SwiperController _swiperController = SwiperController();
  final int _pageCount = 4;
  int _currentIndex = 0;
  final List<String> titles = [
    "CPU Scheduling ",
    "Page Scheduling",
    "Process Scheduling",
    "Concurrency and deadlock"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF224568),
      body: Column(
        children: <Widget>[
          Expanded(
              child: Swiper(
            index: _currentIndex,
            controller: _swiperController,
            itemCount: _pageCount,
            onIndexChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            loop: false,
            itemBuilder: (context, index) {
              return _buildPage(icon: images1[index], title: titles[index]);
            },
            pagination: SwiperPagination(
                builder: CustomPaginationBuilder(
                    activeColor: Colors.white,
                    activeSize: Size(15.0, 15.0),
                    size: Size(14.0, 14.0),
                    color: Colors.grey.shade400)),
          )),
          SizedBox(height: 0.0),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin:
          const EdgeInsets.only(top: 0, bottom: 30.0, left: 160 , right: 150),
      //height: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            color: Colors.white,
            icon: Icon(
              _currentIndex < _pageCount - 1
                  ? FontAwesomeIcons.arrowCircleRight
                  : FontAwesomeIcons.checkCircle,
              size: 40,
            ),
            onPressed: () async {
              if (_currentIndex < _pageCount - 1)
                _swiperController.next();
              else {
                Navigator.of(context).pushReplacementNamed('challenge_home');
              }
            },
          ),
          /*ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            label: Text('Go back'),
            icon: Icon(Icons.keyboard_backspace_sharp),
            style: ElevatedButton.styleFrom(
              primary: Colors.deepOrange,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _buildPage({String title, String icon}) {
    if (_currentIndex == 0) {
      final TextStyle titleStyle =
          TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0);
      return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/third');
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 40.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                image: DecorationImage(
                  image: AssetImage(icon),
                  fit: BoxFit.cover,
                  /*colorFilter:
                        ColorFilter.mode(Colors.black38, BlendMode.multiply)*/
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                /*Text(
                  title,
                  textAlign: TextAlign.center,
                  style: titleStyle.copyWith(color: Colors.black),
                ),*/
                SizedBox(height: 30),
              ],
            ),
          ));
    } else if (_currentIndex == 1) {
      final TextStyle titleStyle =
          TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0);
      return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/fourth');
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 40.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                image: DecorationImage(
                  image: AssetImage(icon),
                  fit: BoxFit.cover,
                  /*colorFilter:
                        ColorFilter.mode(Colors.black38, BlendMode.multiply)*/
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                /*Text(
                  title,
                  textAlign: TextAlign.center,
                  style: titleStyle.copyWith(color: Colors.white),
                ),*/
                SizedBox(height: 30),
              ],
            ),
          ));
    } else {
      final TextStyle titleStyle =
          TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0);
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 40.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            image: DecorationImage(
              image: AssetImage(icon),
              fit: BoxFit.cover,
              /*colorFilter:
                    ColorFilter.mode(Colors.black38, BlendMode.multiply)*/
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            /*Text(
              title,
              textAlign: TextAlign.center,
              style: titleStyle.copyWith(color: Colors.white),
            ),*/
            SizedBox(height: 30),
          ],
        ),
      );
    }
  }
}
