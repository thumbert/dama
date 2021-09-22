library all_tests;

import 'analysis/integration/quadrature1D_test.dart' as quadrature1d;
import 'analysis/interpolation/spline_interpolator_test.dart'
    as spline_interpolation;
import 'analysis/interpolation/stepwise_interpolator_test.dart'
    as stepwise_interpolation;
import 'analysis/interpolation/loess_interpolator_test.dart'
    as loess_interpolation;
import 'analysis/interpolation/quadratic_interpolator_test.dart'
    as quadratic_interpolation;
import 'analysis/solver/bisection_solver_test.dart' as bisection;

import 'basic/basic_test.dart' as basic;
import 'basic/linear_filter_test.dart' as linear_filter;
import 'basic/num_extensions_test.dart' as num_extensions;

import 'distribution/discrete_distribution_test.dart' as discrete_distribution;
import 'distribution/lognormal_distribution_test.dart'
    as lognormal_distribution;
import 'distribution/normal_distribution_test.dart' as normal_distribution;

import 'linear/matrix_test.dart' as matrix;
import 'linear/qrdecomposition_test.dart' as qr_decomposition;
import 'stat/descriptive/autocorrelation_test.dart' as autocorrelation;
import 'stat/descriptive/ecdf_test.dart' as ecdf;
import 'stat/descriptive/quantile_test.dart' as quantile;
import 'stat/descriptive/summary_test.dart' as summary;
import 'stat/regression/linear_model_test.dart' as lm;
import 'stat/regression/linear_model_summary_test.dart' as lm_summary;
import 'special/erf_test.dart' as erf;

void main() {
  // analysis
  quadrature1d.main();
  loess_interpolation.tests();
  quadratic_interpolation.main();
  spline_interpolation.main();
  stepwise_interpolation.tests();

  // basic
  basic.tests();
  linear_filter.tests();
  num_extensions.tests();

  bisection.main();
  discrete_distribution.main();
  lognormal_distribution.tests();
  normal_distribution.tests();

  // linear algebra
  matrix.main();
  qr_decomposition.main();

  // linear regression
  lm.tests();
  lm_summary.tests();

  // special functions
  erf.main();

  // statistics
  autocorrelation.tests();
  ecdf.main();
  quantile.main();
  summary.main();
}
