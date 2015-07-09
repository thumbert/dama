library all_tests;

import 'linear/matrix_test.dart' as matrix_test;
import 'linear/qrdecomposition_test.dart' as qrdecomposition_test;

main(){

  // linear
  matrix_test.main();
  qrdecomposition_test.main();


}