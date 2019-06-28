library stat.descriptive.summary;

import 'dart:math' show sqrt;
import 'package:dama/stat/descriptive/quantile.dart';

/// Round a number to any accuracy.
/// round(135, 10) == 140;
/// round(135, 100) == 100;
/// round(135, 25) == 125;
/// round(135.123, 0.1) == 135.1;
/// <p> Can fail: round(1230.802, 0.001) == 1230.80200000001 !
num round(num x, num accuracy) {
  int aux = (x / accuracy).round();
  return aux * accuracy;
}

/// Calculate the sum of an iterable.
num sum(Iterable<num> x) => x.reduce((a, b) => a + b);

/// Calculate the maximum value of an iterable.
num max(Iterable<num> x) => x.reduce((a, b) => a >= b ? a : b);

/// Calculate the minimum value of an iterable.
num min(Iterable<num> x) => x.reduce((a, b) => a <= b ? a : b);

/// Calculate the mean of an iterable.
num mean(Iterable<num> x) {
  int i = 0;
  num res = 0;
  x.forEach((e) {
    res += e;
    i++;
  });
  return res / i;
}

/// Calculate the weighted mean of an iterable.
num weightedMean(Iterable<num> x, Iterable<num> weights) {
  num res = 0;
  num weightSum = 0;
  Iterator ix = x.iterator;
  Iterator iw = weights.iterator;
  while (ix.moveNext() && iw.moveNext()) {
    res += ix.current * iw.current;
    weightSum += iw.current;
  }
  return res / weightSum;
}

/// Calculate the variance of an iterable.  Return [nan] if the iterable has
/// less than 2 elements.
num variance(Iterable<num> xs) {
  int count = 0;
  num mean = 0;
  num sum = 0;
  num delta;
  for (var x in xs) {
    delta = x - mean;
    mean += delta / ++count;
    sum += delta * (x - mean);
  }
  if (count > 1) return sum / (count - 1);
  return double.nan;
}


/// Calculate the unbiased covariance estimator of two numeric vectors.
/// cov(X, Y) = sum [(xi - E(X))(yi - E(Y))] / (n - 1)
/// The length of the two vectors must be equal.///
num covariance(List<num> x, List<num> y) {
  if (x.length != y.length)
    throw ArgumentError('Input arguments don\'t have the same lengths');
  int n = x.length;
  if (n < 2)
    throw ArgumentError('Input lists must have length > 1');

  // calculation require two traversals.  If clever, only one traversal should
  // be needed, see the [variance] implementation.
  num meanX = 0.0;
  num meanY = 0.0;
  for (int i = 0; i < n; i++) {
    meanX += x[i];
    meanY += y[i];
  }
  meanX /= n;
  meanY /= n;
  num result = 0.0;
  for (int i = 0; i < n; i++) {
    final xDev = x[i] - meanX;
    final yDev = y[i] - meanY;
    result += (xDev * yDev - result) / (i + 1);
  }

  return result * (n / (n - 1));
}

/// Calculate Pearson't correlation as defined by formula:
/// cor(X, Y) = sum[(xi - E(X))(yi - E(Y))] / [(n - 1)s(X)s(Y)]
num correlation(List<num> x, List<num> y) {
  num cov = covariance(x, y);
  num sx = sqrt(variance(x));
  num sy = sqrt(variance(y));
  return cov/(sx * sy);
}




/// Calculate the open, high, low, close of this iterable.
Map<String, num> ohlc(Iterable<num> xs) {
  num first = xs.first;
  num high = xs.first;
  num low = xs.first;
  num close;
  xs.forEach((x) {
    if (x > high) high = x;
    if (x < low) low = x;
    close = x;
  });
  return <String, num>{'open': first, 'high': high, 'low': low, 'close': close};
}

/// Calculate the range of the data.  Requires only one pass.
/// Return a two element list [min,max].
List<num> range(Iterable<num> x) {
  num min = x.first;
  num max = x.first;
  x.skip(1).forEach((e) {
    if (e < min) min = e;
    if (e > max) max = e;
  });
  return [min, max];
}

/// Calculate a simple summary of an iterable x.  Similar to R's summary.
/// Return a map with the minimum, first quantile, median, mean, third quantile,
/// maximum value of this iterable.
/// By default the [isValid] function takes out the NAN values.
///
Map<String, num> summary(Iterable<num> x, {Function isValid}) {
  isValid ??= (num x) => x.isNaN ? false : true;
  Quantile q = new Quantile(x.where(isValid).toList(growable: false));
  var probs = [0, 0.25, 0.5, 0.75, 1];
  var res = probs.map((p) => q.value(p)).toList();
  res.insert(3, mean(x));
  var names = ['Min.', '1st Qu.', 'Median', 'Mean', '3rd Qu.', 'Max.'];
  return new Map.fromIterables(names, res);
}
