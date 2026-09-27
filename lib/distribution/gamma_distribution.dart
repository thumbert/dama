library distribution.gamma;

import 'dart:math' show Random, exp, pow;

import 'package:dama/analysis/solver/bisection_solver.dart';
import 'package:dama/special/erf.dart';

class GammaDistribution {
  GammaDistribution({required this.alpha, required this.beta}) {
    if (alpha <= 0) {
      throw ArgumentError('Argument alpha needs to be > 0');
    }
    if (beta <= 0) {
      throw ArgumentError('Argument beta needs to be > 0');
    }
    if (!_gammaAlpha.containsKey(alpha)) {
      _gammaAlpha[alpha] = gamma(alpha);
    }
  }

  /// The shape parameter of the gamma distribution.
  int alpha;

  /// The rate parameter of the gamma distribution.
  num beta;

  static final Map<int, num> _gammaAlpha = {};
  Random? rand;

  /// Calculate the value of the quantile function (inverse of the distribution
  /// function) at point [probability].
  num quantile(num probability) {
    if (probability < 0 || probability > 1) {
      throw ArgumentError('Probability needs to be between 0 and 1');
    }
    if (probability == 1) return double.infinity;
    if (probability == 0) return double.negativeInfinity;
    f(num x) => this.probability(x) - probability;
    var res = bisectionSolver(f, -1000, 1000);
    return res;
  }

  /// Calculate the value of the probability density function at point [x]
  num density(num x) {
    if (x < 0) {
      throw ArgumentError('x needs to be >= 0');
    }
    var c = pow(beta, alpha) / _gammaAlpha[alpha]!;
    var z = pow(beta * x, alpha - 1) * exp(-beta * x);
    return c * z;
  }

  /// Calculate the value of the distribution function at point [x]
  num probability(num x) {
    if (x < 0) {
      throw ArgumentError('x needs to be >= 0');
    }
    var sum = 0.0;
    for (var k = 0; k < alpha; k++) {
      sum += pow(beta * x, k) / gamma(k + 1);
    }
    return 1 - exp(-beta * x) * sum;
  }

  num get mean => alpha / beta;

  num get variance => alpha / (beta * beta);

  num sample() {
    rand ??= Random();
    return 0;
  }
}
