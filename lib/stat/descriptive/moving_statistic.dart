library stat.descriptive.moving_statistic;

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
  /// Note: the implementation is not efficient in that too many passes
  /// through the data are made.  Should rewrite it so that only one pass is
  /// made.
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
  final EndpointStrategy endpointStrategy;

  List<num> movingMax(List<num> xs) {
    final _acc =
        Accumulator(summary.max, windowSize: leftWindow + rightWindow + 1);
    return xs.map((e) => (_acc..add(e)).value).toList();
  }

  List<num> movingMin(List<num> xs) {
    final _acc =
        Accumulator(summary.min, windowSize: leftWindow + rightWindow + 1);
    return xs.map((e) => (_acc..add(e)).value).toList();
  }

  List<Tuple2<num, num>> movingMinMax(List<num> xs) {
    final _acc = Accumulator((List<num> ys) {
      var _aux = summary.range(ys);
      return Tuple2(_aux[0], _aux[1]);
    }, windowSize: leftWindow + rightWindow + 1);
    return xs.map((e) => (_acc..add(e)).value).toList();
  }

  List<num> movingMean(List<num> xs) {
    final _acc =
        Accumulator(summary.mean, windowSize: leftWindow + rightWindow + 1);
    return xs.map((e) => (_acc..add(e)).value).toList();
  }

  List<Map<String, num>> movingSummary(List<num> xs) {
    final _acc = Accumulator((List<num> ys) => summary.summary(ys),
        windowSize: leftWindow + rightWindow + 1);
    return xs.map((e) => (_acc..add(e)).value).toList();
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
  T? _value;
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

  T get value => _value!;
}
