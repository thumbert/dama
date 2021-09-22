library analysis.interpolation.stepwise_interpolator;

enum StepwiseType { left, right }

class StepwiseInterpolator {
  final List<num> xs, ys;
  final StepwiseType type;

  /// A stepwise interpolator.
  /// The input list [x] needs to be sorted.
  ///
  /// For type = [StepwiseType.left]
  /// ```
  /// f(x) = y[0] for x[0] <= x < x[1],
  ///      = y[1] for x[1] <= x < x[2],
  ///      ...
  ///      = y[n] for x[n] <= x < \infty
  /// ```
  /// And for type = [StepwiseType.right]
  /// ```
  /// f(x) = y[0] for -\infty < x <= x[0],
  ///      = y[1] for x[0] < x <= x[1],
  ///      ...
  ///      = y[n] for x[n-1] < x <= x[n]
  /// ```
  ///
  ///
  StepwiseInterpolator(this.xs, this.ys, {this.type = StepwiseType.left}) {
    if (xs.length != ys.length) {
      throw ArgumentError('Input lists x and y need to have the same length.');
    }
    if (xs.length < 2) {
      throw ArgumentError('Input lists x and y need at least two elements.');
    }
    if (xs.length == 2 && xs[0] == xs[1]) {
      throw ArgumentError('Can\'t have the same start and end values.');
    }
  }

  /// Calculates the value of this stepwise function at abscissa [x].
  /// Throws if the function is not defined for abscissa [x].
  num valueAt(num x) {
    if (type == StepwiseType.left) {
      if (x < xs.first) {
        throw ArgumentError('Function is not defined for x < ${xs.first}');
      }
    } else {
      if (x > xs.last) {
        throw ArgumentError('Function is not defined for x > ${xs.last}');
      }
    }
    var ind = _comparableBinarySearch(x);
    return ys[ind];
  }

  /// For type == left, return the smallest index [i] such that x[i] <= key < x[i+1]
  /// for type == right, return the smallest index [i] such that x[i-1] < key <= x[i]
  int _comparableBinarySearch(num key) {
    var min = 0;
    var max = xs.length;
    if (type == StepwiseType.right && key <= xs.first) return 0;
    while (min < max) {
      var mid = min + ((max - min) >> 1);
      var element = xs[mid];
      var comp = element.compareTo(key);
      if (comp == 0) return mid;
      if (comp < 0) {
        if (max - mid == 1) {
          return type == StepwiseType.left ? mid : max;
        }
        min = mid + 1;
      } else {
        max = mid;
      }
    }
    return -1;
  }
}
