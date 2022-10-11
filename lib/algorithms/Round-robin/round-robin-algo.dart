import 'dart:io';
import 'dart:core';

class Process {
  var pid;
  int at = 0;
  int bt = 0;
  int ct;
  int remain_time;
  bool started = false; // if true - the 1st execution of the process
  //was done
  // ignore: non_constant_identifier_names
  int start_time;
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

/*void main(List<String> arguments) {
  List<Process> prs = [];
  prs.add(Process(0, 8));
  prs.add(Process(5, 2));
  prs.add(Process(1, 7));
  prs.add(Process(6, 3));
  prs.add(Process(8, 5));
  assignPid(prs);
  List<Process> fcfs = List.from(prs);
  int tq = 3;
  print('\n1 fcfs Algo\n');
  fcfs.sort((a, b) => a.at.compareTo(b.at));
  fcfs = rralgo(fcfs, tq);
  //sjf.sort((a, b) => a.pid.compareTo(b.pid));
  printprocess(fcfs);
} */

List<Process> rralgo(List<Process> l, int tq) {
  List<Process> lgantt = [];
  lgantt = List.from(l); //lgantt is the local copy of the processes list
  List<Process> rq = [];
  List<Process> fq = [];

  for (var item in lgantt) {
    item.ct = item.start_time = item.tat = item.wt = 0;
    item.remain_time = item.bt;
    item.started = false;
  }

  lgantt.sort((a, b) => a.at.compareTo(b.at));
  int time = 0;
  fillrq(rq, time, lgantt);

  while (time >= 0) {
    if (rq.isEmpty) {
      if (lgantt.isEmpty) {
        break;
      } else {
        if (time >= lgantt[0].at) {
          fillrq(rq, time, lgantt);
          print("at time " + time.toString() + " rq - ");
          printpid(rq);
          time = processexec(rq, time, fq, tq, lgantt);
          //fillrq(rq, time, lgantt);
        } else {
          time = lgantt[0].at;
          fillrq(rq, time, lgantt);
          print("at time " + time.toString() + " rq - ");
          printpid(rq);
          time = processexec(rq, time, fq, tq, lgantt);
          //fillrq(rq, time, lgantt);
        }
      }
    } else {
      print("at time " + time.toString() + " rq - ");
      printpid(rq);
      time = processexec(rq, time, fq, tq, lgantt);
    }
  }
  fq.sort((a, b) => a.pid.compareTo(b.pid));
  return fq;
}

//will fill the ready queue(rq) and sort it according to their burst time
void fillrq(List<Process> rq, int time, List<Process> l) {
  int i = 0;
  int count = 0;
  l.sort((a, b) => a.at.compareTo(b.at));
  while (l.isNotEmpty && count < l.length && i < l.length) {
    if (l[i].at <= time) {
      rq.add(l[i]);
      l.removeAt(i);
      count--;
    } else {
      i++;
    }
    count++;
  }

  /*if (rq.isNotEmpty) {
    rq.sort((a, b) => a.at.compareTo(b.at));
  } */
}

//will delete the process from the parent list and add
//it to the finished list fq
void fillfq(List<Process> l, List<Process> fq, int i) {
  fq.add(l[i]);
  l.removeAt(i);
}

int processexec(List<Process> rq, int time, List<Process> fq, int tq,
    List<Process> lgantt) {
  int time1 = 0;
  if (rq[0].started == false) {
    rq[0].start_time = time;
    rq[0].started = true;
  }

  if (rq[0].remain_time <= tq) {
    rq[0].ct = rq[0].remain_time + time;
    time1 = rq[0].ct;
    rq[0].remain_time = 0;
    rq[0].tat = rq[0].ct - rq[0].at;
    rq[0].wt = rq[0].tat - rq[0].bt;
    fillfq(rq, fq, 0);
  } else {
    rq[0].ct = tq + time;
    rq[0].remain_time = rq[0].remain_time - tq;
    time1 = rq[0].ct;
    fillrq(rq, time1, lgantt);
    rq.add(rq[0]);
    rq.removeAt(0);
  }
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
