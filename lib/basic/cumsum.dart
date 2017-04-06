library basic.cumsum;

/// Calculate the cumulative sum of the input iterable [x].
/// If the input iterable is empty, return the list [0]
Iterable<num> cumsum(Iterable<num> x) {
  num partial = 0;
  if (x.isEmpty) return [partial];
  return x.map((e) {
    partial += e;
    return partial;
  });
}