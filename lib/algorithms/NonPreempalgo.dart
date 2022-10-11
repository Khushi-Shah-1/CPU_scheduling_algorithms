import 'dart:io';
import 'dart:core';

class Process {
  var pid;
  int at = 0;
  int bt = 0;
  int ct;
  // ignore: non_constant_identifier_names
  int start_time;
  int remain_time;
  int tat;
  int wt;

  Process(this.at, this.bt);

  @override
  String toString() {
    // ignore: unnecessary_this
    return '${this.pid}\t${this.at}\t${this.bt}\t${this.ct}\t${this.start_time}\t\t${this.tat}\t${this.wt}';
  }

  void printatbt() {
    stdout.write('$pid\t$at\t$bt\n');
  }

  int tablevalue(int j) {
    switch (j) {
      case 1:
        return this.at;
      case 2:
        return this.bt;
      case 3:
        return this.ct;
      case 4:
        return this.tat;
      case 5:
        return this.wt;
      default:
        return 0;
    }
  }
}

class ioprocess {
  String pid;
  int at;
  int bt1;
  int bt2;
  int iobt;
  int total_burst;
  int remain_time;
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

/*void main(List<String> arguments) {
  List<Process> prsf = [];
  List<Process> prss = [];
  List<Process> prsl = [];
  prsf.add(Process(2, 6));
  prsf.add(Process(5, 2));
  prsf.add(Process(1, 8));
  prsf.add(Process(0, 3));
  prsf.add(Process(4, 4));
  assignPid(prsf);
  List<Process> fcfs = List.from(prsf);
  List<Process> sjf = List.from(prsf);

  prsl.add(Process(0, 2));
  prsl.add(Process(1, 3));
  prsl.add(Process(2, 5));
  prsl.add(Process(3, 7));
  assignPid(prsl);
  List<Process> ljf = List.from(prsl);

  print('\n0.FCFS Algo\n');
  fcfs = fcfsalgo(fcfs);
  printprocess(fcfs);
  print("\n");

  print('\n1.SJF Algo\n');
  sjf = sjfalgo(sjf);
  printprocess(sjf);
  print("\n");

  print('\n2.LJF Algo\n');
  ljf = ljfalgo(ljf);
  printprocess(ljf);
  print("\n");
} */

void startsjf(List l) {
  l.sort((a, b) => a.at.compareTo(b.at));
  for (int j = 1; j < l.length; j++) {
    for (var i = 0; i < l.length - 1; i++) {
      if (l[i].at == l[i + 1].at) {
        if (l[i].remain_time > l[i + 1].remain_time) {
          var temp;
          temp = l[i + 1];
          l[i + 1] = l[i];
          l[i] = temp;
        }
      }
    }
  }
}

void sjfsort(List l) {
  l.sort((a, b) => a.remain_time.compareTo(b.remain_time));
  for (var i = 0; i < l.length - 1; i++) {
    if (l[i].remain_time == l[i + 1].remain_time) {
      if (l[i].at > l[i + 1].at) {
        var temp;
        temp = l[i + 1];
        l[i + 1] = l[i];
        l[i] = temp;
      }
    }
  }
}

void startljf(List l) {
  l.sort((a, b) => a.at.compareTo(b.at));
  for (int j = 1; j < l.length; j++) {
    for (var i = 0; i < l.length - 1; i++) {
      if (l[i].at == l[i + 1].at) {
        if (l[i].remain_time < l[i + 1].remain_time) {
          var temp;
          temp = l[i + 1];
          l[i + 1] = l[i];
          l[i] = temp;
        }
      }
    }
  }
}

void ljfsort(List l) {
  l.sort((a, b) => b.remain_time.compareTo(a.remain_time));
  //print(l);
  for (var i = 0; i < l.length - 1; i++) {
    if (l[i].remain_time == l[i + 1].remain_time) {
      if (l[i].at > l[i + 1].at) {
        var temp;
        temp = l[i + 1];
        l[i + 1] = l[i];
        l[i] = temp;
      }
    }
  }
}

List<Process> fcfsalgo(List<Process> l) {
  int algo = 0;
  l.sort((a, b) => a.at.compareTo(b.at));
  List<Process> fq = [];
  fq = npalgo(l, algo);
  return fq;
}

List<Process> sjfalgo(List<Process> l) {
  int algo = 1;
  startsjf(l);
  List<Process> fq = [];
  fq = npalgo(l, algo);
  return fq;
}

List<Process> ljfalgo(List<Process> l) {
  int algo = 2;
  startljf(l);
  List<Process> fq = [];
  fq = npalgo(l, algo);
  return fq;
}

List<ioprocess> fcfsioalgo(List<ioprocess> l) {
  List<ioprocess> finishedq = [];
  int algo = 0;
  finishedq = npioalgo(l, algo);
  return finishedq;
}

List<ioprocess> sjfioalgo(List<ioprocess> l) {
  List<ioprocess> finishedq = [];
  int algo = 1;
  finishedq = npioalgo(l, algo);
  return finishedq;
}

List<ioprocess> ljfioalgo(List<ioprocess> l) {
  List<ioprocess> finishedq = [];
  int algo = 2;
  finishedq = npioalgo(l, algo);
  return finishedq;
}

//will fill the ready queue(rq) and sort it according to their burst time
void fillrq(List<Process> rq, int time, List<Process> l, int algo) {
  int i = 0;
  int count = 0;
  l.sort((a, b) => a.at.compareTo(b.at));
  while (l.isNotEmpty && count < l.length) {
    if (l[i].at <= time) {
      rq.add(l[i]);
      l.removeAt(i);
      count--;
    } else {
      i++;
    }
    count++;
  }

  if (rq.isNotEmpty) {
    if (algo == 0) {
      rq.sort((a, b) => a.at.compareTo(b.at));
    } else if (algo == 1) {
      sjfsort(rq);
    } else {
      ljfsort(rq);
    }
  }
}

//will delete the process from the parent list and add
//it to the finished list fq
void fillfq(List l, List fq, int i) {
  fq.add(l[i]);
  l.removeAt(i);
}

int processexec(List<Process> lgantt, int stime, List<Process> fq) {
  int time;
  lgantt[0].start_time = stime;
  lgantt[0].ct = lgantt[0].bt + lgantt[0].start_time;
  time = lgantt[0].ct;
  lgantt[0].tat = lgantt[0].ct - lgantt[0].at;
  lgantt[0].wt = lgantt[0].tat - lgantt[0].bt;
  fillfq(lgantt, fq, 0);
  return time;
}

//algo 0 means fcfs, 1 means sjf, 2 means ljf
// ignore: non_constant_identifier_names
List<Process> npalgo(List<Process> l, int algo) {
  List<Process> lgantt = [];
  lgantt = List.from(l);
  for (var item in lgantt) {
    item.ct = item.start_time = item.tat = item.wt = item.ct = null;
    item.remain_time = item.bt;
  }

  List<Process> fq = [];
  List<Process> rq = [];
  int time = 0;
  fillrq(rq, time, lgantt, algo);

  while (time >= 0) {
    if (rq.isEmpty) {
      if (lgantt.isEmpty) {
        break;
      } else {
        //rq is empty but lgantt is not empty
        if (time < lgantt[0].at) {
          time = lgantt[0].at;
        }
        fillrq(rq, time, lgantt, algo);
        time = processexec(rq, time, fq);
      }
    } else {
      fillrq(rq, time, lgantt, algo);
      time = processexec(rq, time, fq);
      fillrq(rq, time, lgantt, algo);
    }
  }
  fq.sort((a, b) => a.pid.compareTo(b.pid));
  return fq;
}

int ioprocessexec(List<ioprocess> lgantt, int stime, List<ioprocess> fq,
    List<ioprocess> ioqueue) {
  int time;
  if (lgantt[0].io == true) {
    // this is when the process has completed its io
    lgantt[0].start_time2 = stime;
    lgantt[0].ct = lgantt[0].bt2 + stime;
    lgantt[0].remain_time -= lgantt[0].bt2;
    time = lgantt[0].ct;
    lgantt[0].tat = lgantt[0].ct - lgantt[0].at;
    lgantt[0].wt = lgantt[0].tat - lgantt[0].bt2 - lgantt[0].bt1;
    fillfq(lgantt, fq, 0);
  } else {
    //this is when the process has not completed its io
    lgantt[0].start_time = stime;
    lgantt[0].ct = lgantt[0].bt1 + lgantt[0].start_time;
    lgantt[0].remain_time -= lgantt[0].bt1;
    time = lgantt[0].ct;
    iofill(lgantt, ioqueue, time);
    //lgantt[0].tat = lgantt[0].ct - lgantt[0].at;
  }
  return time;
}

void iofill(List<ioprocess> l, List<ioprocess> ioqueue, int time) {
  l[0].ioexit = l[0].ct + l[0].iobt;
  l[0].io = true;
  l[0].remain_time -= l[0].iobt;
  ioqueue.add(l[0]);
  l.removeAt(0);
  ioqueue.sort((a, b) => a.ioexit.compareTo(b.ioexit));
  print("ioqueue at time: " + time.toString());
  printpid(ioqueue);
}

//readyq is the reference of readyq list identifier
//algo = 0 means fcfsio, algo = 1 means sjfio , algo = 2 means ljfio
// l is the reference of the main list
void fillrqio(List<ioprocess> readyq, int time, List<ioprocess> l, int algo) {
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
    if (algo == 0) {
      readyq.sort((a, b) => a.at.compareTo(b.at));
    } else if (algo == 1) {
      sjfsort(readyq);
    } else if (algo == 2) {
      ljfsort(readyq);
    }
  }
}

List<ioprocess> npioalgo(List<ioprocess> l, int algo) {
  List<ioprocess> lgantt = [];
  lgantt = List.from(l);

  for (var item in lgantt) {
    item.ct = item.start_time =
        item.start_time2 = item.tat = item.wt = item.ioexit = null;
    item.io = false;
    item.remain_time = item.bt1 + item.bt2 + item.iobt;
  }

  List<ioprocess> readyq = [];
  List<ioprocess> finishedq = [];
  List<ioprocess> ioqueue = [];

  int time = 0;
  if (algo == 0) {
    lgantt.sort((a, b) => a.at.compareTo(b.at));
  } else if (algo == 1) {
    startsjf(lgantt);
  } else if (algo == 2) {
    startljf(lgantt);
  }
  fillrqio(readyq, time, lgantt, algo);

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
          if (time < ioqueue[0].ioexit) {
            time = ioqueue[0].ioexit;
          }
          fillrqio(readyq, time, ioqueue, algo);
          fillrqio(readyq, time, lgantt, algo);
          printiopid(readyq);
          printiopid(ioqueue);
          time = ioprocessexec(readyq, time, finishedq, ioqueue);
        }
      } else {
        //2 false - lgantt is not empty
        if (ioqueue.isEmpty) {
          //3 true - ioqueue and readyq both are empty
          if (time < lgantt[0].at) {
            time = lgantt[0].at;
          }
          fillrqio(readyq, time, lgantt, algo);
          time = ioprocessexec(readyq, time, finishedq, ioqueue);
        } else {
          //3 false - only readyq is empty
          if (time < lgantt[0].at && time < ioqueue[0].ioexit) {
            if (lgantt[0].at < ioqueue[0].ioexit) {
              time = lgantt[0].at;
            } else if (lgantt[0].at >= ioqueue[0].ioexit) {
              time = ioqueue[0].ioexit;
            }
          }
          fillrqio(readyq, time, lgantt, algo);
          fillrqio(readyq, time, ioqueue, algo);
          time = ioprocessexec(readyq, time, finishedq, ioqueue);
        }
      }
    } else {
      //1 readyq is not empty
      fillrqio(readyq, time, lgantt, algo);
      fillrqio(readyq, time, ioqueue, algo);

      time = ioprocessexec(readyq, time, finishedq, ioqueue);

      fillrqio(readyq, time, lgantt, algo);
      fillrqio(readyq, time, ioqueue, algo);
    }
  }
  finishedq.sort((a, b) => a.pid.compareTo(b.pid));
  return finishedq;
}

void assignPid(List l) {
  for (int i = 0; i < l.length; i++) {
    l[i].pid = 'P$i';
  }
}

void printprocess(List l) {
  print('Pid\tat\tbt\tct\tstart_time\ttat\t wt');
  for (var item in l) {
    print(item);
  }
}

void printpid(List l) {
  for (var i = 0; i < l.length; i++) {
    stdout.write(l[i].pid + " , ");
  }
  print("\n");
}

void printiopid(List<ioprocess> l) {
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
