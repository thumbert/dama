

library test.basic.num_extensions_test;

import 'package:test/test.dart';
import 'package:dama/dama.dart';

void tests() {
  group('Numeric iterable extensions tests', () {
    test('indexOfMax', () {
      expect([1, 3, 1, 2].indexOfMax(), 1);
      expect([1, 3, 3, 3].indexOfMax(), 1);
      expect([1, 3, 3, double.nan].indexOfMax(), 1);
      expect([1, 3, 3, double.infinity, -1].indexOfMax(), 3);
    });
    test('indexOfMin', () {
      expect([3, 1, 2].indexOfMin(), 1);
      expect([3, 1, 1, 1].indexOfMin(), 1);
      expect([3, 1, 1, double.nan].indexOfMin(), 1);
      expect([3, 1, 1, double.negativeInfinity, -1].indexOfMin(), 3);
    });
    test('sum of an Iterable<num>', () {
      expect(<num>[1, 2, 3].sum(), 6);
    });
    test('sum of an empty Iterable<num> is zero!', () {
      // Same as R, python, Fortran, etc.
      expect(<num>[].sum(), 0);
    });
    test('mean', () {
      /// See https://www.nu42.com/2015/03/how-you-average-numbers.html
      var x = List.generate(50000, (i) => [1000000000.1, 1.1]).expand((e) => e);
      // naive mean is 500000000.60091573
      expect(x.mean(), 500000000.6);
    });

    test('max', () {
      expect(<num>[1, 2, 3, 4, 5].max(), 5);
    });
    test('min', () {
      expect(<num>[1, 3, -3, 5].min(), -3);
      expect([1, 3, double.nan, -3, 5].min(), -3);
      expect([1, 3, double.negativeInfinity, 5].min(), double.negativeInfinity);
    });
    test('variance', () {
      var xs = [4, 7, 13, 16].map((e) => e + 1000000000).toList();
      expect(xs.variance(), 30.0);
    });
    test('median absolute deviation', () {
      var xs = [1, 1, 2, 2, 4, 6, 9];
      expect(xs.mad(), 1.0);
    });
    test('range test', () {
      expect([4, 2, 1, 5].range(), [1, 5]);
      expect([4, 2, double.nan, 5].range(), [2, 5]);
    });
    test('summary of an iterable', () {
      var res = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].summary();
      expect(res, {
        'Min.': 1,
        '1st Qu.': 3.25,
        'Median': 5.5,
        'Mean': 5.5,
        '3rd Qu.': 7.75,
        'Max.': 10
      });
    });
  });


}

void main() {
  tests();
}
