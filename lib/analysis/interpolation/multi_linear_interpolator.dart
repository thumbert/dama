library analysis.interpolation.multi_linear_interpolator;

class MultiLinearInterpolator {
  final List<num> xs, ys;

  /// If [extrapolate] is false, interpolate only between [xs.first] and [xs.last].
  /// otherwise, extrapolate for points before [xs.first] using the first slope
  /// and for points after [xs.last] using the last slope.
  final bool extrapolate;

  /// A linear interpolator for a list of points.
  /// The input list [xs] needs to be sorted.
  /// Infinity is allowed on x values.  All y values need to be finite!
  /// Discontinuous points need to be explicitly specified.  See example in
  /// tests.
  MultiLinearInterpolator(this.xs, this.ys, {this.extrapolate = false}) {
    if (xs.length != ys.length) {
      throw ArgumentError(
          'Input lists xs and ys need to have the same length.');
    }
    if (xs.length < 2) {
      throw ArgumentError('Input lists xs and ys need at least two elements.');
    }
    if (xs.length == 2 && xs[0] == xs[1]) {
      throw ArgumentError('Can\'t have the same start and end values.');
    }
    if (ys.any((e) => !e.isFinite)) {
      throw ArgumentError('All input ys values need to be finite!');
    }
  }

  /// Calculates the value of this stepwise linear function at abscissa [x].
  /// Throws if the function is not defined for abscissa [x].
  num valueAt(num x) {
    if (!extrapolate && (x < xs.first || x > xs.last)) {
      throw ArgumentError(
          'No extrapolation allowed.  $x is outside [${xs.first}, ${xs.last}]');
    }
    var ind = _comparableBinarySearch(x);
    if (x.isFinite & xs[ind].isFinite) {
      var slope = (ys[ind + 1] - ys[ind]) / (xs[ind + 1] - xs[ind]);
      return ys[ind] + slope * (x - xs[ind]);
    } else {
      return ys[ind];
    }
  }

  /// Return the index [i] such that xs[i] <= key < xs[i+1] with two exceptions.
  /// If key <= xs[1] return 0.  If key >= xs[xs.length-2] return xs.length-2.
  int _comparableBinarySearch(num key) {
    var min = 0;
    var max = xs.length;
    if (key <= xs[1]) {
      return 0;
    } else if (key >= xs[xs.length - 2]) {
      return xs.length - 2;
    }
    while (min < max) {
      var mid = min + ((max - min) >> 1);
      var element = xs[mid];
      var comp = element.compareTo(key);
      if (comp == 0) return mid;
      if (comp < 0) {
        if (max - mid == 1) {
          return mid;
        }
        min = mid + 1;
      } else {
        max = mid;
      }
    }
    return -1;
  }
}
