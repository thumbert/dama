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
