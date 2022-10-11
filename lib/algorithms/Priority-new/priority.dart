import 'dart:io';
import 'dart:core';

class Process {
  var pid;
  int at = 0;
  int bt = 0;
  int priority;
  int ct;
  // ignore: non_constant_identifier_names
  int start_time;
  int tat;
  int wt;

  Process(this.at, this.bt, this.priority);

  @override
  String toString() {
    // ignore: unnecessary_this
    return '${this.pid}\t${this.at}\t${this.bt}\t${this.priority}\t${this.ct}\t${this.start_time}\t\t${this.tat}\t${this.wt}';
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
        return this.priority;
      case 4:
        return this.ct;
      case 5:
        return this.tat;
      case 6:
        return this.wt;
      default:
        return 0;
    }
  }
}

void main(List<String> arguments) {
  List<Process> prs = List<Process>();
  prs.add(Process(0, 8, 3));
  prs.add(Process(1, 2, 4));
  prs.add(Process(3, 4, 4));
  prs.add(Process(4, 1, 5));
  prs.add(Process(5, 6, 2));
  prs.add(Process(6, 5, 6));
  prs.add(Process(10, 1, 1));
  assignPid(prs);
  List<Process> pr = List.from(prs);

  print('\n1.Priority Algo\n');
  pr.sort((a, b) => a.at.compareTo(b.at));
  pr = priorityalgo(pr);
  //sjf.sort((a, b) => a.pid.compareTo(b.pid));
  printprocess(pr);
}

void startprior(List<Process> l) {
  l.sort((a, b) => a.at.compareTo(b.at));
  for (int j = 1; j < l.length; j++) {
    for (var i = 0; i < l.length - 1; i++) {
      if (l[i].at == l[i + 1].at) {
        if (l[i].priority > l[i + 1].priority) {
          Process temp;
          temp = l[i + 1];
          l[i + 1] = l[i];
          l[i] = temp;
        }
      }
    }
  }
}

List<Process> priorityalgo(List<Process> l) {
  List<Process> lgantt = [];
  lgantt = List.from(l); //lgantt is the local copy of the processes list
  for (var item in lgantt) {
    item.ct = item.start_time = item.tat = item.wt = item.ct = null;
  }
  List<Process> rq = [];
  List<Process> fq = [];

  int time = 0;
  startprior(l);
  fillrq(rq, time, lgantt);

  while (time >= 0) {
    if (rq.isEmpty) {
      if (lgantt.isEmpty) {
        break;
      } else {
        if (time >= lgantt[0].at) {
          fillrq(rq, time, lgantt);
          time = processexec(rq, time, fq);
        } else {
          time = lgantt[0].at;
          fillrq(rq, time, lgantt);
          time = processexec(rq, time, fq);
        }
      }
    } else {
      if (lgantt.isNotEmpty) {
        fillrq(rq, time, lgantt);
      }
      time = processexec(rq, time, fq);
      if (lgantt.isNotEmpty) {
        fillrq(rq, time, lgantt);
      }
    }
  }
  fq.sort((a, b) => a.pid.compareTo(b.pid));
  return fq;
}

void priorsort(List<Process> l) {
  l.sort((a, b) => a.priority.compareTo(b.priority));
  for (var i = 0; i < l.length - 1; i++) {
    if (l[i].priority == l[i + 1].priority) {
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
void fillrq(List<Process> rq, int time, List<Process> l) {
  int i = 0;
  int count = 0;
  int limit = l.length;
  l.sort((a, b) => a.at.compareTo(b.at));
  while (l.isNotEmpty && count < l.length) {
    i = 0;
    if (l[i].at <= time) {
      rq.add(l[i]);
      l.removeAt(i);
      count--;
    } else {
      i++;
    }
    count++;
  }
  print("count is $count");
  if (rq.isNotEmpty) {
    priorsort(rq);
  }
}

//will delete the process from the parent list and add
//it to the finished list fq
void fillfq(List<Process> l, List<Process> fq, int i) {
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
    stdout.write(l[i].pid + " with at: " + l[i].at.toString() + " \n ");
  }
  print("\n");
}
