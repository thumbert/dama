library spline_interpolator;

import 'package:test/test.dart';
import 'package:dama/analysis/interpolation/stepwise_interpolator.dart';

void tests() {
  test('Left stepwise interpolator', () {
    var ipolator = StepwiseInterpolator([0, 1, 2, 3], [10, 5, 4, 3]);
    expect(ipolator.valueAt(0.5), 10);
    expect(ipolator.valueAt(1), 5);
    expect(ipolator.valueAt(1.5), 5);
    expect(ipolator.valueAt(2), 4);
    expect(ipolator.valueAt(5), 3);
    expect(() => ipolator.valueAt(-1), throwsArgumentError);
  });
  test('Right stepwise interpolator', () {
    var ipolator = StepwiseInterpolator([0, 1, 2, 3], [10, 5, 4, 3],
        type: StepwiseType.right);
    expect(ipolator.valueAt(-1), 10);
    expect(ipolator.valueAt(0), 10);
    expect(ipolator.valueAt(0.5), 5);
    expect(ipolator.valueAt(1), 5);
    expect(ipolator.valueAt(1.5), 4);
    expect(ipolator.valueAt(2), 4);
    expect(ipolator.valueAt(3), 3);
    expect(() => ipolator.valueAt(5), throwsArgumentError);
  });
}

void main() {
  tests();
}
