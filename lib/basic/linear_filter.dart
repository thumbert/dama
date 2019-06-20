library basic.linear_filter;

import 'dart:math' show pow;
import 'package:more/math.dart';

enum Align {past, center, future}

List<num> movingAverageFilter(List<num> x, List<num> coefficients,
    Align align) {
  return [0];
}

/// Filter data according to a binomial filter of a given order.
/// When data can't be calculated, return null.
/// The order needs to be an even integer.
///
List<num> binomialFilter(List<num> x, int order, {Align align: Align.center}) {
  if (order <= 1) throw ArgumentError('Order should be > 1');
  if (order % 2 != 0) throw ArgumentError('The order needs to be even');
  if (2*order+1 > x.length)
    throw ArgumentError('Input list has too few elements');

  var weights = _getBinomialWeights(order);
  int offset;

  var out = List<num>(x.length);
  if (align == Align.center) {
    offset = order ~/ 2;
  } else if (align == Align.past) {
    offset = 0;
  } else {
    throw ArgumentError('$align not implemented yet');
  }
  num value;
  for (int i=offset; i<x.length-offset; i++) {
    value = 0.0;
    for (int j=0; j<weights.length; j++) {
      value += weights[j] * x[i + j - offset];
    }
    out[i] = value;
  }

  return out;
}


List<double> _getBinomialWeights(int n) {
  var denominator = pow(2, n);
  var out = List<double>(n+1);
  for (int k = 0; k < n; k++) {
    out[k] = binomial(n,k)/denominator;
    out[n-k] = out[k];
  }
  return out;
}