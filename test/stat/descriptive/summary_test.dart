

library test.stat.descriptive.summary;

import 'package:dama/src/utils/matchers.dart';
import 'package:test/test.dart';
import 'package:dama/stat/descriptive/summary.dart';
import 'package:dama/stat/descriptive/summary_ext.dart';
import '../../_data/cars.dart';

void main() {
  group('Stat descriptive summary:', () {
    test('sum of an Iterable<num>', () {
      expect(sum([1, 2, 3]), 6);
    });
    test('sum of an empty Iterable<num> is zero!', () {
      // Same as R, python, Fortran, etc.
      expect(sum([]), 0);
    });
    test('extension of sum', () {
      expect(<num>[1, 2, 3].sum(), 6);
    });
    test('max', () {
      expect(max([1, 2, 3, 4, 5]), 5);
    });
    test('min', () {
      expect(min([1, 3, -3, 5]), -3);
      expect(min([1, 3, double.nan, -3, 5]), -3);
      expect(min([1, 3, double.negativeInfinity, 5]), double.negativeInfinity);
    });
    test('covariance', () {
      var x = List.generate(10, (i) => i + 1);
      var y = List.generate(10, (i) => i + 1);
      expect(covariance(x, y), equalsWithPrecision(9.166667, precision: 1E-6));
    });
    test('correlation', () {
      var _cars = cars();
      var speed = _cars['speed']!;
      var distance = _cars['dist']!;
      expect(correlation(speed, distance),
          equalsWithPrecision(0.8068949, precision: 1E-6));
    });
    test('Manhattan distance', () {
      var x = [1, 2, 4];
      var y = [2, 1, 5];
      expect(manhattanDistance(x, y), 3.0);
    });
    test('range test', () {
      List r = range([4, 2, 1, 5]);
      expect(r, [1, 5]);
    });
    test('range([4,2,NAN,5]) is [2,5]', () {
      List r = range([4, 2, double.nan, 5]);
      expect(r, [2, 5]);
    });
    test('summary of an iterable', () {
      var res = summary([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
      expect(res, {
        'Min.': 1,
        '1st Qu.': 3.25,
        'Median': 5.5,
        'Mean': 5.5,
        '3rd Qu.': 7.75,
        'Max.': 10
      });
    });
    test('ohlc', () {
      var res = ohlc([3, 6, 1, 2, 3, 6, 9, 10, 5, 7, 7]);
      expect(res, {'open': 3, 'high': 10, 'low': 1, 'close': 7});
    });
  });
}
