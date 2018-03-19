library stat.descriptive.summary;

import 'package:dama/stat/descriptive/quantile.dart';

/// Round a number to any accuracy.
/// round(135, 10) == 140;
/// round(135, 100) == 100;
/// round(135, 25) == 125;
/// round(135.123, 0.1) == 135.1;
num round(num x, num accuracy) {
  int aux = (x/accuracy).round();
  return aux*accuracy;
}


/// Calculate the sum of an iterable.
num sum(Iterable<num> x) => x.reduce((a,b)=>a+b);

/// Calculate the maximum value of an iterable.
num max(Iterable<num> x) => x.reduce((a,b) => a >= b ? a : b);

/// Calculate the minimum value of an iterable.
num min(Iterable<num> x) => x.reduce((a,b) => a <= b ? a : b);

/// Calculate the mean of an iterable.
num mean(Iterable<num> x) {
  int i = 0;
  num res = 0;
  x.forEach((e) {
    res += e;
    i++;
  });
  return res/i;
}


/// Calculate the weighted mean of an iterable.
num weightedMean(Iterable<num> x, Iterable<num> weights) {
  num res = 0;
  num weightSum = 0;
  Iterator ix = x.iterator;
  Iterator iw = weights.iterator;
  while(ix.moveNext() && iw.moveNext()) {
    res += ix.current * iw.current;
    weightSum += iw.current;
  }
  return res/weightSum;
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
  List probs = [0, 0.25, 0.5, 0.75, 1];
  var res = probs.map((p) => q.value(p)).toList();
  res.insert(3, mean(x));
  List names = ['Min.', '1st Qu.', 'Median', 'Mean', '3rd Qu.', 'Max.'];
  return new Map.fromIterables(names, res);
}
