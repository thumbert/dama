library stochastic.gbm;

import 'dart:math';
import 'package:dama/distribution/gaussian_distribution.dart';

/// Simulate a Geometric Brownian Variable
class GeometricBrownianMotion {
  /// initial value
  num x0;

  /// drift
  num mu;

  /// standard deviation
  num sigma;
  late GaussianDistribution rand;

  late num _current;

  GeometricBrownianMotion(this.x0, this.mu, this.sigma) {
    _current = x0;
    rand = GaussianDistribution(mu: mu, sigma: sigma);
  }

  num? next() {
    _current *= exp(mu + sigma * rand.sample());
    return _current;
  }
}
