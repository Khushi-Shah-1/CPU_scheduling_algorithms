//import 'dart:collection';
import 'dart:io';
import 'dart:core';

class ioprocess {
  String pid;
  int at;
  int bt1;
  int bt2;
  int iobt;
  int total_burst;
  int ioexit;
  bool io = false; //if io is completed then value is true, else false
  int ct;
  int start_time;
  int start_time2;
  int tat;
  int wt;

  ioprocess(this.at, this.bt1, this.iobt, this.bt2);

  @override
  String toString() {
    // ignore: unnecessary_this
    return '${this.pid}\t${this.at}\t${this.bt1}\t${this.iobt}\t${this.bt2}\t${this.ct}\t${this.start_time}\t\t${this.start_time2}\t\t${this.tat}\t${this.wt}';
  }

  void printatbt() {
    stdout.write('$pid\t$at\t$bt1\t$iobt\t$bt2\t\n');
  }

  int tablevalue(int j) {
    switch (j) {
      case 1:
        return this.at;
      case 2:
        return this.bt1;
      case 3:
        return this.bt2;
      case 4:
        return this.iobt;
      case 5:
        return this.ct;
      case 6:
        return this.tat;
      case 7:
        return this.wt;
      default:
        return 0;
    }
  }
}

void main(List<String> arguments) {
  List<ioprocess> prs = [];
  prs.add(ioprocess(0, 6, 10, 4));
  prs.add(ioprocess(0, 9, 15, 6));
  prs.add(ioprocess(0, 3, 5, 2));
  assignPid(prs);
  totalburst(prs);
  List<ioprocess> fio = List.from(prs);

  print('\n1.Ljfio Algo   \n');
  fio.sort((a, b) => a.at.compareTo(b.at));
  fio = ljfioalgo(fio);

  printprocess(fio);
}

void startljf(List<ioprocess> l) {
  totalburst(l);
  l.sort((a, b) => a.at.compareTo(b.at));
  for (int j = 1; j < l.length; j++) {
    for (var i = 0; i < l.length - 1; i++) {
      if (l[i].at == l[i + 1].at) {
        if (l[i].total_burst < l[i + 1].total_burst) {
          ioprocess temp;
          temp = l[i + 1];
          l[i + 1] = l[i];
          l[i] = temp;
        }
      }
    }
  }
}

List<ioprocess> ljfioalgo(List<ioprocess> l) {
  List<ioprocess> lgantt = [];
  lgantt = List.from(l);
  for (var item in lgantt) {
    item.ct = item.start_time =
        item.start_time2 = item.tat = item.wt = item.ioexit = null;
    item.io = false;
  }
  totalburst(lgantt);
  List<ioprocess> readyq = [];
  List<ioprocess> finishedq = [];
  List<ioprocess> ioqueue = [];

  int time = 0;
  startljf(lgantt);
  fillrq(readyq, time, lgantt);

  while (time >= 0) {
    if (readyq.isEmpty) {
      //1 true - readyq is empty
      if (lgantt.isEmpty) {
        //2 true - lgantt and readyq both are empty
        if (ioqueue.isEmpty) {
          //3 - true - all 3 queues are empty
          break;
        } else {
          //3 - false - only ioqueue is not empty
          if (time >= ioqueue[0].ioexit) {
            //4 true - ioq[0] has arrived
            fillrq(readyq, time, ioqueue);
            print("readyq after filling it from ioq at time - " +
                time.toString());
            printpid(readyq);
            print("ioq at that time");
            printpid(ioqueue);
            time = processexec(readyq, time, finishedq, ioqueue);
          } else {
            //4 false - ioq[0] has not arrived
            time = ioqueue[0].ioexit;
            fillrq(readyq, time, ioqueue);
            print(
                "readyq after filling it from ioq when ioq[0] has not arrived at time - " +
                    time.toString());
            printpid(readyq);
            time = processexec(readyq, time, finishedq, ioqueue);
          }
        }
      } else {
        //2 false - lgantt is not empty
        if (ioqueue.isEmpty) {
          //3 true - ioqueue and readyq both are empty
          if (time >= lgantt[0].at) {
            //4 true - process from lgantt has arrived
            fillrq(readyq, time, lgantt);
            time = processexec(readyq, time, finishedq, ioqueue);
          } else {
            //4 false - process from lgantt has not arrived
            time = lgantt[0].at;
            fillrq(readyq, time, lgantt);
            time = processexec(readyq, time, finishedq, ioqueue);
          }
        } else {
          //3 false - only readyq is empty
          fillrq(readyq, time, lgantt);
          fillrq(readyq, time, ioqueue);
          time = processexec(readyq, time, finishedq, ioqueue);
        }
      }
    } else {
      //1 readyq is not empty
      if (lgantt.isNotEmpty) {
        fillrq(readyq, time, lgantt);
      }
      if (ioqueue.isNotEmpty) {
        fillrq(readyq, time, ioqueue);
      }
      time = processexec(readyq, time, finishedq, ioqueue);
      if (lgantt.isNotEmpty) {
        fillrq(readyq, time, lgantt);
      }
      if (ioqueue.isNotEmpty) {
        fillrq(readyq, time, ioqueue);
      }
    }
  }
  return finishedq;
}

int processexec(List<ioprocess> lgantt, int stime, List<ioprocess> fq,
    List<ioprocess> ioqueue) {
  int time;
  if (lgantt[0].io == true) {
    // this is when the process has completed its io
    lgantt[0].start_time2 = stime;
    lgantt[0].ct = lgantt[0].bt2 + stime;
    time = lgantt[0].ct;
    lgantt[0].tat = lgantt[0].ct - lgantt[0].at;
    lgantt[0].wt = lgantt[0].tat - lgantt[0].bt2 - lgantt[0].bt1;
    fillfq(lgantt, fq, 0);
  } else {
    //this is when the process has not completed its io
    lgantt[0].start_time = stime;
    lgantt[0].ct = lgantt[0].bt1 + lgantt[0].start_time;
    time = lgantt[0].ct;
    iofill(lgantt, ioqueue, time);
    //lgantt[0].tat = lgantt[0].ct - lgantt[0].at;
  }
  return time;
}

void iofill(List<ioprocess> l, List<ioprocess> ioqueue, int time) {
  l[0].ioexit = l[0].ct + l[0].iobt;
  l[0].io = true;
  ioqueue.add(l[0]);
  l.removeAt(0);
  ioqueue.sort((a, b) => a.ioexit.compareTo(b.ioexit));
  print("ioqueue at time: " + time.toString());
  printpid(ioqueue);
}

//readyq is the reference of readyq list identifier
// l is the reference of the main list
void fillrq(List<ioprocess> readyq, int time, List<ioprocess> l) {
  int i = 0;
  int count = 0;
  l.sort((a, b) => a.at.compareTo(b.at));
  if (l.isNotEmpty) {
    if (l[0].io == false) {
      while (l.isNotEmpty && count < l.length) {
        if (l[i].at <= time) {
          readyq.add(l[i]);
          l.removeAt(i);
          count--;
        } else {
          i++;
        }
        count++;
      }
    } else {
      while (l.isNotEmpty && count < l.length) {
        if (l[i].ioexit <= time) {
          readyq.add(l[i]);
          l.removeAt(i);
          count--;
        } else {
          i++;
        }
        count++;
      }
      l.sort((a, b) => a.ioexit.compareTo(b.ioexit));
    }
  }

  if (readyq.isNotEmpty) {
    ljfsort(readyq);
  }
}

void ljfsort(List<ioprocess> l) {
  l.sort((a, b) => b.total_burst.compareTo(a.total_burst));
  for (int j = 1; j <= l.length; j++) {
    for (var i = 0; i < l.length - 1; i++) {
      if (l[i].io && l[i + 1].io) {
        if (l[i].bt2 < l[i + 1].bt2) {
          ioprocess temp;
          temp = l[i + 1];
          l[i + 1] = l[i];
          l[i] = temp;
        }
      } else if (l[i].io == false && l[i + 1].io == false) {
        if (l[i].total_burst < l[i + 1].total_burst) {
          ioprocess temp;
          temp = l[i + 1];
          l[i + 1] = l[i];
          l[i] = temp;
        }
      } else if (l[i].io == true && l[i + 1].io == false) {
        if (l[i].bt2 < l[i + 1].total_burst) {
          ioprocess temp;
          temp = l[i + 1];
          l[i + 1] = l[i];
          l[i] = temp;
        }
      } else if (l[i].io == false && l[i + 1].io == true) {
        if (l[i].total_burst < l[i + 1].bt2) {
          ioprocess temp;
          temp = l[i + 1];
          l[i + 1] = l[i];
          l[i] = temp;
        }
      }
    }
  }
}

void fillfq(List<ioprocess> l, List<ioprocess> fq, int i) {
  fq.add(l[i]);
  l.removeAt(i);
}

void printprocess(List l) {
  print('Pid\tat\tbt1\tiobt\tbt2\tct\tstart_time\tstart_time2\ttat\t wt');
  for (var item in l) {
    print(item);
  }
}

void printpid(List<ioprocess> l) {
  if (l.isNotEmpty) {
    if (l[0].io) {
      for (var i = 0; i < l.length; i++) {
        // ignore: prefer_single_quotes
        stdout.write(l[i].pid + " - " + l[i].ioexit.toString() + ", ");
      }
    } else {
      for (var i = 0; i < l.length; i++) {
        // ignore: prefer_single_quotes
        stdout.write(l[i].pid + ", ");
      }
    }
  } else {
    print("the list is empty");
  }
  print("\n");
}

void assignPid(List l) {
  for (int i = 0; i < l.length; i++) {
    l[i].pid = 'P$i';
  }
}

void totalburst(List<ioprocess> l) {
  int i;
  for (i = 0; i < l.length; i++) {
    l[i].total_burst = l[i].bt1 + l[i].bt2 + l[i].iobt;
  }
}
