library stat.descriptive.quantile;

import 'dart:collection';

/**
 * See http://en.wikipedia.org/wiki/Quantile
 */
enum QuantileEstimationType { R1, R2, R3, R4, R5, R6, R7, R8, R9 }

class OutOfRangeException implements Exception {
  String message;
  OutOfRangeException([message]);
}

/**
 * No need to do a full sorting Nlog(N).  Partition based selection is a linear-time algorithm.
 * Caching the pivot, speeds up the search even more (inspired from Apache commons math).
 */
class Quantile {
  List<num> x;
  QuantileEstimationType quantileEstimationType;

  /// keep cached the index of elements that are in the right position.
  SplayTreeSet<int> _cachedK;

  /**
   * Calculate the quantile of an input list.  The input list [x] does not to be sorted.  The
   * implementation calculates the rank statistic so is has linear performance.
   *
   * Caching is used to reduce the searching even more.  The basic assumption is that the number of quantiles
   * to be computed is much smaller than the length of the input data (if that's not the case, you
   * end up caching too much).
   * [shuffle] the input to avoid corner case performance (if the input vector is ordered decreasingly)
   *
   * See http://en.wikipedia.org/wiki/Quantile for different quantile estimation methods.
   */
  Quantile(List<num> this.x,
      {QuantileEstimationType this.quantileEstimationType: QuantileEstimationType.R7,
      bool shuffle: true}) {
    if (shuffle) x
        .shuffle(); // in case of degeneracy (if the input is sorted decreasingly)

    _cachedK = new SplayTreeSet();
  }

  /**
   * Calculate the quantile corresponding to the given probability level [probability].
   */
  num value(num probability) {
    //print('computing probability $probability');
    if (probability < 0 || probability > 1) throw new OutOfRangeException(
        'probability has to be between [0,1]');
    if (x.length == 0) return double.NAN;
    if (x.length == 1) return x[0];
    if (probability == 1) return minK(x.length-1);

    num result;
    switch (quantileEstimationType) {
      case QuantileEstimationType.R1:
        num h = _indexR1(probability, x.length);
        int hf = (h-0.5).ceil();
        result = x[hf];
        break;

      case QuantileEstimationType.R4:
      /// linear interpolation of the empirical cdf
        num h = _indexR4(probability, x.length);
        int hf = h.floor();
        result = x[hf] + (h-hf)*(x[hf+1]-x[hf]);
        break;

      case QuantileEstimationType.R7:
      /// R's default computation
        num h = _indexR7(probability, x.length);
        int hf = h.floor();
        result = x[hf] + (h-hf)*(x[hf+1]-x[hf]);
        break;

      default:
        break;
    }

    return result;
  }

  /**
   * Calculate the median value.
   */
  median() => value(0.5);


  /**
   * Return the k-th smallest element of the array.  The input argument [k] is
   * between 0 and [x.length]-1.  So if k=0, you return the array minimum.
   * Use the cache to get the lowest k value.
   */
  minK(int k) {
    if (_cachedK.contains(k))
      return x[k];
    else {
      _cachedK.add(k);
      return _getLowestK(k);
    }
  }


  /**
   *  To speed up the search, you don't need to scan the entire list.
   *  Only between two k's that are not in the cache.
   */
  _getLowestK(int k) {
    assert(k <= x.length - 1);
    int lo = _cachedK.lastWhere((e) => e < k, orElse: () => 0);
    int hi = _cachedK.firstWhere((e) => e > k, orElse: () => x.length-1);
    while (hi > lo) {
      int j = _partition(lo, hi, lo);
      if (j == k) return x[k]; // done
      else if (j > k) hi = j - 1;
      else if (j < k) lo = j + 1;
    }

    return x[k];
  }


  /**
   * Rearrange the input vector x[lo] to x[hi] and return an integer j (pivot) such that
   * x[lo] to x[j-1] are less than x[j] and x[j+1] to x[hi] are higher than x[j].
   * The pivot is the initial index of the pivot element.
   *
   */
  int _partition(int lo, int hi, int pivot) {
    int i = lo,
        j = hi + 1;
    var v = x[pivot];
    while (true) {
      while (x[++i].compareTo(v) < 0) if (i == hi) break;
      while (v.compareTo(x[--j]) < 0) if (j == lo) break;
      if (i >= j) break;
      _swap(i, j);
    }
    _swap(lo, j);
    return j;
  }

  void _swap(int i, int j) {
    var t = x[i];
    x[i] = x[j];
    x[j] = t;
  }
}


num _indexR1(num probability, int length) {
  if (probability == 0)
    return 0;
  else
    return probability*length-0.5;  // wikipedia formulas use 1 based indexing!
}

num _indexR4(num probability, int length) {
  if (probability < 1.0/length)
    return 0.0;
  else if (probability == 1.0)
    return length-1;
  else
    return probability*length-1;
}

num _indexR7(num probability, int length) {
  if (probability == 1.0)
    return length-1;
  else
    return probability*(length-1);
}
