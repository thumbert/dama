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
  });
}

void main() {
  tests();
}
