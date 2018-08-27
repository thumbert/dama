/// Get the indices of the top n elements from the input List [x].
/// Function [extractor] is the extractor of the values to compare, the default is
/// the accessor function (i) => x[i].
/// <p> Function [comparator] is how you compare the elements of the list, by
/// default the compareTo method.
/// Return an List of n integers with the index of the highest n elements
/// (in sorted order), element [0] being the max, element [1] being the second
/// highest, etc.  If [n] is higher than the list values, return the list
/// values, sorted.
List<int> topN(List x, int n, {Function extractor, Function comparator}) {
  extractor ??= (i) => x[i];
  comparator ??= (i,j) => -extractor(i).compareTo(extractor(j)); // the max function
  if (n < 1) throw new ArgumentError('n needs to be >= 1.');
  var out = new SplayTreeSet.from(new List.generate(n, (i) => i), comparator);
  if (n >= x.length) return out.toList();
  for (int i=n; i<x.length; i++) {
    if (comparator(out.last, i) == 1) {
      out.remove(out.last);
      out.add(i);
    }
  }
  return out.toList();
}
