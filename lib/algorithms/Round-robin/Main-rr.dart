import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:os_project/Algorithm%20page.dart';
// import 'round-robin-algo.dart';
import 'round-robin.dart';
import 'table.dart';
import 'gantt.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:async';
import 'package:fab_circular_menu/fab_circular_menu.dart';

void main() {
  runApp(Myrrapp());
}

class Myrrapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Algorithm(),
    );
  }
}

class Algorithm extends StatefulWidget {
  @override
  _AlgorithmState createState() => _AlgorithmState();
}

class _AlgorithmState extends State<Algorithm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(milliseconds: 800), () {
      completer.complete();
    });
    setState(() {
      prs.removeRange(0, prs.length);
    });
    return completer.future.then<void>((_) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
              label: 'RETRY',
              onPressed: () {
                _refreshIndicatorKey.currentState.show();
              })));
    });
  }

  List<Process> prs = [];
  int timeq;
  FocusNode nodebt = FocusNode();

  add(TextEditingController control1, TextEditingController control2, int tq) {
    setState(() {
      prs.sort((a, b) => a.pid.compareTo(b.pid));
      prs.add(Process(int.parse(control1.text), int.parse(control2.text)));
      control1.clear();
      control2.clear();
      assignPid(prs);
      printprocess(prs);
      print("tq is " + tq.toString());
      prs = rralgo(prs, tq);
      //prs.sort((a, b) => a.pid.compareTo(b.pid));
    });
  }

  TextEditingController control1 = new TextEditingController();
  TextEditingController control2 = new TextEditingController();
  TextEditingController controltq = new TextEditingController();

  createtqDialog(BuildContext context, List<Process> prs, int tq) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ), //this right here
            child: Container(
              height: 180.0,
              width: 100.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Time Quantum:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            TextField(
                              autofocus: true,
                              cursorWidth: 3,
                              cursorColor: Color(0XFFF36735),
                              textAlign: TextAlign.center,
                              showCursor: true,
                              controller: controltq,
                              keyboardType: TextInputType.number,
                              onSubmitted: (controltq) {
                                setState(
                                  () {
                                    tq = int.parse(controltq);
                                    print("TQ is " + tq.toString());
                                    if (prs.isNotEmpty) {
                                      rralgo(prs, tq);
                                      printprocess(prs);
                                    }
                                  },
                                );
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 38),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          RaisedButton(
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text("Submit"),
                              onPressed: () {
                                //add(control1, control2);
                                setState(
                                  () {
                                    tq = int.parse(controltq.text);
                                    print("TQ is " + tq.toString());
                                    if (prs.isNotEmpty) {
                                      rralgo(prs, tq);
                                    }
                                    print("TQ is " + tq.toString());
                                  },
                                );
                                Navigator.of(context).pop();
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  createaddDialog(BuildContext context, List<Process> prs, int tq) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ), //this right here
            child: Container(
              height: 280.0,
              width: 200.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'AT:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                TextField(
                                  autofocus: true,
                                  cursorWidth: 3,
                                  cursorColor: Color(0XFFF36735),
                                  textAlign: TextAlign.center,
                                  showCursor: true,
                                  controller: control1,
                                  keyboardType: TextInputType.number,
                                  onSubmitted: (control1) {
                                    FocusScope.of(context).requestFocus(nodebt);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'BT:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                TextField(
                                  textAlign: TextAlign.center,
                                  focusNode: nodebt,
                                  cursorWidth: 3,
                                  cursorColor: Color(0XFFF36735),
                                  showCursor: true,
                                  controller: control2,
                                  keyboardType: TextInputType.number,
                                  onSubmitted: (text) {
                                    timeq = int.parse(controltq.text);
                                    add(control1, control2, timeq);
                                    Navigator.of(context)
                                        .pop(); // Redraw the Stateful Widget
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 38),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text("Cancel"),
                              onPressed: () {
                                control1.clear();
                                control2.clear();
                                Navigator.of(context).pop();
                              }),
                          RaisedButton(
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text("Submit"),
                              onPressed: () {
                                timeq = int.parse(controltq.text);
                                add(control1, control2, timeq);
                                Navigator.of(context).pop();
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Round Robin'),
        backgroundColor: Color(0xff22456d),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new WaveDemoApp(),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: LiquidPullToRefresh(
              animSpeedFactor: 2.5,
              onRefresh: _handleRefresh,
              child: ListView.builder(
                  itemCount: prs.length,
                  itemBuilder: (BuildContext context, int index) =>
                      buildProcesscard(context, index)),
            ),
          )
        ],
      ),
      floatingActionButton: FabCircularMenu(
        ringDiameter: 450,
        ringWidth: 120,
        ringColor: Color(0xFFc3ebef),
        fabColor: Color(0xffc3ebef),
        //fabCloseColor: Colors.transparent,
        children: <Widget>[

          IconButton(
            iconSize: 30,
            icon: Icon(Icons.table_chart_rounded),
            onPressed: () {
              prs.sort((a, b) => a.pid.compareTo(b.pid));
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TheTable(prs),
                    ),
              );
            },
          ),
          IconButton(
            iconSize: 30,
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              prs.sort((a, b) => a.pid.compareTo(b.pid));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GanttChart(prs),
                ),
              );
            },
          ),
          IconButton(
            iconSize: 30,
            icon: Icon(Icons.add_circle),
            onPressed: () {
              createaddDialog(context, prs, timeq);
            },
          ),
          IconButton(
            iconSize: 30,
            icon: Icon(Icons.more_time_rounded),
            onPressed: () {
              createtqDialog(context, prs, timeq);
            },
          ),
        ],
      ),
    );
  }

  Widget buildProcesscard(BuildContext context, int index) {
    TextEditingController econtrol1 = new TextEditingController();
    TextEditingController econtrol2 = new TextEditingController();

    econtrol1 = TextEditingController(text: prs[index].at.toString());
    econtrol2 = TextEditingController(text: prs[index].bt.toString());

    var at = prs[index].at.toString();
    var bt = prs[index].bt.toString();
    var tat = prs[index].tat.toString();
    var start = prs[index].start_time.toString();
    var end = prs[index].ct.toString();
    var wt = prs[index].wt.toString();
    timeq = int.parse(controltq.text);
    void deleteprs(int index, int tq) {
      print("Length of prs before removal is " + prs.length.toString());
      print("TQ is " + tq.toString());
      setState(
        () {
          prs.removeAt(index);
          if (prs.isNotEmpty) {
            prs = rralgo(prs, tq);
          }
        },
      );
      print("Length of prs after removal is " + prs.length.toString());
      printprocess(prs);
    }

    void editprs(int index, TextEditingController econtrol1,
        TextEditingController econtrol2) {
      setState(() {
        prs[index].at = int.parse(econtrol1.text);
        prs[index].bt = int.parse(econtrol2.text);
        prs = rralgo(prs, timeq);
        //prs.sort((a, b) => a.pid.compareTo(b.pid));
      });
    }

    editDialog(BuildContext context, List<Process> prs, int index) {
      return showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ), //this right here
              child: Container(
                height: 280.0,
                width: 200.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'AT:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  TextField(
                                    autofocus: true,
                                    cursorWidth: 3,
                                    cursorColor: Colors.amber,
                                    textAlign: TextAlign.center,
                                    showCursor: true,
                                    controller: econtrol1,
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (text) {
                                      FocusScope.of(context)
                                          .requestFocus(nodebt);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'BT:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  TextField(
                                    textAlign: TextAlign.center,
                                    focusNode: nodebt,
                                    cursorWidth: 3,
                                    cursorColor: Colors.amber,
                                    showCursor: true,
                                    controller: econtrol2,
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (text) {
                                      editprs(index, econtrol1, econtrol2);
                                      Navigator.of(context)
                                          .pop(); // Redraw the Stateful Widget
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 38),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RaisedButton(
                                elevation: 8.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Text("Cancel"),
                                onPressed: () {
                                  control1.clear();
                                  control2.clear();
                                  Navigator.of(context).pop();
                                }),
                            RaisedButton(
                                elevation: 8.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Text("Submit"),
                                onPressed: () {
                                  // print("LOL");
                                  // print(prs);
                                  // print(prs[1].list_start);
                                  // print(prs[1].list_end);
                                  editprs(index, econtrol1, econtrol2);
                                  Navigator.of(context).pop();
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        margin: EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ExpansionTile(
            title: Text(
              "AT: $at\t      \t BT: $bt",
              style: TextStyle(
                fontSize: 23,
              ),
            ),
            leading: CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFFc3ebef),
              child: Text(
                prs[index].pid,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            trailing: Icon(
              Icons.arrow_drop_down_circle_outlined,
            ),
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Start Process: $start",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "End Process: $end",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "TAT: $tat",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "WT: $wt",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      secondaryActions: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Card(
            //radius: 30,
            //margin: EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: IconSlideAction(
              //caption: 'Text1',
              color: Colors.green,
              icon: Icons.edit_outlined,
              onTap: () {
                editDialog(context, prs, index);
                setState(() {});
              },
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Card(
            //radius: 30,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: IconSlideAction(
              //caption: 'Text2',
              color: Color(0XFFF36735),
              icon: Icons.delete_rounded,
              onTap: () {
                //prs.removeAt(index);
                timeq = int.parse(controltq.text);
                deleteprs(index, timeq);
              },
            ),
          ),
        ),
      ],
    );
  }
}
