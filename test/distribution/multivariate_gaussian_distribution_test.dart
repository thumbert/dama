library test.distribution.multivariate_gaussian_distribution;

import 'dart:math' show sqrt;

import 'package:dama/src/utils/matchers.dart';
import 'package:dama/linear/matrix.dart';
import 'package:test/test.dart';
import 'package:dama/distribution/multivariate_gaussian_distribution.dart';

void tests() {
  group('Multivariate Gaussian distribution:', () {
    test('calculate pdf for a standard bivariate normal', () {
      var g = MultivariateGaussianDistribution(
          [0, 0], [1, 1], Matrix([1, 0, 0, 1], 2, 2));
      expect(g.density([0, 0]),
          equalsWithPrecision(0.15915494309190, precision: 1E-14));
      expect(g.density([1, 1]),
          equalsWithPrecision(0.058549831524319, precision: 1E-14));
    });

    test('calculate pdf for a correlated bivariate normal', () {
      // mean = [1, 2], sd = [sqrt(2), 1], covariance = [[2, 0.5], [0.5, 1]]
      var rho = 0.5 / sqrt(2);
      var g = MultivariateGaussianDistribution(
          [1, 2], [sqrt(2), 1], Matrix([1, rho, rho, 1], 2, 2));
      expect(g.density([1, 2]),
          equalsWithPrecision(0.12030982838508, precision: 1E-10));
      expect(g.density([0, 0]),
          equalsWithPrecision(0.016282164700644, precision: 1E-10));
    });

    test('reject a non positive definite correlation matrix', () {
      expect(
          () => MultivariateGaussianDistribution(
              [0, 0], [1, 1], Matrix([1, 2, 2, 1], 2, 2)),
          throwsArgumentError);
    });

    test('reject mismatched standardDeviation length', () {
      expect(
          () => MultivariateGaussianDistribution(
              [0, 0], [1], Matrix([1, 0, 0, 1], 2, 2)),
          throwsArgumentError);
    });

    test('sample() returns a vector of the correct dimension', () {
      var g = MultivariateGaussianDistribution(
          [1, 2, 3], [1, 1, 1], Matrix([1, 0, 0, 0, 1, 0, 0, 0, 1], 3, 3));
      var x = g.sample();
      expect(x.length, 3);
    });
  });
}

void main() {
  tests();
}
