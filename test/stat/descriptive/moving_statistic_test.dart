library test.stat.descriptive.moving_statistic_test;

import 'package:dama/stat/descriptive/moving_statistic.dart';
import 'package:test/test.dart';

void tests() {
  group('Moving statistics test:', () {
    test('moving max', () {
      var xs = [4, 8, 6, -1, -2, -3, -1, 3, 4, 5];
      var ms = MovingStatistics(leftWindow: 2, rightWindow: 0);
      var out = ms.movingMax(xs);
      expect(out, [4, 8, 8, 8, 6, -1, -1, 3, 4, 5]);
    });
    test('moving minmax', () {
      var xs = [4, 8, 6, -1, -2, -3, -1, 3, 4, 5];
      var ms = MovingStatistics(leftWindow: 2, rightWindow: 0);
      var out = ms.movingMinMax(xs);
      expect(
          out.map((e) => e.item2).toList(), [4, 8, 8, 8, 6, -1, -1, 3, 4, 5]);
    });
    test('moving mean', () {
      var xs = [4, 8, 6, -1, -2, -3, -1, 3, 4, 5];
      var ms = MovingStatistics(leftWindow: 3, rightWindow: 0);
      var out = ms.movingMean(xs);
      expect(out, [4, 6, 6, 4.25, 2.75, 0, -1.75, -0.75, 0.75, 2.75]);
    });

    test('moving variance', () {
      var xs = [4, 8, 6, -1, -2, -3, -1, 3, 4, 5];
      var ms = MovingStatistics(leftWindow: 3, rightWindow: 0);
      var out = ms.movingVariance(xs);
      expect(out.first.isNaN, true);  // no variance for one number
      expect(out.skip(1), [
        8,
        4,
        14.916666666666666,
        24.916666666666668,
        16.666666666666668,
        0.9166666666666666,
        6.916666666666667,
        10.916666666666666,
        6.916666666666667,
      ]);
    });


    test('moving correlation', () {
      var xy = [[9, 19], [12, 36], [20, 29], [12, 26], [14, 33], [15, 18]];
      var mw = MovingStatistics(leftWindow: 3, rightWindow: 0);
      var out = mw.movingCorrelation(xy);
      expect(out.length, 6);
      expect(out[2], 0.36020636179256577);
    });
  });
}

void main() {
  tests();
}
