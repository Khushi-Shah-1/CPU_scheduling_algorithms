import 'dart:io';
import 'dart:core';

class Process {
  var pid;
  int at = 0;
  int bt = 0;
  int ct;
  int remain_time;
  bool started = false;
  // ignore: non_constant_identifier_names
  int start_time;
  int tat;
  int wt;
  List<int> list_start = [];
  List<int> list_end = [];

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

/*void main(List<String> arguments) {
  List<Process> prsl = List<Process>();
  List<Process> prss = [];
  prsl.add(Process(1, 2));
  prsl.add(Process(2, 4));
  prsl.add(Process(3, 6));
  prsl.add(Process(4, 8));

  prss.add(Process(0, 8));
  prss.add(Process(1, 4));
  prss.add(Process(2, 2));
  prss.add(Process(3, 1));
  prss.add(Process(4, 3));
  prss.add(Process(5, 2));

  assignPid(prss);
  assignPid(prsl);
  List<Process> ljf = List.from(prsl);
  List<Process> sjf = List.from(prss);

  print('\n1.LRTF Algo\n');
  ljf = lrtfalgo(ljf);
  printprocess(ljf);

  print("\n2. SRTF Algo\n");
  sjf = srtfalgo(sjf);
  printprocess(sjf);
}
*/
void lganttsortlrt(List<Process> l) {
  l.sort((a, b) => a.at.compareTo(b.at));
  for (int j = 1; j < l.length; j++) {
    for (var i = 0; i < l.length - 1; i++) {
      if (l[i].at == l[i + 1].at) {
        if (l[i].remain_time < l[i + 1].remain_time) {
          Process temp;
          temp = l[i + 1];
          l[i + 1] = l[i];
          l[i] = temp;
        }
      }
    }
  }
}

void lganttsortsrt(List<Process> l) {
  l.sort((a, b) => a.at.compareTo(b.at));
  for (int j = 1; j < l.length; j++) {
    for (var i = 0; i < l.length - 1; i++) {
      if (l[i].at == l[i + 1].at) {
        if (l[i].remain_time > l[i + 1].remain_time) {
          Process temp;
          temp = l[i + 1];
          l[i + 1] = l[i];
          l[i] = temp;
        }
      }
    }
  }
}

List<Process> lrtfalgo(List<Process> l) {
  List<Process> lgantt = [];
  lgantt = List.from(l); //lgantt is the local copy of the processes list
  List<Process> rq = [];
  List<Process> fq = [];

  for (var item in lgantt) {
    item.ct = item.start_time = item.tat = item.wt = 0;
    item.remain_time = item.bt;
    item.started = false;
  }

  // printprocess(lgantt);

  lganttsortlrt(lgantt);
  int time = 0;
  fillrq(rq, time, lgantt, true);

  while (time >= 0) {
    //preemption would be done while executing
    time = processexec(rq, time, fq, lgantt, true);
    break;
  }

  fq.sort((a, b) => a.pid.compareTo(b.pid));
  return fq;
}

List<Process> srtfalgo(List<Process> l) {
  List<Process> lgantt = [];
  lgantt = List.from(l); //lgantt is the local copy of the processes list
  List<Process> rq = [];
  List<Process> fq = [];

  for (var item in lgantt) {
    item.ct = item.start_time = item.tat = item.wt = 0;
    item.remain_time = item.bt;
    item.started = false;
  }

  lganttsortsrt(lgantt);
  int time = 0;
  fillrq(rq, time, lgantt, false);

  while (time >= 0) {
    //preemption would be done while executing
    time = processexec(rq, time, fq, lgantt, false);
    break;
  }
  for (var item in fq) {
    item.tat = item.ct - item.at;
    item.wt = item.tat - item.bt;
  }
  fq.sort((a, b) => a.pid.compareTo(b.pid));
  return fq;
}

void srtfsort(List<Process> l) {
  l.sort((a, b) => a.remain_time.compareTo(b.remain_time));
  for (var i = 0; i < l.length - 1; i++) {
    if (l[i].remain_time == l[i + 1].remain_time) {
      if (l[i].at > l[i + 1].at) {
        Process temp;
        temp = l[i + 1];
        l[i + 1] = l[i];
        l[i] = temp;
      }
    }
  }
}

void lrtfsort(List<Process> l) {
  l.sort((a, b) => b.remain_time.compareTo(a.remain_time));
  for (var i = 0; i < l.length - 1; i++) {
    if (l[i].remain_time == l[i + 1].remain_time) {
      if (l[i].at > l[i + 1].at) {
        Process temp;
        temp = l[i + 1];
        l[i + 1] = l[i];
        l[i] = temp;
      }
    }
  }
}

//will fill the ready queue(rq) and sort it according to their burst time
void fillrq(List<Process> rq, int time, List<Process> l, bool algo) {
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
    if (algo) {
      lrtfsort(rq);
    } else {
      srtfsort(rq);
    }
  }
}

//will delete the process from the parent list and add
//it to the finished list fq
void fillfq(List<Process> l, List<Process> fq, int i) {
  fq.add(l[i]);
  l.removeAt(i);
}

//if algo = true, it is lrtf, else it is srtf
int processexec(List<Process> rq, int time, List<Process> fq,
    List<Process> lgantt, bool algo) {
  int time1 = 0;
  print("started preemption");
  //preemption
  while (lgantt.isNotEmpty || rq.isNotEmpty) {
    if (rq.isEmpty) {
      if (lgantt.isEmpty) {
        break;
      } else {
        time = lgantt[0].at;
        fillrq(rq, time, lgantt, algo);
      }
    }

    if (rq[0].started == false) {
      rq[0].started = true;
      print(rq[0].pid + " started at " + time.toString());
      rq[0].start_time = time;
    }

    //print(rq[0].pid + " at time " + time.toString());
    rq[0].remain_time -= 1;
    time += 1;
    rq[0].ct = time;
    if (rq[0].remain_time <= 0) {
      //print(rq[0].pid + " ended at " + time.toString());
      rq[0].tat = rq[0].ct - rq[0].at;
      rq[0].wt = rq[0].tat - rq[0].bt;
      fillfq(rq, fq, 0);
    }
    if (rq.isNotEmpty) {
      if (algo) {
        lrtfsort(rq);
      } else {
        srtfsort(rq);
      }
    }
    if (lgantt.isNotEmpty) {
      fillrq(rq, time, lgantt, algo);
    }
  }

  time1 = time;
  return time1;
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

void printpid(List<Process> l) {
  for (var i = 0; i < l.length; i++) {
    stdout.write(l[i].pid + " , ");
  }
  print("\n");
}
