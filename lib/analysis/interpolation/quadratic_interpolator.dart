library analysis.interpolation.quadratic_interpolator;

import 'package:dama/dama.dart';

class QuadraticInterpolator {
  List<num> x;
  List<num> y;

  late Function _l0, _l1, _l2;
  late num _x01, _x02, _x12;

  QuadraticInterpolator(this.x, this.y) {
    if (x.length != 3 || y.length != 3) {
      throw ArgumentError('Length of input lists is not 3.');
    }
    if (min(x) != x[0] || max(x) != x[2]) {
      throw ArgumentError('xData input needs to be sorted');
    }

    _x01 = x[0] - x[1];
    _x02 = x[0] - x[2];
    _x12 = x[1] - x[2];

    _l0 = (e) => (e - x[1]) * (e - x[2]) / (_x01 * _x02);
    _l1 = (e) => -(e - x[0]) * (e - x[2]) / (_x01 * _x12);
    _l2 = (e) => (e - x[0]) * (e - x[1]) / (_x02 * _x12);
  }

  /// return the interpolated value.
  num valueAt(num x) {
    return y[0] * _l0(x) + y[1] * _l1(x) + y[2] * _l2(x);
  }
}
