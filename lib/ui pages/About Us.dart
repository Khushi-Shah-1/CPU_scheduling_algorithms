import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(AboutUs());

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        /*appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),*/
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );*/
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF22456D),
        //title: Text('About Us', textAlign: TextAlign.center),
      ),
      body: Container(
        //margin: const EdgeInsets.all(13.0),
        decoration: BoxDecoration(
          color: Color(0XFF22456D),
          image: DecorationImage(
            image: AssetImage("images/About Us.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
