library test.loess_interpolator_test;

import 'package:test/test.dart';
import 'package:dama/analysis/interpolation/loess_interpolator.dart';
import 'package:dama/stat/descriptive/summary.dart';
import '../../_data/cars.dart';

loessInterpolatorTest() {
  group('Loess interpolator', () {
//    test('two points', () {
//      var x = <num>[0.5, 0.6];
//      var y = <num>[0.7, 0.8];
//      var loess = new LoessInterpolator(x,y);
//      var res = x.map((e) => loess.valueAt(e)).toList();
//      expect(res, y);
//    });

    test('math 296', () {
      var x = <num>[
        0.1,
        0.2,
        0.3,
        0.4,
        0.5,
        0.6,
        0.7,
        0.8,
        0.9,
        1.0,
        1.1,
        1.2,
        1.3,
        1.4,
        1.5,
        1.6,
        1.7,
        1.8,
        1.9,
        2.0
      ];
      var y = <num>[
        0.47,
        0.48,
        0.55,
        0.56,
        -0.08,
        -0.04,
        -0.07,
        -0.07,
        -0.56,
        -0.46,
        -0.56,
        -0.52,
        -3.03,
        -3.08,
        -3.09,
        -3.04,
        3.54,
        3.46,
        3.36,
        3.35
      ];
      List yref = [
        0.46076,
        0.49997,
        0.54298,
        0.31910,
        0.17824,
        -0.03999,
        -0.06999,
        -0.21301,
        -0.32603,
        -0.45999,
        -0.56000,
        -1.49617,
        -2.13178,
        -3.07999,
        -3.08999,
        -0.62295,
        0.997028,
        3.45001,
        3.39075,
        3.33677
      ].map((e) => round(e, 0.001)).toList();
      var loess = new LoessInterpolator(x, y, bandwidth: 0.3, robustnessIters: 4,
        accuracy: 1e-12);
      var res = x.map((e) => loess.valueAt(e)).map((e) => round(e, 0.001)).toList();
      expect(res, yref);
    });
  });
}

loessCarsTest(){
  group('Loess interpolator', () {
    /// this Loess is degree 1, in R it's degree 2 by default.
    Map<String,List<num>> aux = cars();
    var loess = new LoessInterpolator(aux['speed'], aux['dist']);
    var res = aux['speed'].map((x) => loess.valueAt(x)).toList();
    res.forEach(print);
  });
}

main() {
  loessInterpolatorTest();

  //loessCarsTest();

}
