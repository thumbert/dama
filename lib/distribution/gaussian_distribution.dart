library distibution.gaussian;

import 'dart:math' show Random, sqrt, log, exp, pi;

import 'package:dama/analysis/solver/bisection_solver.dart';
import 'package:dama/special/erf.dart';

class GaussianDistribution {
  num mu, sigma;
  num? _y, _aux;
  late Random rand;
  static final _invSqrt2Pi = 1 / sqrt(2 * pi);
  late num _sigma2;

  GaussianDistribution({this.mu: 0, this.sigma: 1, int? seed}) {
    if (sigma < 0) {
      throw ArgumentError('Argument sigma needs to be > 0');
    }
    rand = Random(seed);
    _sigma2 = 2 * sigma * sigma;
  }

  /// calculate the value of the quantile function (inverse of the distribution
  /// function) at point [probability].
  num quantile(num probability) {
    if (probability < 0 || probability > 1) {
      throw ArgumentError('Probability needs to be between 0 and 1');
    }

    if (probability == 1) return double.infinity;
    if (probability == 0) return double.negativeInfinity;
    // TODO: there should be algorithms to calculate this directly
    // not by using bisection.

    var f = (num x) => this.probability(x) - probability;
    var res = bisectionSolver(f, -1000, 1000);
    return res;
  }

  /// calculate the value of the probability density function at point [x]
  num density(num x) {
    var z = (x - mu) * (x - mu) / _sigma2;
    return _invSqrt2Pi * exp(-z) / sigma;
  }

  /// calculate the value of the distribution function at point [x]
  num probability(num x) {
    var z = (x - mu) / sigma;
    return Phi(z);
  }

  /// Generate a value from a standard Gaussian distribution N(0,1)
  /// using the Box-Muller transform.
  /// See https://en.wikipedia.org/wiki/Normal_distribution#Generating_values_from_normal_distribution
  ///
  num sample() {
    if (_y != null) {
      _aux = _y;
      _y = null;
      return _aux!;
    } else {
      num s, u, v, r;
      do {
        u = 2 * rand.nextDouble() - 1;
        v = 2 * rand.nextDouble() - 1;
        s = u * u + v * v;
      } while (s >= 1 && u != -1 && v != -1);
      r = sqrt(-2 * log(s) / s);
      _y = mu + sigma * v * r;
      return mu + sigma * u * r;
    }
  }
}
