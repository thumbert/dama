library analysis.interpolation.quadratic_interpolator;

import 'package:dama/dama.dart';

class QuadraticInterpolator {

  List<num> xData;
  List<num> yData;

  Function _l0, _l1, _l2;
  num _x01, _x02, _x12;

  QuadraticInterpolator(this.xData, this.yData) {
    if (xData.length != 3 || yData.length != 3)
      throw new ArgumentError('Length of input lists is not 3.');
    if (min(xData) != xData[0] || max(xData) != xData[2])
      throw new ArgumentError('xData input needs to be sorted');

    _x01 = xData[0] - xData[1];
    _x02 = xData[0] - xData[2];
    _x12 = xData[1] - xData[2];

    _l0 = (x) => (x-xData[1])*(x-xData[2])/(_x01*_x02);
    _l1 = (x) => -(x-xData[0])*(x-xData[2])/(_x01*_x12);
    _l2 = (x) => (x-xData[0])*(x-xData[1])/(_x02*_x12);

  }

  /// return the interpolated value.
  num valueAt(num x) {
    return yData[0]*_l0(x) + yData[1]*_l1(x) + yData[2]*_l2(x);
  }

}