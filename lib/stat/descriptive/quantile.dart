library stat.descriptive.quantile;

import 'dart:collection';

import 'package:more/hash.dart';

/// See http://en.wikipedia.org/wiki/Quantile
enum QuantileEstimationType { R1, R2, R3, R4, R5, R6, R7, R8, R9 }

class OutOfRangeException implements Exception {
  String message = '';
  OutOfRangeException([message]);
}

class QuantilePair {
  final num probability;
  final num value;

  /// For readability, a class to keep track of the mapping probability -> value
  QuantilePair(this.probability, this.value) {
    if (probability < 0 || probability > 1) {
      throw OutOfRangeException('Invalid probability $probability value');
    }
  }
  @override
  int get hashCode => hash2(probability, value);
  @override
  bool operator ==(other) {
    if (other is! QuantilePair) return false;
    var qp = other;
    return qp.probability == probability && qp.value == value;
  }
}

///No need to do a full sorting Nlog(N).  Partition based selection is a
///linear-time algorithm.  Caching the pivot, speeds up the search even more
///(inspired from Apache commons math).
class Quantile {
  late List<num> _x;
  QuantileEstimationType quantileEstimationType;

  /// keep cached the index of elements that are in the right position.
  late SplayTreeSet<int> _cachedK;

  /// Calculate the quantile of an input list.  The input list [x] does not to be sorted.  The
  /// implementation calculates the rank statistic so is has linear performance.
  ///
  /// Caching is used to reduce the searching even more.  The basic assumption is that the number of quantiles
  /// to be computed is much smaller than the length of the input data (if that's not the case, you
  /// end up caching too much).
  /// [shuffle] the input to avoid corner case performance (if the input vector is ordered decreasingly)
  ///
  /// See http://en.wikipedia.org/wiki/Quantile for different quantile estimation methods.
  Quantile(List<num> x,
      {this.quantileEstimationType = QuantileEstimationType.R7,
      bool shuffle: true}) {
    _x = List.from(x, growable: false);
    if (shuffle) _x.shuffle();
    _cachedK = SplayTreeSet();
  }

  /// Calculate the quantile corresponding to the given probability level
  /// [probability].
  num value(num probability) {
    //print('computing probability $probability');
    if (probability < 0 || probability > 1) {
      throw OutOfRangeException('probability has to be between [0,1]');
    }
    if (_x.isEmpty) return double.nan;
    if (_x.length == 1) return _x[0];
    if (probability == 1) return minK(_x.length - 1);

    num result;
    switch (quantileEstimationType) {
      case QuantileEstimationType.R1:
        var h = _indexR1(probability, _x.length);
        var hf = (h - 0.5).ceil();
        minK(hf);
        result = _x[hf];
        break;

      case QuantileEstimationType.R4:

        /// linear interpolation of the empirical cdf
        var h = _indexR4(probability, _x.length);
        var hf = h.floor();
        minK(hf);
        minK(hf + 1);
        result = _x[hf] + (h - hf) * (_x[hf + 1] - _x[hf]);
        break;

      case QuantileEstimationType.R7:

        /// R's default computation
        var h = _indexR7(probability, _x.length);
        var hf = h.floor();
        minK(hf);
        minK(hf + 1);
        result = _x[hf] + (h - hf) * (_x[hf + 1] - _x[hf]);
        break;

      default:
        throw StateError(
            'Unsupported quantile estimation type $quantileEstimationType');
    }

    return result;
  }

  /// Calculate the median value.
  num median() => value(0.5);

  /// Return the k-th smallest element of the array.  The input argument [k] is
  /// between 0 and [_x.length]-1.  So if k=0, you return the array minimum.
  /// Uses a cache to get the lowest k value if it has already been calculated.
  num minK(int k) {
    if (_cachedK.contains(k)) {
      return _x[k];
    } else {
      _cachedK.add(k);
      return _getLowestK(k);
    }
  }

  ///  To speed up the search, you don't need to scan the entire list.
  ///  Only between two k's that are not in the cache.
  num _getLowestK(int k) {
    assert(k <= _x.length - 1);
    var lo = _cachedK.lastWhere((e) => e < k, orElse: () => 0);
    var hi = _cachedK.firstWhere((e) => e > k, orElse: () => _x.length - 1);
    while (hi > lo) {
      var j = _partition(lo, hi, lo);
      if (j == k) {
        return _x[k];
      } else if (j > k) {
        hi = j - 1;
      } else if (j < k) lo = j + 1;
    }

    return _x[k];
  }

  /// Rearrange the input vector x[lo] to x[hi] and return an integer j (pivot) such that
  /// x[lo] to x[j-1] are less than x[j] and x[j+1] to x[hi] are higher than x[j].
  /// The pivot is the initial index of the pivot element.
  ///
  int _partition(int lo, int hi, int pivot) {
    var i = lo, j = hi + 1;
    var v = _x[pivot];
    while (true) {
      while (_x[++i].compareTo(v) < 0) {
        if (i == hi) break;
      }
      while (v.compareTo(_x[--j]) < 0) {
        if (j == lo) break;
      }
      if (i >= j) break;
      _swap(i, j);
    }
    _swap(lo, j);
    return j;
  }

  void _swap(int i, int j) {
    var t = _x[i];
    _x[i] = _x[j];
    _x[j] = t;
  }
}

num _indexR1(num probability, int length) {
  if (probability == 0) {
    return 0;
  } else {
    return probability * length - 0.5;
  } // wikipedia formulas use 1 based indexing!
}

num _indexR4(num probability, int length) {
  if (probability < 1.0 / length) {
    return 0.0;
  } else if (probability == 1.0) {
    return length - 1;
  } else {
    return probability * length - 1;
  }
}

num _indexR7(num probability, int length) {
  if (probability == 1.0) {
    return length - 1;
  } else {
    return probability * (length - 1);
  }
}
