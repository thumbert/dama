

library stat.descriptive.autocorrelation;

import 'dart:math';

import 'package:dama/distribution/gaussian_distribution.dart';
import 'package:dama/special/erf.dart';
import 'package:dama/stat/descriptive/ecdf.dart';

enum InputType { whiteNoise, autoregressive }

class Autocorrelation {
  List<num> data;
  int maxLag;

  late List<num> _autocorrelation;

  /// Calculate the autocorrelation of this time series.
  /// See https://www.itl.nist.gov/div898/handbook/eda/section3/eda35c.htm
  ///
  Autocorrelation(this.data, this.maxLag) {
    if (maxLag > data.length) {
      throw ArgumentError('Max lag can\'t be higher than data length');
    }

    _autocorrelation = List.filled(maxLag, 0.0);

    var n = data.length;
    var _aux = _meanAndResidSumOfSquares(data);
    var mean = _aux[0];
    var residSumOfSquares = _aux[1];
    _autocorrelation[0] = 1.0;

    for (var k = 1; k < maxLag; k++) {
      var aux = 0.0;
      for (var i = 0; i < n - k; i++) {
        aux += (data[i] - mean) * (data[i + k] - mean);
      }
      _autocorrelation[k] = aux / residSumOfSquares;
    }
  }

  num forLag(int lag) {
    if (lag > maxLag) {
      throw ArgumentError('Lag $lag can\'t be higher than max lag $maxLag');
    }
    return _autocorrelation[lag];
  }

  /// the autocorrelation coefficients for all lags
  List<num> values() => _autocorrelation;

  /// Calculate the confidence interval for the values
  /// https://www.itl.nist.gov/div898/handbook/eda/section3/autocopl.htm
  /// [confidenceInterval] is the value where the confidence interval should be
  /// calculated (two-sided).
  num confidenceInterval(
      {num confidenceInterval: 0.95,
      InputType inputType: InputType.whiteNoise}) {
    num out;
    if (inputType == InputType.whiteNoise) {
      out = GaussianDistribution().quantile((1 + confidenceInterval) / 2) /
          sqrt(data.length);
    } else {
      throw ArgumentError('Unimplemented $inputType');
    }

    return out;
  }
}

// calculate both the mean and the resid sum of squares in one pass
List<num> _meanAndResidSumOfSquares(Iterable<num> xs) {
  int count = 0;
  num mean = 0;
  num sum = 0; // calculate \sum_{i=1}^N (x_i - E(x))^2
  num delta;
  for (var x in xs) {
    delta = x - mean;
    mean += delta / ++count;
    sum += delta * (x - mean);
  }
  return [mean, sum];
}
