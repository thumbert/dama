library basic.linear_filter;

import 'dart:math' show pow;
import 'package:more/math.dart';

enum Align { past, center, future }


/// Calculate a moving average.
/// <p>Argument [weights] a numeric list of length n.
/// <p>Align past uses the last n available observations.
List<num> movingAverageFilter(
    List<num> x, List<num> weights, {Align align: Align.past}) {

  int offset;
  if (align == Align.past) {
    offset = weights.length - 1;
  } else {
    throw ArgumentError('$align not implemented yet');
  }

  var out = List<num>(x.length);
  num value;
  // the bulk
  for (int i = offset; i < x.length; i++) {
    value = 0.0;
    for (int j = 0; j < weights.length; j++) {
      value += weights[j] * x[i + j - offset];
    }
    out[i] = value;
  }

  return out;
}

/// Filter data according to a binomial filter of a given order.
/// When data can't be calculated, return null.
/// <p>Argument [order] needs to be an even integer.
/// <p>If argument [circular] set to [true] the calculation at both ends wraps
/// around the ends of the series, so no nulls are returned.  This is useful
/// if the data is truly periodic.
///
List<num> binomialFilter(List<num> x, int order, {bool circular: false}) {
  if (order <= 1) throw ArgumentError('Order should be > 1');
  if (order % 2 != 0) throw ArgumentError('The order needs to be even');
  if (2 * order + 1 > x.length)
    throw ArgumentError('Input list has too few elements');

  var weights = _getBinomialWeights(order);
  int offset = order ~/ 2;

  var out = List<num>(x.length);
  num value;
  if (circular) {
    // the beginning
    for (int i = 0; i < offset; i++) {
      value = 0.0;
      for (int j = 0; j < weights.length; j++) {
        int k = i + j - offset;
        if (k < 0) k += x.length;
        value += weights[j] * x[k];
      }
      out[i] = value;
    }
  }

  // the bulk
  for (int i = offset; i < x.length - offset; i++) {
    value = 0.0;
    for (int j = 0; j < weights.length; j++) {
      value += weights[j] * x[i + j - offset];
    }
    out[i] = value;
  }

  if (circular) {
    // the end
    for (int i = x.length - offset; i < x.length; i++) {
      value = 0.0;
      for (int j = 0; j < weights.length; j++) {
        int k = i + j - offset;
        if (k >= x.length) k -= x.length;
        value += weights[j] * x[k];
      }
      out[i] = value;
    }
  }


  return out;
}

/// For n=2, return [1,2,1]; for n=4, return [1,4,6,4,1], etc.
List<double> _getBinomialWeights(int n) {
  var denominator = pow(2, n);
  var out = List<double>(n + 1);
  for (int k = 0; k < n; k++) {
    out[k] = binomial(n, k) / denominator;
    out[n - k] = out[k];
  }
  return out;
}
