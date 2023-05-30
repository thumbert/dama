library stat.descriptive.moving_statistic;

import 'dart:math';

import 'package:dama/stat/descriptive/summary.dart' as summary;
import 'package:tuple/tuple.dart';

/// How to deal with missing values at the end of the sample.
/// Strategy [EndpointStrategy.padValue] adds [x.first] to the
/// left window if needed and [x.last] to the right window if needed.
///
/// Strategy [EndpointStrategy.padZero] adds zeros to the left and
/// right windows as needed.
///
/// Strategy [EndpointStrategy.truncate] uses only the available values
/// for that window.
enum EndpointStrategy {
  /// Incomplete windows at the beginning of the sample get padded with x.first
  /// value, and at the end of sample by the x.last value
  padValue,

  /// Incomplete windows near the end of the sample will be filled with zeros
  padZero,

  /// Incomplete windows near the end of the sample will be left as such
  truncate,
}

class MovingStatistics {
  /// Inspired from https://www.gnu.org/software/gsl/doc/html/movstat.html#introduction
  /// For example, to calculate only a backward looking moving statistic,
  /// set the [rightWindow] to zero.
  ///
  /// Note: [leftWindow] only include observations in the past, and [rightWindow]
  /// only include observations into the future.  The current observation is
  /// included by default.  So for a series of daily numbers, a 10 day
  /// moving average should be computed with [leftWindow] = 9.
  ///
  ///
  MovingStatistics(
      {required this.leftWindow,
      required this.rightWindow,
      this.endpointStrategy = EndpointStrategy.truncate}) {
    assert(leftWindow >= 0);
    assert(rightWindow >= 0);
  }

  final int leftWindow;
  final int rightWindow;

  /// Not used yet anywhere
  final EndpointStrategy endpointStrategy;

  /// Calculate moving correlation
  /// See for a exponentially weighted formula
  /// https://support.numxl.com/hc/en-us/articles/216100603-EWXCF-Exponential-Weighted-Correlation
  ///
  /// Note: this implementation is done in two passes (can be done in one!)
  List<num> movingCorrelation(List<List<num>> xy) {
    final acc =
        Accumulator(_correlation, windowSize: leftWindow + rightWindow + 1);
    return xy.map((e) => (acc..add(e)).value).toList();
  }

  List<num> movingVariance(List<num> xs) {
    final mm = _MovingVariance(windowSize: leftWindow + rightWindow + 1);
    return xs.map((e) => (mm..add(e)).value).toList();
  }

  List<num> movingMax(List<num> xs) {
    final acc =
        Accumulator(summary.max, windowSize: leftWindow + rightWindow + 1);
    return xs.map((e) => (acc..add(e)).value).toList();
  }

  List<num> movingMin(List<num> xs) {
    final acc =
        Accumulator(summary.min, windowSize: leftWindow + rightWindow + 1);
    return xs.map((e) => (acc..add(e)).value).toList();
  }

  List<Tuple2<num, num>> movingMinMax(List<num> xs) {
    final acc = Accumulator((List<num> ys) {
      var aux = summary.range(ys);
      return Tuple2(aux[0], aux[1]);
    }, windowSize: leftWindow + rightWindow + 1);
    return xs.map((e) => (acc..add(e)).value).toList();
  }

  List<num> movingMean(List<num> xs) {
    final mm = _MovingMean(windowSize: leftWindow + rightWindow + 1);
    return xs.map((e) => (mm..add(e)).value).toList();
  }

  List<Map<String, num>> movingSummary(List<num> xs) {
    final acc = Accumulator((List<num> ys) => summary.summary(ys),
        windowSize: leftWindow + rightWindow + 1);
    return xs.map((e) => (acc..add(e)).value).toList();
  }
}

class Accumulator<T, S> {
  Accumulator(this.function, {required this.windowSize}) {
    _xs = <S>[];
  }

  /// The statistic you want to calculate, e.g. mean.
  final T Function(List<S>) function;

  /// = leftWindow + rightWindow + 1
  final int windowSize;

  int size = 0;
  late T _value;
  late List<S> _xs;

  void add(S x) {
    if (_xs.length == windowSize) {
      /// need to remove the first inserted to make room for the new observation
      _xs.removeAt(0);
    }

    /// add the new value
    _xs.add(x);

    /// calculate the moving statistic
    _value = function(_xs);
  }

  T get value => _value;
}

/// This calculation is memory and computationally efficient.
class _MovingMean {
  _MovingMean({required this.windowSize});

  final int windowSize;

  /// the sum gets updated by adding the new element and dropping off
  /// the first one in the window
  num sum = 0.0;

  /// keep only the elements in the window
  final xs = <num>[];

  void add(x) {
    if (xs.length == windowSize) {
      /// need to remove the first inserted to make room for the new observation
      sum -= xs.first;
      xs.removeAt(0); // hope this is fast and doesn't create a new list
    }
    sum += x;
    xs.add(x);
  }

  num get value => sum / xs.length;
}

class _MovingVariance {
  _MovingVariance({required this.windowSize});

  final int windowSize;

  /// the sum gets updated by adding the new element and dropping off
  /// the first one in the window
  num sumOfSq = 0.0;
  num mean = 0.0;
  num x0 = 0.0;

  /// keep only the elements in the window
  final xs = <num>[];

  void add(x) {
    if (xs.length < windowSize) {
      if (xs.isEmpty) {
        mean = x;
        sumOfSq = 0;
      } else {
        var delta = (x - mean) / (xs.length + 1);
        sumOfSq += (mean - x) *
                (mean - x) *
                xs.length /
                (xs.length + 1) /
                (xs.length + 1) +
            (x - mean - delta) * (x - mean - delta);
        mean = mean + delta;
      }
    } else {
      x0 = xs.removeAt(0);
      var delta = (x - x0) / windowSize;
      mean += delta;
      sumOfSq += (x - mean) * (x - mean) -
          (x0 - mean) * (x0 - mean) +
          windowSize * delta * delta;
    }
    xs.add(x);
  }

  num get value => sumOfSq / (xs.length - 1);
}

// num variance(Iterable<num> xs) {
//   var count = 0;
//   var mean = 0.0;
//   var sum = 0.0;
//   num delta;
//   for (var x in xs) {
//     delta = x - mean;
//     mean += delta / ++count;
//     sum += delta * (x - mean);
//   }
//   if (count > 1) return sum / (count - 1);
//   return double.nan;
// }

num _correlation(List<List<num>> xy) {
  var cov = _covariance(xy);
  var sx = sqrt(summary.variance(xy.map((e) => e[0])));
  var sy = sqrt(summary.variance(xy.map((e) => e[1])));
  return cov / (sx * sy);
}

/// A two-pass calculation of the covariance.
///
num _covariance(List<List<num>> xy) {
  assert(xy.isNotEmpty);
  if (xy.length == 1) {
    return double.nan;
  }
  num meanX = 0.0;
  num meanY = 0.0;
  var n = xy.length;
  for (var i = 0; i < n; i++) {
    meanX += xy[i][0];
    meanY += xy[i][1];
  }
  meanX /= n;
  meanY /= n;
  num result = 0.0;
  for (var i = 0; i < n; i++) {
    final xDev = xy[i][0] - meanX;
    final yDev = xy[i][1] - meanY;
    result += (xDev * yDev - result) / (i + 1);
  }
  return result * (n / (n - 1));
}
