library analysis.interpolation.linear_interpolator;

class LinearInterpolator {
  List<num> _x, _y;
  Function _fun;
  num _slope;

  /// A linear interpolator
  LinearInterpolator(List<num> x, List<num> y) {
    if (x.length != 2 || y.length != 2)
      throw new ArgumentError(
          'Input lists x and y don\'t have exactly two elements.');
    if (x[0] == x[1])
      throw new ArgumentError('Undefined slope.');
    _x = x;
    _y = y;
    _slope = (_y[1] - _y[0]) / (_x[1] - _x[0]);
    _fun = (v) => _slope * (v-_x[0]) + _y[0];
  }

  num valueAt(num x) => _fun(x);

  num inverse(num y) => (y - _y[0])/_slope + _x[0];
}