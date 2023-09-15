

library test.linear.lu_decomposition_test;

import 'package:dama/dama.dart';
import 'package:test/test.dart';
import 'package:dama/linear/lu_decomposition.dart';

tests() {
  group('LU decomposition tests', () {
    test('LU decomposition', () {

    });

    test('LU solver', () {
      var testData = DoubleMatrix([1, 2, 3, 2, 5, 3, 1, 0, 8], 3, 3, byRow: true);
      var solver = LuDecomposition(testData).getSolver();
      var b = DoubleMatrix([1, 0, 2, -5, 3, 1], 3, 2, byRow: true);
      var xRef = DoubleMatrix([19, -71, -6, 22, -2, 9], 3, 2, byRow: true);
      var out = solver.solveMatrix(b);
      var err = 0.0;
      for (var i = 0; i < 6; i++) {
        err += (out.toList()[i] - xRef.toList()[i]).abs();
      }
      expect(err < 1E-13, true);
    });
  });
}


main() {
  tests();
}