library test.basic.linear_filter_test;

import 'package:dama/basic/linear_filter.dart';
import 'package:test/test.dart';


void tests() {
  group('Linear filter tests:', () {
    test('Binomial filter, order 2', () {
      var x = <num>[12, 17, 10, 22, 15, 11, 18, 27, 14];
      var y = binomialFilter(x, 2);
      var yExp = [null, 14, 14.75, 17.25, 15.75, 13.75, 18.50, 21.50, null];
      expect(yExp, y);
    });
    test('Binomial filter, order 4', () {
      var x = <num>[12, 17, 10, 22, 15, 11, 18, 27, 14];
      var y = binomialFilter(x, 4);
      expect(y[0], null);
      expect(y[1], null);
      expect(y[2], 15.1875);
    });
    test('Binomial filter, order 4, circular: true', () {
      var x = <num>[12, 17, 10, 22, 15, 11, 18, 27, 14];
      var y = binomialFilter(x, 4, circular: true);
      var y0Exp = (27 + 14*4 + 12*6 + 17*4 + 10)/16;
      var y1Exp = (14 + 12*4 + 17*6 + 10*4 + 22)/16;
      var y8Exp = (18 + 27*4 + 14*6 + 12*4 + 17)/16;
      expect(y[0], y0Exp);
      expect(y[1], y1Exp);
      expect(y[8], y8Exp);
      expect(y[2], 15.1875);
    });
    test('Moving average filter', () {
      var x = <num>[12, 17, 10, 22, 15, 11, 18, 27, 14];
      var weights = <num>[0.25, 0.25, 0.25, 0.25];
      var y = movingAverageFilter(x, weights);
      var yExp = [null, null, null, 15.25, 16.0, 14.5, 16.5, 17.75, 17.5];
      expect(yExp, y);
    });

  });
}

void main() {
  tests();
}
