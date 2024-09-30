/// Given a list of stuff, replace the missing value usually a null,
/// by the last available observation.  If the input list starts with
/// missing values, they get ignored until the fist value. 
List<K> lastObservationCarriedForward<K>(List<K> x, {Function? isMissing}) {
  isMissing ??= (x) => x == null;
  if (x.isEmpty) return x;
  for (var i=1; i<x.length; i++) {
    if (isMissing(x[i-1])) continue;
    if (isMissing(x[i])) {
      x[i] = x[i-1];
    }
  }
  return x;
}
