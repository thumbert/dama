library stat.descriptive.tabulate;

/// Count the number of occurrences in a list.
/// If an [input] map is passed, the calculation adds to the existing count.
Map<K, int> count<K>(Iterable<K> xs, {Map<K, int>? input}) {
  var out = input ?? <K, int>{};
  for (var x in xs) {
    if (out.containsKey(x)) {
      out[x] = out[x]! + 1;
    } else {
      out[x] = 1;
    }
  }
  return out;
}
