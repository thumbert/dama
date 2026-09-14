library analysis.interpolation.linear_interpolator;

class LinearInterpolator {
  late List<num> _x, _y;
  late Function _fun;
  late num _slope;

  /// A linear interpolator.  Input [x] and [y] are two element lists.
  LinearInterpolator(List<num> x, List<num> y) {
    if (x.length != 2 || y.length != 2) {
      throw ArgumentError(
          'Input lists x and y don\'t have exactly two elements.');
    }
    if (x[0] == x[1]) {
      throw ArgumentError('Undefined slope.');
    }
    _x = x;
    _y = y;
    _slope = (_y[1] - _y[0]) / (_x[1] - _x[0]);
    _fun = (v) => _slope * (v - _x[0]) + _y[0];
  }

  LinearInterpolator.fromSlope(
      {required num slope, required ({num x0, num y0}) point}) {
    _slope = slope;
    _x = [point.x0, point.x0 + 1]; // arbitrary second point to define the line
    _y = [point.y0, point.y0 + slope];
    _fun = (v) => _slope * (v - _x[0]) + _y[0];
  }

  num valueAt(num x) => _fun(x);

  num inverse(num y) => (y - _y[0]) / _slope + _x[0];
}
