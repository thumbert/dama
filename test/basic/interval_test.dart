


import 'package:test/test.dart';

import 'package:dama/basic/interval.dart';

tests() {
  test('Create interval [0,1)', () {
    var i = Interval(0, 1);
    expect(i.start, 0);
    expect(i.end, 1);
    expect(i.toString(), '[0,1)');
  });

  test('Create interval [0,\infty)', () {
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

  test('Split interval [DateTime(2017), DateTime(2018)) into hours', () {
    var year = Interval(DateTime(2017), DateTime(2018));
    var hours = year.splitLeft((x) => Interval(x, x.add(Duration(hours: 1))));
    expect(hours.length, 8760);
  });
}

main() {
  tests();
}