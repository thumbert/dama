

library test.stat.regression.linear_model_summary_test;

import 'package:test/test.dart';
import 'package:dama/linear/matrix.dart';
import 'package:dama/stat/regression/linear_model.dart';
import '../../_data/cars.dart';

void tests() {
  group('Linear Model Summary', () {
    test('cars data', () {
      var data = cars();
      var X = DoubleMatrix.filled(1.0, 50, 1)
          .cbind(DoubleMatrix(data['speed']!, 50, 1));
      var lm = LinearModel(X, ColumnMatrix(data['dist']!),
          names: ['(Intercept)', 'speed']);
      var res = lm.summary();
      expect(res.toString(), '''Residuals:
    Min       1Q   Median      3Q     Max
-29.069  -9.5253  -2.2719  9.2147  43.201

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) -17.5791     6.7584  -2.601   0.0123   *
      speed   3.9324     0.4155   9.464 1.49e-12 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 15.380 on 48 degrees of freedom
Multiple R-squared: 0.6511''');
    });
  });
}

void main() {
  tests();
}
