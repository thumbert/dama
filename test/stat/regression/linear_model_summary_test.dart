library test.stat.regression.linear_model_summary_test;

import 'package:dama/stat/regression/linear_model_summary.dart';
import 'package:test/test.dart';
import 'package:dama/linear/matrix.dart';
import 'package:dama/stat/regression/linear_model.dart';
import 'package:dama/src/utils/matchers.dart';
import '../../_data/cars.dart';

void tests() {
  group('Linear Model Summary', () {
    test('cars data', () {
      var data = cars();
      var X = DoubleMatrix.filled(1.0, 50, 1)
              .cbind(DoubleMatrix(data['speed'], 50, 1));
      var lm = LinearModel(X, ColumnMatrix(data['dist']),
          names: ['(Intercept)', 'speed']);
      var res = lm.summary();
      print(res);
      expect(true, true);


    });
  });
}

void main() {
  tests();
}