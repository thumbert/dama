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

  SplineInterpolator _splineInterpolator;

  /// A 1-st order Loess interpolator.
  LoessInterpolator(List<num> x, List<num> y,
      {List<num> weights, this.bandwidth: 0.3, this.robustnessIters: 2,
        this.accuracy: 1e-12}) {
    if (bandwidth < 0 || bandwidth > 1)
      throw new RangeError('Bandwidth needs to be between (0,1)');

    var yVal = _smooth(x.cast<double>(), y.cast<double>(), weights: weights);
    _splineInterpolator = new SplineInterpolator(x, yVal);
  }

  /// Calculate the value of the loess interpolator at this abscissa.
  num valueAt(num x) => _splineInterpolator.valueAt(x);


  /// Compute the loess interpolation given the input data [x] and [y].
  /// If the weights are not specified, they are set to 1.
  /// Return the calculated values at the input abscissae [x].
  List<double> _smooth(List<double> x, List<double> y, {List<double> weights}) {
    if (x.length != y.length)
      throw new ArgumentError('Dimensions of x and y inputs don\'t match');
    weights ??= new List.filled(x.length, 1.0);
    if (weights.length != x.length)
      throw new ArgumentError(
          'Length of weights does not equal length of data');

    int n = x.length;
    if (n == 1) return [y[0]];
    if (n == 2) return [y[0], y[1]];

    int bandwithInPoints = (bandwidth * n).floor();
    List<double> res = new List(n);
    List<double> residuals = new List(n);
    List<double> sortedResiduals = new List(n);
    List<double> robustnessWeights = new List.filled(n, 1.0);

    /// Do an initial fit
    for (int iter = 0; iter <= robustnessIters; ++iter) {
      var bandwidthInterval = [0, bandwithInPoints - 1];

      /// At each x, compute a local weighted linerar regression
      for (int i = 0; i < n; ++i) {
        double _x = x[i].toDouble();

        /// Find out the interval of source points on which you do a regression
        if (i > 0) _updateBadwidthInteval(x, weights, i, bandwidthInterval);

        int ileft = bandwidthInterval[0];
        int iright = bandwidthInterval[1];

        /// Compute the point of the bandwidth interval that is farthest
        int edge;
        if (x[i] - x[ileft] > x[iright] - x[i]) {
          edge = ileft;
        } else {
          edge = iright;
        }

        /// Compute a least-squares linear fit weighted
        double sumWeights = 0.0;
        double sumX = 0.0;
        double sumXSquared = 0.0;
        double sumY = 0.0;
        double sumXY = 0.0;
        double denom = (1.0 / (x[edge] - _x)).abs();
        for (int k = ileft; k <= iright; ++k) {
          double xk = x[k].toDouble();
          double yk = y[k].toDouble();
          double dist = (k < i) ? _x - xk : xk - _x;
          double w = _tricube(dist * denom) * robustnessWeights[k] * weights[k];
          double xkw = xk * w;
          sumWeights += w;
          sumX += xkw;
          sumXSquared += xk * xkw;
          sumY += yk * w;
          sumXY += yk * xkw;
        }

        double meanX = sumX / sumWeights;
        double meanY = sumY / sumWeights;
        double meanXY = sumXY / sumWeights;
        double meanXSquared = sumXSquared / sumWeights;

        double beta;
        if ((meanXSquared - meanX * meanX).abs() < accuracy) {
          beta = 0.0;
        } else {
          beta = (meanXY - meanX * meanY) / (meanXSquared - meanX * meanX);
        }

        final double alpha = meanY - beta * meanX;

        res[i] = beta * _x + alpha;
        residuals[i] = (y[i] - res[i]).abs();
      }

      // No need to recompute the robustness weights at the last
      // iteration, they won't be needed anymore
      if (iter == robustnessIters) {
        break;
      }

      // Recompute the robustness weights.
      // Find the median residual.
      sortedResiduals = new List.from(residuals);
      sortedResiduals.sort();
      final double medianResidual = sortedResiduals[n ~/ 2];

      if (medianResidual.abs() < accuracy) {
        break;
      }

      for (int i = 0; i < n; ++i) {
        final double arg = residuals[i] / (6 * medianResidual);
        if (arg >= 1) {
          robustnessWeights[i] = 0.0;
        } else {
          final double w = 1 - arg * arg;
          robustnessWeights[i] = w * w;
        }
      }
    }

    return res;
  }

  /// Return a two element list [left,right].  Modify the [bandwidthInterval].
  void _updateBadwidthInteval(List<double> x, List<double> weights, int i,
      List<int> bandwidthInterval) {
    int left = bandwidthInterval[0];
    int right = bandwidthInterval[1];

    int nextRight = _nextNonzero(weights, right);
    if (nextRight < x.length && x[nextRight] - x[i] < x[i] - x[left]) {
      int nextLeft = _nextNonzero(weights, bandwidthInterval[0]);
      bandwidthInterval[0] = nextLeft;
      bandwidthInterval[1] = nextRight;
    }
  }

  /// Return the smallest index
  int _nextNonzero(List<double> weights, int i) {
    int j = i + 1;
    while (j < weights.length && weights[j] == 0) {
      ++j;
    }
    return j;
  }

  /// Compute the
  /// <a href="http://en.wikipedia.org/wiki/Local_regression#Weight_function">tricube</a>
  /// weight function (1 - |x|^3)^3 for |x| < 1, 0 otherwise
  double _tricube(double x) {
    double absX = x.abs();
    if (absX >= 1.0) return 0.0;
    var tmp = 1 - absX * absX * absX;
    return tmp * tmp * tmp;
  }
}
