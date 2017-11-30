library basic.interval;

import 'package:func/func.dart';

enum IntervalType {
  closedOpen,
  openClosed,
  openOpen,
  closedClosed
}

class Interval<K extends Comparable<K>> {
  K start;
  K end;
  IntervalType intervalType;

  /// a numerical interval
  Interval(this.start, this.end, {this.intervalType: IntervalType.closedOpen}) {
     assert(start.compareTo(end) < 0);
  }

  /// Check if a value is contained in the interval
  bool contains(K value) {
    bool res;
    switch (intervalType) {
      case IntervalType.closedOpen:
        res = value.compareTo(start) >= 0 && value.compareTo(end) < 0;
        break;
      case IntervalType.openClosed:
        res = value.compareTo(start) > 0 && value.compareTo(end) <= 0;
        break;
      case IntervalType.openOpen:
        res = value.compareTo(start) > 0 && value.compareTo(end) < 0;
        break;
      case IntervalType.closedClosed:
        res = value.compareTo(start) > 0 && value.compareTo(end) < 0;
        break;
    }
    return res;
  }


  /// Split this interval into two intervals: a left interval [start,value)
  /// and a right interval [value, end).  The [intervalType] is kept the
  /// same.
//  List<Interval> split(K value) {
//    if (start.compareTo(value) >= 0 || value.compareTo(end) >= 0)
//      throw 'Split value needs to be inside the interval.';
//    Interval left = new Interval(start, value, intervalType: intervalType);
//    Interval right = new Interval(value, end, intervalType: intervalType);
//    return [left, right];
//  }

  /// Starting from the left value, generate an iterable of intervals according
  /// to the function f.
  /// <p>For example to split the interval [0,10) into 10 intervals of length 1
  /// each, use the function f = (x) => new Interval(x, x+1)
  List<Interval> splitLeft(Func1<K,Interval> f) {
    List res = [];
    Interval current = f(start);
    while (current.end.compareTo(end) < 1) {
      res.add(current);
      current = f(current.end);
    }
    return res;
  }


  String toString() {
    String res;
    switch (intervalType) {
      case IntervalType.closedOpen:
        res = '[$start,$end)';
        break;
      case IntervalType.openClosed:
        res = '($start,$end]';
        break;
      case IntervalType.openOpen:
        res = '($start,$end)';
        break;
      case IntervalType.closedClosed:
        res = '[$start,$end]';
        break;
    }
    return res;
  }

}