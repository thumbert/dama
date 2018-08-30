
library spline_interpolator;

import 'package:test/test.dart';
import 'package:dama/analysis/interpolation/spline_interpolator.dart';

testSplineInterpolator() {
  test('spline, 2 segments degenerate linear', () {
    var ipolator = new SplineInterpolator([0, 0.5, 1], [0, 0.5, 1]);
    expect(ipolator.valueAt(0.4), 0.4);
  });

  test('spline, 3 segments degenerate linear', () {
    var ipolator = new SplineInterpolator([0, 0.5, 1, 1.5], [0, 0.5, 1, 1.5]);
    expect(ipolator.valueAt(0), 0);
    expect(ipolator.valueAt(1.4), 1.4);
    expect(ipolator.valueAt(1.5), 1.5);
  });

  test('spline, general', () {
    var xData = new List.generate(9, (i) => i+1);
    var yData = xData.map((x) => (x-6)*(x-6)).toList();
    var iPolator = new SplineInterpolator(xData, yData);

    var x = [1.04, 2.44, 3.52];
    var yAct = ['24.62311983505155', '12.64779150515464', '6.156678597938145'];
    expect(x.map((e) => iPolator.valueAt(e).toStringAsPrecision(16)).toList(), yAct);
  });


}

main() {
  testSplineInterpolator();
}
