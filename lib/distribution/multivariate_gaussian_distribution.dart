library distribution.multivariate_gaussian;

import 'dart:math' show Random, sqrt, log, exp, pi;
import 'dart:typed_data';

import 'package:dama/linear/matrix.dart';

/// Multivariate Gaussian (Normal) distribution N(mu, Sigma), where the
/// covariance matrix Sigma is parameterized as Sigma = D * R * D, with D the
/// diagonal matrix of standard deviations and R the correlation matrix.
class MultivariateGaussianDistribution {
  /// the mean vector
  final List<num> mean;

  /// the standard deviation of each dimension
  final List<num> standardDeviation;

  /// the correlation matrix, needs to be symmetric with unit diagonal
  final Matrix correlation;

  /// the number of dimensions
  final int dimension;

  Random? rand;
  num? _spare;

  /// lower triangular Cholesky factor L such that covariance = L * L'
  late List<Float64List> _l;
  late num _logDetCovariance;

  MultivariateGaussianDistribution(
      this.mean, this.standardDeviation, this.correlation)
      : dimension = mean.length {
    if (standardDeviation.length != dimension) {
      throw ArgumentError(
          'Argument standardDeviation needs to have length $dimension');
    }
    if (!correlation.isSquare() || correlation.nrow != dimension) {
      throw ArgumentError(
          'Argument correlation needs to be a ${dimension}x$dimension square matrix');
    }
    for (var sd in standardDeviation) {
      if (sd <= 0) {
        throw ArgumentError('Standard deviations need to be positive');
      }
    }
    for (var i = 0; i < dimension; i++) {
      if ((correlation.element(i, i) - 1).abs() > 1E-10) {
        throw ArgumentError('Argument correlation needs a unit diagonal');
      }
      for (var j = i + 1; j < dimension; j++) {
        if (correlation.element(i, j).abs() > 1) {
          throw ArgumentError(
              'Argument correlation entries need to be between -1 and 1');
        }
      }
    }
    _l = _cholesky(_covariance(standardDeviation, correlation));
    var logDet = 0.0;
    for (var i = 0; i < dimension; i++) {
      logDet += log(_l[i][i]);
    }
    _logDetCovariance = 2 * logDet;
  }

  /// Build the covariance matrix Sigma = D * R * D, where D = diag(sd).
  static Matrix _covariance(List<num> sd, Matrix correlation) {
    var n = sd.length;
    var data = List<num>.filled(n * n, 0.0);
    for (var i = 0; i < n; i++) {
      for (var j = 0; j < n; j++) {
        data[i * n + j] = sd[i] * sd[j] * correlation.element(i, j);
      }
    }
    return Matrix(data, n, n, byRow: true);
  }

  /// Compute the lower triangular Cholesky factor L of a symmetric positive
  /// definite matrix [sigma], such that sigma = L * L'.
  static List<Float64List> _cholesky(Matrix sigma) {
    var n = sigma.nrow;
    var l = List.generate(n, (_) => Float64List(n));
    for (var i = 0; i < n; i++) {
      for (var j = 0; j <= i; j++) {
        num sum = sigma.element(i, j);
        for (var k = 0; k < j; k++) {
          sum -= l[i][k] * l[j][k];
        }
        if (i == j) {
          if (sum <= 0) {
            throw ArgumentError(
                'Argument covariance needs to be a symmetric positive definite matrix');
          }
          l[i][j] = sqrt(sum);
        } else {
          l[i][j] = sum / l[j][j];
        }
      }
    }
    return l;
  }

  /// calculate the value of the probability density function at point [x]
  num density(List<num> x) {
    if (x.length != dimension) {
      throw ArgumentError('Argument x needs to have length $dimension');
    }

    // solve L*y = (x - mean) by forward substitution
    var y = List<num>.filled(dimension, 0);
    for (var i = 0; i < dimension; i++) {
      num sum = x[i] - mean[i];
      for (var k = 0; k < i; k++) {
        sum -= _l[i][k] * y[k];
      }
      y[i] = sum / _l[i][i];
    }

    num quadraticForm = y.fold(0, (num prev, num e) => prev + e * e);
    var logDensity =
        -0.5 * (dimension * log(2 * pi) + _logDetCovariance + quadraticForm);
    return exp(logDensity);
  }

  /// Generate a random sample vector from this distribution.
  List<num> sample() {
    rand ??= Random();
    var z = List<num>.generate(dimension, (_) => _nextStandardNormal());
    var res = List<num>.filled(dimension, 0);
    for (var i = 0; i < dimension; i++) {
      num sum = mean[i];
      for (var k = 0; k <= i; k++) {
        sum += _l[i][k] * z[k];
      }
      res[i] = sum;
    }
    return res;
  }

  /// Generate a value from a standard Gaussian distribution N(0,1)
  /// using the Box-Muller transform.
  num _nextStandardNormal() {
    if (_spare != null) {
      var aux = _spare!;
      _spare = null;
      return aux;
    } else {
      num s, u, v, r;
      do {
        u = 2 * rand!.nextDouble() - 1;
        v = 2 * rand!.nextDouble() - 1;
        s = u * u + v * v;
      } while (s >= 1 && u != -1 && v != -1);
      r = sqrt(-2 * log(s) / s);
      _spare = v * r;
      return u * r;
    }
  }
}
