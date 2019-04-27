library all_tests;

import 'analysis/integration/quadrature1D_test.dart' as quadrature1dTest;
import 'analysis/interpolation/spline_interpolator_test.dart' as splineinterpolationTest;
import 'analysis/interpolation/loess_interpolator_test.dart' as loessInterpolationTest;
import 'analysis/interpolation/quadratic_interpolator_test.dart' as quadraticInterpolationTest;
import 'analysis/solver/bisection_solver_test.dart' as bisectionTest;

import 'basic/basic_test.dart' as basicTest;

import 'distribution/discrete_distribution_test.dart' as discretedistTest;
import 'linear/matrix_test.dart' as matrixTest;
import 'linear/qrdecomposition_test.dart' as qrdecompositionTest;
import 'stat/descriptive/ecdf_test.dart' as ecdfTest;
import 'stat/descriptive/quantile_test.dart' as quantileTest;
import 'stat/descriptive/summary_test.dart' as summaryTest;
import 'stat/regression/linear_model_test.dart' as lmTest;
import 'special/erf_test.dart' as erfTest;

main(){

  // analysis
  quadrature1dTest.main();
  splineinterpolationTest.main();
  loessInterpolationTest.main();
  quadraticInterpolationTest.main();

  // basic
  basicTest.tests();


  bisectionTest.main();
  discretedistTest.main();

  // linear algebra
  matrixTest.main();
  qrdecompositionTest.main();

  // linear regression
  lmTest.main();

  // special functions
  erfTest.main();

  // statistics
  ecdfTest.main();
  quantileTest.main();
  summaryTest.main();
}