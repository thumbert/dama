library analysis.interpolation.loess_interpolation;

import 'spline_interpolator.dart';

class LoessInterpolator {
  /// The bandwidth parameter: when computing the loess fit at
  /// a particular point, this fraction of source points closest
  /// to the current point is taken into account for computing
  /// a least-squares regression.
  /// <p>A sensible value is usually 0.25 to 0.5.</p>
  double bandwidth;

  ///The number of robustness iterations parameter: this many
  /// robustness iterations are done.
  /// <p>
  /// A sensible value is usually 0 (just the initial fit without any
  /// robustness iterations) to 4.</p>
  int robustnessIters;

  /// If the median residual at a certain robustness iteration
  /// is less than this amount, no more iterations are done.
  double accuracy;

  /// The range of [x] values which represents the domain of the
  /// LoessInterpolator.
  late List<double> _domain;

  late SplineInterpolator _splineInterpolator;

  /// A 1-st order Loess interpolator.  If the [weights] are not specified
  /// they are set equal to 1.
  LoessInterpolator(List<double> x, List<double> y,
      {List<num>? weights,
      this.bandwidth = 0.3,
      this.robustnessIters = 2,
      this.accuracy = 1e-12}) {
    if (bandwidth < 0 || bandwidth > 1) {
      throw RangeError('Bandwidth needs to be between (0,1)');
    }

    // sort the inputs by x values so the spline interpolation works
    var ind = Map.fromIterables(x, List.generate(x.length, (i) => i));
    var xs = List<double>.from(x)..sort();
    var ys = [for (var i = 0; i < x.length; i++) y[ind[xs[i]]!]];

    var yVal = _smooth(xs, ys, weights: weights as List<double>?);

    // to construct the spline interpolator, keep only the unique xs values
    var xu = <double>[xs.first];
    var yu = <double>[yVal.first];
    _domain = [xs.first, xs.first];

    for (var i = 1; i < xs.length; ++i) {
      if (xs[i] == xs[i - 1]) continue;
      // calculate the range too
      if (xs[i] > _domain[1]) _domain[1] = xs[i];
      if (xs[i] < _domain[0]) _domain[0] = xs[i];
      xu.add(xs[i]);
      yu.add(yVal[i]);
    }
    _splineInterpolator = SplineInterpolator(xu, yu);
  }

  /// Calculate the value of the loess interpolator at this abscissa by
  /// spline interpolation.  Values that are extrapolated will return NaN.
  num valueAt(num x) {
    if (x < _domain[0] || x > _domain[1]) return double.nan;
    return _splineInterpolator.valueAt(x)!;
  }

  /// Get the domain of the interpolator (the range of x values.)
  List<double> get domain => _domain;

  /// Compute the loess interpolation given the input data [x] and [y].
  /// If the weights are not specified, they are set to 1.
  /// Return the calculated values at the input abscissae [x].
  List<double> _smooth(List<double> x, List<double> y,
      {List<double>? weights}) {
    if (x.length != y.length) {
      throw ArgumentError('Dimensions of x and y inputs don\'t match');
    }
    weights ??= List.filled(x.length, 1.0);
    if (weights.length != x.length) {
      throw ArgumentError('Length of weights does not equal length of data');
    }

    var n = x.length;
    if (n == 1) return [y[0]];
    if (n == 2) return [y[0], y[1]];

    var bandwidthInPoints = (bandwidth * n).floor();
    var res = List<double>.filled(n, 0.0);
    var residuals = List<double>.filled(n, 0.0);
    var sortedResiduals = List<double>.filled(n, 0.0);
    var robustnessWeights = List.filled(n, 1.0);

    /// Do an initial fit
    for (var iter = 0; iter <= robustnessIters; ++iter) {
      var bandwidthInterval = [0, bandwidthInPoints - 1];

      /// At each x, compute a local weighted linear regression
      for (var i = 0; i < n; ++i) {
        var xi = x[i].toDouble();

        /// Find out the interval of source points on which you do a regression
        if (i > 0) _updateBandwidthInterval(x, weights, i, bandwidthInterval);

        var iLeft = bandwidthInterval[0];
        var iRight = bandwidthInterval[1];

        /// Compute the point of the bandwidth interval that is farthest
        int edge;
        if (x[i] - x[iLeft] > x[iRight] - x[i]) {
          edge = iLeft;
        } else {
          edge = iRight;
        }

        /// Compute a least-squares linear fit weighted
        var sumWeights = 0.0;
        var sumX = 0.0;
        var sumXSquared = 0.0;
        var sumY = 0.0;
        var sumXY = 0.0;
        var denom = (1.0 / (x[edge] - xi)).abs();
        for (var k = iLeft; k <= iRight; ++k) {
          var xk = x[k];
          var yk = y[k];
          var dist = (k < i) ? xi - xk : xk - xi;
          var w = _tricube(dist * denom) * robustnessWeights[k] * weights[k];
          var xkw = xk * w;
          sumWeights += w;
          sumX += xkw;
          sumXSquared += xk * xkw;
          sumY += yk * w;
          sumXY += yk * xkw;
        }

        var meanX = sumX / sumWeights;
        var meanY = sumY / sumWeights;
        var meanXY = sumXY / sumWeights;
        var meanXSquared = sumXSquared / sumWeights;

        double beta;
        if ((meanXSquared - meanX * meanX).abs() < accuracy) {
          beta = 0.0;
        } else {
          beta = (meanXY - meanX * meanY) / (meanXSquared - meanX * meanX);
        }

        final alpha = meanY - beta * meanX;

        res[i] = beta * xi + alpha;
        residuals[i] = (y[i] - res[i]).abs();
      }

      // No need to recompute the robustness weights at the last
      // iteration, they won't be needed anymore
      if (iter == robustnessIters) {
        break;
      }

      // Recompute the robustness weights.
      // Find the median residual.
      sortedResiduals = List.from(residuals);
      sortedResiduals.sort();
      final medianResidual = sortedResiduals[n ~/ 2];

      if (medianResidual.abs() < accuracy) {
        break;
      }

      for (var i = 0; i < n; ++i) {
        final arg = residuals[i] / (6 * medianResidual);
        if (arg >= 1) {
          robustnessWeights[i] = 0.0;
        } else {
          final w = 1 - arg * arg;
          robustnessWeights[i] = w * w;
        }
      }
    }

    return res;
  }

  /// Return a two element list [left,right].  Modify the [bandwidthInterval].
  void _updateBandwidthInterval(List<double> x, List<double> weights, int i,
      List<int> bandwidthInterval) {
    var left = bandwidthInterval[0];
    var right = bandwidthInterval[1];

    var nextRight = _nextNonzero(weights, right);
    if (nextRight < x.length && x[nextRight] - x[i] < x[i] - x[left]) {
      var nextLeft = _nextNonzero(weights, bandwidthInterval[0]);
      bandwidthInterval[0] = nextLeft;
      bandwidthInterval[1] = nextRight;
    }
  }

  /// Return the smallest index
  int _nextNonzero(List<double> weights, int i) {
    var j = i + 1;
    while (j < weights.length && weights[j] == 0) {
      ++j;
    }
    return j;
  }

  /// Compute the
  /// <a href="http://en.wikipedia.org/wiki/Local_regression#Weight_function">tricube</a>
  /// weight function (1 - |x|^3)^3 for |x| < 1, 0 otherwise
  double _tricube(double x) {
    var absX = x.abs();
    if (absX >= 1.0) return 0.0;
    var tmp = 1 - absX * absX * absX;
    return tmp * tmp * tmp;
  }
}
