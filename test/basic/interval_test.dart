


import 'package:test/test.dart';

import 'package:dama/basic/interval.dart';

tests() {
  test('Create interval [0,1)', () {
    var i = Interval(0, 1);
    expect(i.start, 0);
    expect(i.end, 1);
    expect(i.toString(), '[0,1)');
  });

  test('Create interval [0, \\infty)', () {
    var i = Interval(0.0, double.infinity);
    expect(i.start, 0.0);
    expect(i.end, double.infinity);
    expect(i.toString(), '[0.0,Infinity)');
  });

  test('Split interval [0,10) into 10 unit intervals', () {
    var ival = Interval(0, 10);
    var ivals = ival.splitLeft((x) => Interval(x, x+1));
    expect(ivals.length, 10);
  });

  test('Interval (1.5, infinity) fromJson, toJson', () {
    var i = Interval.fromJson({'gt': 1.5});
    expect(i.start == 1.5 && i.end == double.infinity
        && i.intervalType == IntervalType.openOpen, true);
    expect(i.toJson(), {
      'gt': 1.5,
    });
  });

  test('Interval (1.5, 2] fromJson, toJson', () {
    var i = Interval.fromJson({'gt': 1.5, 'lte': 2});
    expect(i.start == 1.5 && i.end == 2.0
        && i.intervalType == IntervalType.openClosed, true);
    expect(i.toJson(), {
      'gt': 1.5,
      'lte': 2.0,
    });
  });

  test('Interval (-infty, 2] fromJson, toJson', () {
    var i = Interval.fromJson({'lte': 2});
    expect(i.start == double.negativeInfinity && i.end == 2.0
        && i.intervalType == IntervalType.openClosed, true);
    expect(i.toJson(), {
      'lte': 2.0,
    });
  });

  test('Interval [-1.5, 2] fromJson, toJson', () {
    var i = Interval.fromJson({'lte': 2, 'gte': 1.5});
    expect(i.start == 1.5 && i.end == 2.0
        && i.intervalType == IntervalType.closedClosed, true);
    expect(i.toJson(), {
      'lte': 2.0,
      'gte': 1.5,
    });
  });

}

main() {
  tests();
}