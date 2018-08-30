library analysis.interpolation.quadratic_interpolator_test;

import 'package:test/test.dart';
import 'package:dama/analysis/interpolation/quadratic_interpolator.dart';

quadraticInterpolatorTest() {
  group('Quadratic interpolation:', () {
    test('simple example', () {
      var qInterpolator = new QuadraticInterpolator([1,2,5], [4,1,6]);
      expect(qInterpolator.valueAt(0), 11-5/3);
      expect(qInterpolator.valueAt(1), 4);
    });
  });
}

main() {
  quadraticInterpolatorTest();
}