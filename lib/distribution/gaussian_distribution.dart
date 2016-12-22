library distibution.gaussian;

import 'dart:math' show Random,sqrt,log;

class GaussianDistribution {
  num mu, sigma;
  num _y, _aux;
  Random rand;

  GaussianDistribution({this.mu: 0, this.sigma:1, int seed}) {
    rand = new Random(seed);
  }

  /// Generate a value from a standard Gaussian distribution N(0,1)
  /// using the Box-Muller transform.
  /// See https://en.wikipedia.org/wiki/Normal_distribution#Generating_values_from_normal_distribution
  ///
  num sample() {
    if (_y != null) {
      _aux = _y;
      _y = null;
      return _aux;
    } else {
      num s,u,v,r;
      do {
        u = 2*rand.nextDouble()-1;
        v = 2*rand.nextDouble()-1;
        s = u*u + v*v;
      } while (s >= 1 && u != -1 && v != -1);
      r = sqrt(-2*log(s)/s);
      _y = mu + sigma*v*r;
      return mu + sigma*u*r;
    }
  }
}
