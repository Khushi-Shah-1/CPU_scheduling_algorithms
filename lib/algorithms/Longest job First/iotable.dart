import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazy_data_table/lazy_data_table.dart';
import 'package:os_project/algorithms/NonPreempalgo.dart';
//import 'ljf_io.dart';

class TheTable extends StatefulWidget {
  List<ioprocess> prs;
  TheTable(this.prs);
  @override
  _TheTableState createState() => _TheTableState(prs);
}

class _TheTableState extends State<TheTable> {
  List<ioprocess> prs;
  _TheTableState(this.prs);
  final List colum_head = [
    'pid',
    'at',
    'bt1',
    'bt2',
    'iobt',
    'ct',
    'tat',
    'wt'
  ];
  final int j = 0;
  int thing(i, j) {
    return prs[i].tablevalue(j);
  }

  @override
  Widget build(BuildContext context) {
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
            'Process Table',
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
                child: LazyDataTable(
                  columns: 8,
                  rows: prs.length,
                  tableDimensions: LazyDataTableDimensions(
                    columnHeaderHeight: 50,
                    cellHeight: 50,
                    cellWidth: (MediaQuery.of(context).size.width) / 8,
                  ),
                  columnHeaderBuilder: (i) =>
                      Center(child: Text(colum_head[i].toUpperCase())),
                  dataCellBuilder: (i, j) => Center(
                    child: (j == 0)
                        ? Text(
                            prs[i].pid,
                          )
                        : Text(thing(i, j).toString()),
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
