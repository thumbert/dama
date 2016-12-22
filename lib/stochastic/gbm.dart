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
  GaussianDistribution rand;

  num _current;
  num _sigma2;

  GeometricBrownianMotion(this.x0, this.mu, this.sigma, [int seed]) {
    _current = x0;
    _sigma2 = 0.5*sigma*sigma;
    rand = new GaussianDistribution(mu: 0, sigma:1, seed:seed);
  }

  num next() {
    _current *= exp(mu + sigma*rand.sample());
    return _current;
  }


}