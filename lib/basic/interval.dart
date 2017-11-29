library basic.interval;

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
  List<Interval> split(K value) {
    if (start.compareTo(value) >= 0 || value.compareTo(end) >= 0)
      throw 'Split value needs to be inside the interval.';
    Interval left = new Interval(start, value, intervalType: intervalType);
    Interval right = new Interval(value, end, intervalType: intervalType);
    return [left, right];
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