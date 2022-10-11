import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'Main-rr.dart';
import 'round-robin.dart';

class GanttChart extends StatefulWidget {
  List<Process> prs;
  GanttChart(this.prs);
  @override
  _GanttChartState createState() => _GanttChartState(prs);
}

void adder(int time1, int time2, List<Process> prsNew) {
  List<Process> prs;
  prsNew.add(Process((time1), time2));
  assignPid(prsNew);
}

class _GanttChartState extends State<GanttChart> {
  List<Process> prs;
  _GanttChartState(this.prs);

  @override
  Widget build(BuildContext context) {
    List<Process> prsNew = [];
    List<Process> prsadd = [];
    prsNew = prs.toList();

    if (prsNew.length >= 1) {
      int i = 0;
      for (i = 0; i < prsNew.length; i++) {
        for (int list_index = 0;
            list_index < prsNew[i].list_end.length;
            list_index++) {
          prsadd.add(Process(prsNew[i].at, prsNew[i].bt));
          prsadd[prsadd.length - 1].start_time =
              prsNew[i].list_start[list_index];
          prsadd[prsadd.length - 1].ct = prsNew[i].list_end[list_index];
          prsadd[prsadd.length - 1].pid = prsNew[i].pid;
        }
      }
    }

    prsadd.sort((a, b) => (a.start_time).compareTo(b.start_time));

    if (prsNew.length >= 1) {
      int i = 0;
      while (i < prsadd.length - 1) {
        if (prsadd[i].ct < prsadd[i + 1].start_time) {
          prsadd.add(
              Process(prsadd[i].ct, prsadd[i + 1].start_time - prsadd[i].ct));
          prsadd[prsadd.length - 1].pid = "Idle";
          prsadd[prsadd.length - 1].ct = prsadd[i + 1].start_time;
          prsadd[prsadd.length - 1].start_time = prsadd[i].ct;
        }
        i += 1;
      }
    }

    prsadd.sort((a, b) => (a.start_time).compareTo(b.start_time));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: Timeline.tileBuilder(
                  theme: TimelineThemeData(
                    direction: Axis.vertical,
                    connectorTheme: ConnectorThemeData(
                      color: Color(0XFF22456D),
                      space: 30.0,
                      thickness: 5.0,
                    ),
                    indicatorTheme: IndicatorThemeData(
                      color: Color(0xFFEE97D0),
                      size: 20.0,
                    ),
                  ),
                  builder: TimelineTileBuilder.fromStyle(
                    contentsAlign: ContentsAlign.alternating,
                    contentsBuilder: (context, index) =>
                        prsadd[index].pid == "Idle"
                            ? Container(
                                margin: EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: Colors.orange[300],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.6),
                                      spreadRadius: 3,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    prsadd[index].pid.toString() +
                                        "\nTime: " +
                                        (prsadd[index].start_time).toString() +
                                        " to " +
                                        (prsadd[index].ct).toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: Color(0XFFF36735),
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
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    prsadd[index].pid.toString() +
                                        "\nTime: " +
                                        (prsadd[index].start_time).toString() +
                                        " to " +
                                        (prsadd[index].ct).toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                    itemCount: prsadd.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
