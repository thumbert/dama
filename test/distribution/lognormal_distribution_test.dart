library test.distribution.lognormal_distribution;

import 'package:dama/distribution/lognormal_distribution.dart';
import 'package:dama/src/utils/matchers.dart';
import 'package:test/test.dart';

void tests() {
  group('LogNormal distribution:', () {
    var g = LogNormalDistribution(mu: 1, sigma: 2);
    test('calculate pdf', () {
      expect(g.density(1),
          equalsWithPrecision(0.1760326633821498, precision: 1E-14));
      expect(g.density(5),
          equalsWithPrecision(0.03808440312968901, precision: 1E-14));
      expect(g.density(10),
          equalsWithPrecision(0.01613504285717044, precision: 1E-14));
    });
    test('calculate cdf', () {
      expect(g.probability(1),
          equalsWithPrecision(0.3085375387259869, precision: 1E-14));
      expect(g.probability(2),
          equalsWithPrecision(0.4390310097476894, precision: 1E-14));
      expect(g.probability(5),
          equalsWithPrecision(0.6197098945773291, precision: 1E-14));
    });
    test('calculate quantile', () {
      expect(g.quantile(0.5),
          equalsWithPrecision(2.718281828459045, precision: 1E-10));
      expect(g.quantile(0.75),
          equalsWithPrecision(10.47487466301686, precision: 1E-10));
      expect(g.quantile(0.99),
          equalsWithPrecision(285.0588779076448, precision: 1E-10));
    });
  });
}

void main() {
  tests();
}
