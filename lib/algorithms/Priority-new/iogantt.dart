import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'prior_io.dart';
import 'dart:math';
import 'priority.dart';

class GanttChart extends StatefulWidget {
  AnimationController animationController;
  int fromTime = 3;
  int toTime = 6;
  List<ioprocess> prs;
  List<String> usersInChart = ["Hi"];

  int viewRange = 6;
  int viewRangeToFitScreen = 6;
  Animation<double> width;
  //
  // GanttChart({
  //   this.animationController,
  //   this.fromTime = 3,
  //   this.toTime = 5,
  //   this.data,
  //   this.usersInChart,
  // }) {
  //   viewRange = calculateTimeBetween(fromTime, toTime);
  // }

  GanttChart(this.prs);
  @override
  _GanttChartState createState() => _GanttChartState(prs);
}

class _GanttChartState extends State<GanttChart> {
  AnimationController animationController;
  List<ioprocess> prs;
  int fromTime;
  int toTime;
  int viewRange = 10;
  Bruh() {
    prs.sort((a, b) => a.start_time.compareTo(b.start_time));
    if (prs.length >= 1) {
      fromTime = prs[0].at;
      prs.sort((a, b) => a.ct.compareTo(b.ct));
      toTime = prs[prs.length - 1].ct;
    } else {
      fromTime = 0;
      toTime = 4;
    }
    viewRange = toTime;
    prs.sort((a, b) => a.start_time.compareTo(b.start_time));
  }

  List<String> usersInChart;
  int viewRangeToFitScreen = 6;
  Animation<double> width;

  final List<Color> GanttColors = [
    Color(0xFFC3EBEF),
    Color(0xFFEE97D0),
    Color(0xFF22456D),
    Color(0XFFF36735),
  ];
  //List colors = [Colors.red, Colors.green, Colors.yellow];
  Color randomColorGenerator() {
    return GanttColors[new Random().nextInt(3)];

    //var r = new Random();
    //return
    //Color.fromRGBO(r.nextInt(256), r.nextInt(256), r.nextInt(256), 0.75);
  }

  int calculateTimeBetween(int from, int to) {
    return to - from;
  }

  int calculateDistanceToLeftBorder(int processStartedAt) {
    if (processStartedAt.compareTo(fromTime) <= 0) {
      return 0;
    } else
      return calculateTimeBetween(fromTime, processStartedAt) - 1;
  }

  int calculateRemainingWidth(int processStartedAt, int processEndedAt) {
    int projectLength = calculateTimeBetween(processStartedAt, processEndedAt);
    if (processStartedAt.compareTo(fromTime) >= 0 &&
        processStartedAt.compareTo(toTime) <= 0) {
      if (projectLength <= viewRange)
        return projectLength;
      else
        return viewRange - calculateTimeBetween(fromTime, processStartedAt);
    } else if (processStartedAt < fromTime && processEndedAt < fromTime) {
      return 0;
    } else if (processStartedAt < fromTime && processEndedAt < toTime) {
      return projectLength - calculateTimeBetween(processStartedAt, fromTime);
    } else if (processStartedAt < fromTime && processEndedAt > toTime) {
      return viewRange;
    }
    return 0;
  }

  Widget buildHeader(double chartViewWidth, Color color) {
    List<Widget> headerItems = new List();

    int tempTime = fromTime;

    headerItems.add(Container(
      width: chartViewWidth / viewRangeToFitScreen,
      child: new Text(
        'TYPE',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
      ),
    ));

    for (int i = 0; i < viewRange; i++) {
      headerItems.add(Container(
        width: chartViewWidth / viewRangeToFitScreen,
        child: new Text(
          tempTime.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25.0,
          ),
        ),
      ));
      // tempTime = Utils.nextMonth(tempTime);
      tempTime += 1;
    }

    return Container(
      height: 44.0,
      color: color.withAlpha(500),
      child: Row(
        children: headerItems,
      ),
    );
  }

  Widget buildGrid(double chartViewWidth) {
    List<Widget> gridColumns = new List();

    for (int i = 0; i <= viewRange; i++) {
      gridColumns.add(Container(
        decoration: BoxDecoration(
            border: Border(
                right:
                    BorderSide(color: Colors.grey.withAlpha(100), width: 1.0))),
        width: chartViewWidth / viewRangeToFitScreen,
        //height: 300.0,
      ));
    }

    return Row(
      children: gridColumns,
    );
  }

  List<Widget> buildChartBars(
      List<Process> data, double chartViewWidth, Color color) {
    List<Widget> chartBars = new List();

    for (int i = 0;
        i < data.length;
        data.length == prs.length ? i += 1 : i += 2) {
      var remainingWidth1 =
          calculateRemainingWidth(data[i].ct - data[i].bt, data[i].ct);
      var remainingWidth2 = 0;
      if (data.length != prs.length) {
        remainingWidth2 = calculateRemainingWidth(
            data[i + 1].ct - data[i + 1].bt, data[i + 1].ct);
      }
      if (remainingWidth1 > 0) {
        chartBars.add(data.length == prs.length
            ? Container(
                decoration: BoxDecoration(
                    color: color.withAlpha(100),
                    borderRadius: BorderRadius.circular(30.0)),
                height: 35.0,
                width: remainingWidth1 * chartViewWidth / viewRangeToFitScreen,
                margin: EdgeInsets.only(
                    left: calculateDistanceToLeftBorder(
                            data[i].ct + 1 - data[i].bt) *
                        chartViewWidth /
                        viewRangeToFitScreen,
                    top: i == 0 ? 4.0 : 2.0,
                    bottom: i == data.length - 1 ? 4.0 : 2.0),
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    data[i].pid,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: color.withAlpha(100),
                        borderRadius: BorderRadius.circular(30.0)),
                    height: 35.0,
                    width:
                        remainingWidth1 * chartViewWidth / viewRangeToFitScreen,
                    margin: EdgeInsets.only(
                        left: calculateDistanceToLeftBorder(
                                data[i].ct + 1 - data[i].bt) *
                            chartViewWidth /
                            viewRangeToFitScreen,
                        top: i == 0 ? 4.0 : 2.0,
                        bottom: i == data.length - 1 ? 4.0 : 2.0),
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        data[i].pid,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: color.withAlpha(100),
                        borderRadius: BorderRadius.circular(30.0)),
                    height: 35.0,
                    width:
                        remainingWidth2 * chartViewWidth / viewRangeToFitScreen,
                    margin: EdgeInsets.only(
                        left: (calculateDistanceToLeftBorder(
                                    data[i + 1].ct + 1 - data[i + 1].bt) -
                                data[i].ct +
                                fromTime) *
                            chartViewWidth /
                            viewRangeToFitScreen,
                        top: i == 0 ? 4.0 : 2.0,
                        bottom: i == data.length - 1 ? 4.0 : 2.0),
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        data[i].pid,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ));
      }
    }

    return chartBars;
  }

  Widget buildChartForEachUser(
      List<Process> userData, double chartViewWidth, String user) {
    Color color = randomColorGenerator();
    var chartBars = buildChartBars(userData, chartViewWidth, color);
    return Container(
      height: chartBars.length * 39.0 + 44.0 + 4.0,
      // height: 200,
      child: Stack(fit: StackFit.loose, children: <Widget>[
        buildGrid(chartViewWidth),
        buildHeader(chartViewWidth, color),
        Container(
            margin: EdgeInsets.only(top: 44.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                            width: chartViewWidth / viewRangeToFitScreen,
                            height: chartBars.length * 39.0 + 4.0,
                            // height: 150,
                            color: color.withAlpha(100),
                            child: Center(
                              child: new RotatedBox(
                                quarterTurns:
                                    chartBars.length * 39.0 + 4.0 > 50 ? 0 : 0,
                                child: Text(
                                  user,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: chartBars,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ]),
    );
  }

  _GanttChartState(this.prs);

  @override
  Widget build(BuildContext context) {
    Bruh();
    List<Process> prsNew = [];
    // prsNew.sort((a, b) => (a.start_time).compareTo(b.start_time));

    if (prs.length >= 1) {
      int i = 0;
      int j = 0;
      while (i < prs.length) {
        prsNew.add(Process(prs[i].at, prs[i].bt1, prs[i].priority));
        prsNew[prsNew.length - 1].ct = prs[i].start_time + prs[i].bt1;
        prsNew[prsNew.length - 1].pid = prs[i].pid;
        prsNew.add(Process(prs[i].at, prs[i].bt2, prs[i].priority));
        prsNew[prsNew.length - 1].ct = prs[i].start_time2 + prs[i].bt2;
        prsNew[prsNew.length - 1].pid = prs[i].pid;
        i += 1;
      }
    }

    // print("prs: " + prs.toString());
    // print("prsNew: " + prsNew.toString());

    List<Process> prsIO = [];
    if (prs.length >= 1) {
      int i = 0;
      while (i < prs.length) {
        prsIO.add(Process(prs[i].at, prs[i].iobt, prs[i].priority));
        prsIO[prsIO.length - 1].ct =
            prs[i].start_time + prs[i].bt1 + prs[i].iobt;
        prsIO[prsIO.length - 1].pid = prs[i].pid;
        i += 1;
      }
    }
    //
    // print(prsNew);
    //
    return MaterialApp(
      //   debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff22456d),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Gantt Chart',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              //fontSize: 14,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                buildChartForEachUser(prsNew, 300.0, "Prs"),
                buildChartForEachUser(prsIO, 300.0, "IO"),
              ],
            ),
          ),
        ),
      ),
    );
    //     body: Center(
    //       child: Column(
    //         children: [
    //           Expanded(
    //             child: Timeline.tileBuilder(
    //               theme: TimelineThemeData(
    //                 direction: Axis.vertical,
    //                 connectorTheme: ConnectorThemeData(
    //                   color: Colors.redAccent,
    //                   space: 30.0,
    //                   thickness: 5.0,
    //                 ),
    //                 indicatorTheme: IndicatorThemeData(
    //                   size: 20.0,
    //                 ),
    //               ),
    //               builder: TimelineTileBuilder.fromStyle(
    //                 contentsAlign: ContentsAlign.alternating,
    //                 contentsBuilder: (context, index) => Container(
    //                   margin: EdgeInsets.all(7),
    //                   decoration: BoxDecoration(
    //                     color: Colors.white,
    //                     borderRadius: BorderRadius.only(
    //                         topLeft: Radius.circular(10),
    //                         topRight: Radius.circular(10),
    //                         bottomLeft: Radius.circular(10),
    //                         bottomRight: Radius.circular(10)),
    //                     boxShadow: [
    //                       BoxShadow(
    //                         color: Colors.grey.withOpacity(0.5),
    //                         spreadRadius: 3,
    //                         blurRadius: 5,
    //                         offset: Offset(0, 3), // changes position of shadow
    //                       ),
    //                     ],
    //                   ),
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(10.0),
    //                     child: Text(
    //                       prsNew[index].pid.toString() +
    //                           "\nTime: " +
    //                           (prsNew[index].ct - prsNew[index].bt).toString() +
    //                           " to " +
    //                           (prsNew[index].ct).toString(),
    //                       style: TextStyle(
    //                         fontSize: 20.0,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 itemCount: prsNew.length,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
