library basic.interval;

enum IntervalType { closedOpen, openClosed, openOpen, closedClosed }

const _mapTypes = <String, IntervalType>{
  'gtelte' : IntervalType.closedClosed,
  'gtlte' : IntervalType.openClosed,
  'gtelt' : IntervalType.closedOpen,
  'gtlt' : IntervalType.openOpen,
  'lt': IntervalType.openOpen,
  'lte': IntervalType.openClosed,
  'gt': IntervalType.openOpen,
  'gte': IntervalType.closedOpen,
};

class Interval<K extends num> {
   /// a numerical interval
  Interval(this.start, this.end, {this.intervalType = IntervalType.closedOpen}) {
    assert(start.compareTo(end) < 0);
  }

  K start;
  K end;
  IntervalType intervalType;

  /// Parse a map containing the operators 'lte', 'gte', 'lt', 'gt
  /// For example,
  /// ```
  /// {
  ///   'gte': '1.5',
  /// }
  /// ```
  /// returns the double interval [1.5, \infty), etc.
  static Interval<double> fromJson(Map<String,num> xs) {
    var start = double.negativeInfinity;
    var end = double.infinity;
    var key = (xs.keys.toList()..sort()).join();
    var intervalType = _mapTypes[key];
    if (intervalType == null) {
      throw ArgumentError('Incorrect interval specification $xs');
    }

    if (xs.containsKey('gte') || xs.containsKey('gt')) {
      start = (xs['gte'] ?? xs['gt']!).toDouble();
    }
    if (xs.containsKey('lte') || xs.containsKey('lt')) {
      end = (xs['lte'] ?? xs['lt']!).toDouble();
    }
    return Interval(start, end, intervalType: intervalType);
  }


  /// Check if a value is contained in the interval
  bool contains(K value) {
    var res = false;
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

  /// Starting from the left value, generate an iterable of intervals according
  /// to the function f.
  /// <p>For example to split the interval [0,10) into 10 intervals of length 1
  /// each, use the function f = (x) => new Interval(x, x+1)
  List<Interval> splitLeft(Interval Function(K) f) {
    var res = <Interval>[];
    var current = f(start);
    while (current.end.compareTo(end) < 1) {
      res.add(current);
      current = f(current.end as K);
    }
    return res;
  }

  @override
  String toString() {
    late String res;
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

  /// Because Json doesn't support \infty or -\infty, have to encode an
  /// interval using the mathematical operators.  I use the same names as
  /// MongoDb
  ///
  Map<String,double> toJson() {
    var res = <String,double>{};
    switch (intervalType) {
      case IntervalType.closedOpen:
        res['gte'] = start.toDouble();
        if (end.isFinite) {
          res['lt'] = end.toDouble();
        }
        break;
      case IntervalType.openClosed:
        res['lte'] = end.toDouble();
        if (start.isFinite) {
          res['gt'] = start.toDouble();
        }
        break;
      case IntervalType.openOpen:
        if (start.isFinite) {
          res['gt'] = start.toDouble();
        }
        if (end.isFinite) {
          res['lt'] = end.toDouble();
        }
        break;
      case IntervalType.closedClosed:
        res['gte'] = start.toDouble();
        res['lte'] = end.toDouble();
        break;
    }
    return res;
  }

}
