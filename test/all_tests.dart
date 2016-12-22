library all_tests;

import 'analysis/integration/quadrature1D_test.dart' as quadrature1D_test;
import 'analysis/solver/bisection_solver_test.dart' as bisection_test;
import 'distribution/discrete_distribution_test.dart' as discretedist_test;
import 'linear/matrix_test.dart' as matrix_test;
import 'linear/qrdecomposition_test.dart' as qrdecomposition_test;
import 'stat/regression/linear_model_test.dart' as lm_test;
import 'stat/descriptive/quantile_test.dart' as quantile_test;
import 'special/erf_test.dart' as erf_test;

main(){

  quadrature1D_test.main();

  bisection_test.main();

  discretedist_test.main();

  quantile_test.main();

  // linear algebra
  matrix_test.main();
  qrdecomposition_test.main();

  // linear regression
  lm_test.main();

  // special functions
  erf_test.main();


}