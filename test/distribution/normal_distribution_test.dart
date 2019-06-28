library test.distribution.normal_distribution;

import 'package:dama/src/utils/matchers.dart';
import 'package:test/test.dart';
import 'package:dama/distribution/gaussian_distribution.dart';

tests() {
  group('Gaussian/Normal distribution:', () {
    var g = GaussianDistribution(mu: 1, sigma: 2);
    test('calculate pdf', () {
      expect(g.density(1),
          equalsWithPrecision(0.19947114020072, precision: 1E-14));
      expect(g.density(5),
          equalsWithPrecision(0.026995483256594, precision: 1E-14));
      expect(g.density(10),
          equalsWithPrecision(7.9918705534527E-6, precision: 1E-14));
    });
    test('calculate cdf', () {
      expect(g.probability(1),
          equalsWithPrecision(0.5, precision: 1E-14));
      expect(g.probability(2),
          equalsWithPrecision(0.69146246127401, precision: 1E-14));
      expect(g.probability(5),
          equalsWithPrecision(0.97724986805182, precision: 1E-14));
    });
    test('calculate quantile', () {
      expect(g.quantile(0.5),
          equalsWithPrecision(1.0, precision: 1E-10));
      expect(g.quantile(0.75),
          equalsWithPrecision(2.3489795003922, precision: 1E-10));
      expect(g.quantile(0.99),
          equalsWithPrecision(5.6526957480817, precision: 1E-10));
    });
  });

//  // https://en.wikipedia.org/wiki/68%E2%80%9395%E2%80%9399.7_rule
//  test('Test normality (Chebyshev bounds)', () {
//    List x = [];
//    num n = 1000;
//    while (n > 0) {
//      x.add(g.sample());
//      n--;
//    }
//    num sampleMean = x.reduce((a,b)=>a+b)/1000;
//    print(sampleMean);
//    x.take(50).forEach(print);
//    //TODO
//  });
}

main() {
  tests();
}
