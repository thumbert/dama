

library test.stat.estimate.kernel_density_estimator_test;

import 'package:dama/dama.dart';
import 'package:dama/stat/estimate/kernel_density_estimator.dart';
import 'package:test/test.dart';

import '../../_data/faithful.dart';

void tests() {
  group('Kernel density estimator:', () {
    test('old faithful', () {
      var data = faithfulWaiting();
      var est = KernelDensityEstimator(data);
      var xs = List.generate(100, (i) => 30 + i);
      var ys = xs.map((x) => est.valueAt(x)).toList();
      var maxY = max(ys);
      var ind = ys.indexWhere((e) => e == maxY);
      expect(xs[ind], 80);
    });
  });
}

void main() {
  tests();
}