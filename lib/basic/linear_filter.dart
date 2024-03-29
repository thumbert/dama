library basic.linear_filter;

import 'dart:math' show pow;
import 'package:more/math.dart';

enum Align { past, center, future }

/// Calculate a moving average.
/// When data can't be calculated, return null.
/// <p>Argument [weights] a numeric list of length n.
/// <p>Align past uses the last n available observations.
List<num?> movingAverageFilter(List<num> x, List<num> weights,
    {Align align = Align.past}) {
  int offset;
  if (align == Align.past) {
    offset = weights.length - 1;
  } else {
    throw ArgumentError('$align not implemented yet');
  }

  var out = List<num?>.filled(x.length, null);
  num value;
  // the bulk
  for (var i = offset; i < x.length; i++) {
    value = 0.0;
    for (var j = 0; j < weights.length; j++) {
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
List<num?> binomialFilter(List<num> x, int order, {bool circular = false}) {
  if (order <= 1) throw ArgumentError('Order should be > 1');
  if (order % 2 != 0) throw ArgumentError('The order needs to be even');
  if (2 * order + 1 > x.length) {
    throw ArgumentError('Input list has too few elements');
  }

  var weights = getBinomialWeights(order);
  var offset = order ~/ 2;

  var out = List<num?>.filled(x.length, null);
  num value;
  if (circular) {
    // the beginning
    for (var i = 0; i < offset; i++) {
      value = 0.0;
      for (var j = 0; j < weights.length; j++) {
        var k = i + j - offset;
        if (k < 0) k += x.length;
        value += weights[j] * x[k];
      }
      out[i] = value;
    }
  }

  // the bulk
  for (var i = offset; i < x.length - offset; i++) {
    value = 0.0;
    for (var j = 0; j < weights.length; j++) {
      value += weights[j] * x[i + j - offset];
    }
    out[i] = value;
  }

  if (circular) {
    // the end
    for (var i = x.length - offset; i < x.length; i++) {
      value = 0.0;
      for (var j = 0; j < weights.length; j++) {
        var k = i + j - offset;
        if (k >= x.length) k -= x.length;
        value += weights[j] * x[k];
      }
      out[i] = value;
    }
  }

  return out;
}

/// For n=2, return [1,2,1] / 4; 
/// For n=4, return [1,4,6,4,1] / 16, etc.
/// 
List<num> getBinomialWeights(int n) {
  assert(n < 63);
  var denominator = pow(2, n);
  var out = List.filled(n + 1, 0.0);
  for (var k = 0; k < n; k++) {
    out[k] = n.binomial(k) / denominator;
    out[n - k] = out[k];
  }
  return out;
}
