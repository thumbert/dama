library all_tests;

import 'linear/matrix_test.dart' as matrix_test;
import 'linear/qrdecomposition_test.dart' as qrdecomposition_test;
import 'stat/regression/linear_model_test.dart' as lm_test;
import 'special/erf_test.dart' as erf_test;

main(){

  // linear algebra
  matrix_test.main();
  qrdecomposition_test.main();

  // linear regression
  lm_test.main();

  // special functions
  erf_test.main();


}