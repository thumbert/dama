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
