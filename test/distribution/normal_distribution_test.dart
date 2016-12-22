library test.distribution;

import 'package:test/test.dart';
import 'package:dama/distribution/gaussian_distribution.dart';

normalDistributionTests() {
  var g = new GaussianDistribution();

  test('Generate standard normal', () {
    print(g.sample());
  });

  // https://en.wikipedia.org/wiki/68%E2%80%9395%E2%80%9399.7_rule
  test('Test normality (Chebyshev bounds)', () {
    List x = [];
    num n = 1000;
    while (n > 0) {
      x.add(g.sample());
      n--;
    }
    num sampleMean = x.reduce((a,b)=>a+b)/1000;
    print(sampleMean);
    x.take(50).forEach(print);
    //TODO
  });

}

main() {
  normalDistributionTests();
}