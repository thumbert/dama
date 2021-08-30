library distribution.lognormal;

import 'dart:math';

import 'package:dama/analysis/solver/bisection_solver.dart';
import 'package:dama/dama.dart' as dama;
import 'package:dama/distribution/gaussian_distribution.dart';
import 'package:dama/special/erf.dart';

class LogNormalDistribution {
  late num mu, sigma;
  Random? rand;
  GaussianDistribution? _gaussianDistribution;
  static final _invSqrt2Pi = 1 / sqrt(2 * pi);
  late num _sigma2;

  LogNormalDistribution({this.mu = 0, this.sigma = 1}) {
    if (sigma < 0) {
      throw ArgumentError('Argument sigma needs to be > 0');
    }
    _sigma2 = 2 * sigma * sigma;
  }

  /// Get the distribution by estimating the maximum likelihood parameters.
  /// The variance is bias corrected.
  LogNormalDistribution.fromMaximumLikelihood(List<num> xs) {
    mu = dama.mean(xs.map((e) => log(e)));
    sigma = dama.sum(xs.map((e) => (log(e) - mu) * (log(e) - mu))) /
        (xs.length - 1);
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
    var res = bisectionSolver(f, 0, 1000);
    return res;
  }

  /// calculate the value of the probability density function at point [x]
  num density(num x) {
    var aux = log(x) - mu;
    var z = aux * aux / _sigma2;
    return _invSqrt2Pi * exp(-z) / (sigma * x);
  }

  /// calculate the value of the distribution function at point [x]
  num probability(num x) {
    var z = (log(x) - mu) / sigma;
    return Phi(z);
  }

  /// Generate a sample value from this distribution
  num sample() {
    rand ??= Random();
    _gaussianDistribution ??= GaussianDistribution(mu: mu, sigma: sigma)
      ..rand = rand;
    return exp(_gaussianDistribution!.sample());
  }

  /// the mean of this distribution
  num mean() {
    return exp(mu + 0.5 * sigma * sigma);
  }

  /// Var[X] = E[X^2] - E[X]^2
  num variance() {
    var s2 = sigma * sigma;
    return exp(2 * mu + s2) * (exp(s2) - 1);
  }

  num median() => exp(mu);

  num mode() => exp(mu - sigma * sigma);
}
