library basic.cumsum;

/// Calculate the cumulative sum of the input iterable [x].
/// If the input iterable is empty, return the empty list [].
/// This is in contrast with R, where you get 0 which doesn't make
/// sense to me.
///
/// For x = [[1, 2, 3, 4]] return [[1, 3, 6, 10]].
Iterable<num> cumSum(Iterable<num> x) {
  if (x.isEmpty) return <num>[];
  num partial = 0;
  return x.map((e) {
    partial += e;
    return partial;
  });
}

/// Calculate the cumulative product of the input iterable [x].
/// If the input iterable is empty, return the empty list [].
///
/// For x = [[1, 2, 3, 4]] return [[1, 2, 6, 24]].
Iterable<num> cumProd(Iterable<num> x) {
  if (x.isEmpty) return <num>[];
  num partial = 1;
  return x.map((e) {
    partial *= e;
    return partial;
  });
}


@Deprecated('Use cumSum')
Iterable<num> cumsum(Iterable<num> x) => cumSum(x);


/// Calculate the cumulative mean of the input iterable [x].
/// For x = [[1, 2, 3, 4]] return [[1, 1.5, 2, 2.5]].
///
/// If the input iterable is empty, return the empty list [].
/// This is in contrast with R, where you get 0 which doesn't make
/// sense to me.
Iterable<num> cumMean(Iterable<num> x) {
  if (x.isEmpty) return <num>[];
  num partial = 0;
  var i = 0;
  return x.map((e) {
    partial += e;
    i++;
    return partial / i;
  });
}
