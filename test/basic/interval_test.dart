
import 'package:test/test.dart';

import 'package:dama/basic/interval.dart';

intervalTest() {
  test('Create interval [0,1)', () {
    Interval i = new Interval(0, 1);
    expect(i.start, 0);
    expect(i.end, 1);
    expect(i.toString(), '[0,1)');
  });

  test('Create interval [0,\infty)', () {
    Interval i = new Interval(0.0, double.INFINITY);
    expect(i.start, 0.0);
    expect(i.end, double.INFINITY);
    expect(i.toString(), '[0.0,Infinity)');
  });


  test('Split interval [0,10) into 10 unit intervals', () {
    Interval ival = new Interval(0, 10);
    List ivals = ival.splitLeft((x) => new Interval(x, x+1));
    expect(ivals.length, 10);
  });

  test('Split interval [new DateTime(2017),new DateTime(2018)) into hours', () {
    Interval year = new Interval(new DateTime(2017), new DateTime(2018));
    List hours = year.splitLeft((x) => new Interval(x, x.add(new Duration(hours: 1))));
    expect(hours.length, 8760);
  });


}

main() {
  intervalTest();
}