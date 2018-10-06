library stat.descriptive.tabulate;

/// Count the number of occurrences in a list.
Map<K,int> count<K>(List<K> xs) {
  var out = <K,int>{};
  for (var x in xs) {
    if (out.containsKey(x)) out[x] += 1;
    else out[x] = 1;
  }
  return out;
}

