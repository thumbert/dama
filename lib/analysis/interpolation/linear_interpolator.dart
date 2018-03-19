library analysis.interpolation.linear_interpolator;

class LinearInterpolator {
  List<num> x, y;
  Function _fun;
  LinearInterpolator(this.x, this.y) {
    num slope = (y[1]-y[0])/(x[1]-x[0]);
    _fun = (v) => slope * v + y[0];
  }
  num valueAt(x) => _fun(x);
}
