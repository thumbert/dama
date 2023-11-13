library analysis.interpolation.multi_linear_interpolator;

import 'package:dama/analysis/interpolation/multi_linear_interpolator.dart';
import 'package:test/test.dart';

void tests() {
  test('Multi linear interpolator', () {
    var ir = MultiLinearInterpolator([0, 1, 5, 7], [0, 4, 10, 12]);
    expect(ir.valueAt(0), 0);
    expect(ir.valueAt(0.5), 2);
    expect(ir.valueAt(1), 4);
    expect(ir.valueAt(2), 5.5);
    expect(ir.valueAt(6), 11);
    expect(ir.valueAt(7), 12);
    expect(() => ir.valueAt(-1), throwsArgumentError);
    expect(() => ir.valueAt(10), throwsArgumentError);
  });

  test('Multi linear interpolator, 2', () {
    // fix error by one
    var ir = MultiLinearInterpolator(
        [23, 51, 82, 112, 143, 144, 173, 204], [0, 4, 10, 12, 20, 28, 32, 40]);
    expect(ir.valueAt(83), 10.066666666666666);
  });

  test('Multi linear interpolator, using infinity', () {
    var ir = MultiLinearInterpolator([0, 15, double.infinity], [15, 0, 0],
        extrapolate: true);
    expect(ir.valueAt(0), 15);
    expect(ir.valueAt(-10), 25);
    expect(ir.valueAt(15), 0);
    expect(ir.valueAt(20), 0);
    expect(ir.valueAt(double.infinity), 0);
  });

  test('Multi linear interpolator, using +/-infinity', () {
    var ir = MultiLinearInterpolator(
        [double.negativeInfinity, 0, 15, double.infinity], [15, 15, 0, 0],
        extrapolate: true);
    expect(ir.valueAt(0), 15);
    expect(ir.valueAt(-10), 15);
    expect(ir.valueAt(15), 0);
    expect(ir.valueAt(20), 0);
    expect(ir.valueAt(double.infinity), 0);
    expect(ir.valueAt(double.negativeInfinity), 15);
  });

  test('Multi linear interpolator, discontinuous function (theta function)',
      () {
    // discontinuity needs to be explicitly specified
    var ir = MultiLinearInterpolator(
        [double.negativeInfinity, 0, double.minPositive, double.infinity],
        [0, 0, 1, 1]);
    expect(ir.valueAt(0), 0);
    expect(ir.valueAt(0.5), 1);
    expect(ir.valueAt(-1), 0);
  });

  test('Multi linear interpolator, 2 points only', () {
    var ir = MultiLinearInterpolator([0, 1], [0, 4], extrapolate: true);
    expect(ir.valueAt(0), 0);
    expect(ir.valueAt(0.5), 2);
    expect(ir.valueAt(1), 4);
    expect(ir.valueAt(2), 8);
    expect(ir.valueAt(-1), -4);
  });
}

void main() {
  tests();
}
