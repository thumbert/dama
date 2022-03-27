library basic.cumsum;

/// Calculate the cumulative sum of the input iterable [x].
/// If the input iterable is empty, return the empty list [].
/// This is in contrast with R, where you get 0 which doesn't make
/// sense to me.
Iterable<num> cumsum(Iterable<num> x) {
  num partial = 0;
  if (x.isEmpty) return [];
  return x.map((e) {
    partial += e;
    return partial;
  });
}

/// Calculate the cumulative mean of the input iterable [x].
/// For x = [[1, 2, 3, 4]] return [[1, 1.5, 2, 2.5]].
///
/// If the input iterable is empty, return the empty list [].
/// This is in contrast with R, where you get 0 which doesn't make
/// sense to me.
Iterable<num> cumMean(Iterable<num> x) {
  if (x.isEmpty) return [];
  num partial = 0;
  var i = 0;
  return x.map((e) {
    partial += e;
    i++;
    return partial / i;
  });
}
