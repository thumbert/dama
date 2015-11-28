library test.bisection_solver;

import 'dart:math';
import 'package:test/test.dart';
import 'package:dama/analysis/solver/bisection_solver.dart';
import 'package:dama/src/utils/matchers.dart';


test_bisection_solver() {
  group('Bisection solver:', () {
    test('sin', () {
      num value = bisectionSolver((x) => sin(x), 3, 4);
      expect(PI, equalsWithPrecision(value, precision: 1E-6));
    });
    test('quartic', () {
      num value = bisectionSolver((x) => x*(x*x-1)+0.5, -2, 2);
      expect(-1.19148788393573, equalsWithPrecision(value, precision: 1E-10));
    });

  });
}

main() {
  test_bisection_solver();
}