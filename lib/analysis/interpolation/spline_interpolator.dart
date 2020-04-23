library analysis.interpolation.spline_interpolator;


class SplineInterpolator {
  List<num> xData, yData;

  Function _fun;
  List<int> _ind;
  /// the cubic spline coefficients --  b is linear, c quadratic, d is cubic (original y's are constants)
  List<num> _b, _c, _d;

  /// Spline interpolator corresponds to method of
  /// Forsythe, Malcolm and Moler (an exact cubic is fitted through the four
  /// points at each end of the data, and this is used to determine
  /// the end conditions).  See the R implementation in package stats.
  SplineInterpolator(this.xData, this.yData) {
    if (xData.length != yData.length) {
      throw 'Dimensions of xData and yData don\'t match.';
    }

    if (xData.length < 3) {
      throw 'Number of data points need to be at least 3.';
    }

    var n = xData.length - 1;

    // difference between knots
    var h = List<num>(n);
    for (var i = 0; i < n; i++){
      h[i] = xData[i+1] - xData[i];
      if (h[i] < 0) {
        throw 'Values of x data need to be ordered increasingly';
      }
    }

    var mu = List<num>(n);
    var z = List<num>(n + 1);
    mu[0] = 0.0;
    z[0] = 0.0;
    num g = 0.0;

    for (var i = 1; i < n; i++) {
      g = 2.0 * (xData[i+1] - xData[i-1]) - h[i-1] * mu[i-1];
      mu[i] = h[i] / g;
      z[i] = (3.0 * (yData[i + 1] * h[i - 1] - yData[i] * (xData[i + 1] - xData[i - 1])+ yData[i - 1] * h[i]) /
          (h[i - 1] * h[i]) - h[i - 1] * z[i - 1]) / g;
    }

    _b = List<num>(n);
    _c = List<num>(n + 1);
    _d = List<num>(n);

    z[n] = 0.0;
    _c[n] = 0.0;

    for (var j = n -1; j >=0; j--) {
      _c[j] = z[j] - mu[j] * _c[j + 1];
      _b[j] = (yData[j + 1] - yData[j]) / h[j] - h[j] * (_c[j + 1] + 2.0 * _c[j]) / 3.0;
      _d[j] = (_c[j + 1] - _c[j]) / (3.0 * h[j]);
    }

    _ind = List.generate(n, (i) => i);

    _fun = (num x) {
      var i = _findInd(x);
      if (i == -1) return double.nan;
      var d = x - xData[i];
      return yData[i] + _b[i]*d + _c[i]*d*d + _d[i]*d*d*d;
    };
  }

  /// Find the index of the piecewise spline
  int _findInd(num x) {
    int i;
    if (x < xData.first) {
      return -1; // 0
    } else if (x > xData.last) {
      return -1; // xData.length-1;
    } else {
      i = _ind.lastWhere((i) => xData[i] <= x);
    }
    return i;
  }

  /// Use the spline interpolator to calculate the value at location [x].
  num valueAt(num x) {
    var y = _fun(x);
    return y;
  }

  /// Calculate the derivative of the spline interpolating function at
  /// location [x].
  num derivativeAt(num x, {int order: 1}) {
    var i = _findInd(x);
    var h = x - xData[i];
    num res = 0;  // if order is greater than 3
    if (order < 1) {
      throw ArgumentError('Order needs to be >= 1');
    }

    if (order == 1) {
      return _b[i] + 2*_c[i]*h + 3*_d[i]*h*h;
    } else if (order == 2) {
      return 2*_c[i] + 6*_d[i]*h;
    } else if (order == 3) {
      return 6*_d[i];
    }
    return res;
  }

}
