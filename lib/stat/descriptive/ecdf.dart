

library stat.descriptive.ecdf;

typedef Ecfd = num Function(num x);

int _indexOf<T>(List<T> elements, bool Function(T element) predicate) {
  for (var i = 0; i < elements.length; i++) {
    if (predicate(elements[i])) return i;
  }
  return -1;
}

/// Calculate the empirical cumulative distribution function from a list
/// of numerical values.
/// Return a function of (num)-> num.
Ecfd ecdf(List<num> values) {
  assert(values.isNotEmpty);
  values.sort();
  num step = 1 / values.length;
  var res = (num x) {
    if (x < values.first) {
      return 0;
    } else if (x >= values[values.length - 1]) {
      return 1;
    } else {
      return _indexOf(values, (num y) => y > x) * step;
    }
  };
  return res;
}
