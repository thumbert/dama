library basic.num_iterable_extensions;

import 'package:dama/stat/descriptive/summary.dart' as smary;
import 'cumsum.dart' as cs;

extension NumIterableExtensions on Iterable<num> {

  Iterable<num> cumMean() => cs.cumMean(this);

  Iterable<num> cumSum() => cs.cumsum(this);

  /// Return the index of the max value of this iterable
  ///
  int indexOfMax() {
    var value = first;
    var index = 0;
    var i = 0;
    for (var e in this) {
      if (e > value) {
        index = i;
        value = e;
      }
      i++;
    }
    return index;
  }

  /// Return the index of the min value of this iterable
  ///
  int indexOfMin() {
    var value = first;
    var index = 0;
    var i = -1;
    for (var e in this) {
      i++;
      if (e < value) {
        index = i;
        value = e;
      }
    }
    return index;
  }

  /// Calculate the Median Absolute Deviation (MAD) a robust measure of the
  /// variability of a univariate sample.  The return value is not adjusted
  /// by the multiplier 1.4826.
  /// https://en.wikipedia.org/wiki/Median_absolute_deviation
  num mad() => smary.mad(this);

  num max() => smary.max(this);
  num min() => smary.min(this);
  List<num> range() => smary.range(this);
  num sum() => smary.sum(this);
  num mean() => smary.mean(this);

  Map<String, num> summary() => smary.summary(this);
  num variance() => smary.variance(this);
}