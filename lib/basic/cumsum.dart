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