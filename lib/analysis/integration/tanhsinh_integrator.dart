library analysis.integration.tanhsinh_integrator;

import 'dart:math';
import 'package:logging/logging.dart';
import 'package:dama/analysis/integration/univariate_integrator.dart';
import 'package:dama/special/hyperbolic_trig.dart';

final Logger _log = Logger('TanhSinh');

class TanhSinhIntegrator extends BaseAbstractUnivariateIntegrator {
  final int TANHSINH_MAX_LEVEL_COUNT = 12;

  /// Abscissas for the current method. */
  late List<double> _abscissas;

  /// Weights for the current method. */
  late List<double> _weights;

  /// Implements TanhSinh quadrature. Finite interval integration.
  /// See http://projecteuclid.org/download/pdf_1/euclid.em/1128371757
  /// See http://crd-legacy.lbl.gov/~dhbailey/dhbpapers/dhb-tanh-sinh.pdf
  /// See http://people.sc.fsu.edu/~jburkardt/m_src/tanh_quad/tanh_quad.html
  TanhSinhIntegrator(
      {double? relativeAccuracy,
      double? absoluteAccuracy,
      int? minimalIterationCount,
      int? maximalIterationCount}) {
    relativeAccuracy ??=
        BaseAbstractUnivariateIntegrator.DEFAULT_RELATIVE_ACCURACY;
    absoluteAccuracy ??=
        BaseAbstractUnivariateIntegrator.DEFAULT_ABSOLUTE_ACCURACY;
    minimalIterationCount ??=
        BaseAbstractUnivariateIntegrator.DEFAULT_MIN_ITERATIONS_COUNT;
    maximalIterationCount ??= TANHSINH_MAX_LEVEL_COUNT;
    if (maximalIterationCount > TANHSINH_MAX_LEVEL_COUNT) {
      throw 'Too many iterations for TanhSinhIntegrator.';
    }

    super.initialize(
        relativeAccuracy: relativeAccuracy,
        absoluteAccuracy: absoluteAccuracy,
        minimalIterationCount: minimalIterationCount,
        maximalIterationCount: maximalIterationCount);
  }

  /// Calculate the quadrature order.
  int _quad_order(h) {
    num t, u1, u2;
    double? w;

    var N = 0;
    while (true) {
      t = N * h;
      u1 = 0.5 * pi * cosh(t);
      u2 = 0.5 * pi * sinh(t);

      w = h * u1 / pow(cosh(u2), 2);
      if (w! <= getAbsoluteAccuracy()) break;

      N += 1;
    }
    return N;
  }

  /// Sets the _abscissas and _weights.  Each is a vector with length [2*_N+1].
  void _setAbscissasWeights(int N, num h) {
    num u1, u2;

    _abscissas = List.filled(2 * N + 1, 0.0);
    _weights = List.filled(2 * N + 1, 0.0);

    var offset = N;
    for (var i = -N; i <= N; i++) {
      u1 = 0.5 * pi * cosh(h * i);
      u2 = 0.5 * pi * sinh(h * i);
      _abscissas[i + offset] = tanh(u2) as double;
      _weights[i + offset] = h * u1 / pow(cosh(u2), 2);
    }
  }

  @override
  double doIntegrate() {
    // compute first estimate with a single step
    _log.info('Level 1');
    var oldt = _stage(1);
    _log.info('Calculated value $oldt');

    var k = 2;
    while (true) {
      _log.fine('Level $k');

      // improve integral with a larger number of steps
      final t = _stage(k);
      _log.info('Calculated value $t');

      // estimate error
      final delta = (t - oldt).abs();
      final limit = max(getAbsoluteAccuracy(),
          getRelativeAccuracy() * (oldt.abs() + t.abs()) * 0.5);

      // check convergence
      if ((iterations.count + 1 >= getMinimalIterationCount()) &&
          (delta <= limit)) {
        return t;
      }

      // prepare next level
      k += 1;
      oldt = t;
      iterations.incrementCount();
    }
  }

  /// Compute the k-th level integral
  /// @param k the level
  /// @return the value of k-th level integral
  /// @throws TooManyEvaluationsException if the maximum number of evaluations
  /// is exceeded.
  double _stage(final int k) {
    var h = pow(2, -k); // spacing

    //int N = 8*pow(2, k);   // quadrature order
    var N = _quad_order(h);
    _log.info('Quad order: $N');

    // calculate the abscissas and weights
    _setAbscissasWeights(N, h);

    // set up the step for the current stage
    final step = (this.max - this.min);
    final halfStep = step / 2.0;

    // sum w_i * f_i
    var midPoint = this.min + halfStep;
    var sum = 0.0;
    for (var j = 0; j < _abscissas.length; ++j) {
      sum += _weights[j] *
          computeObjectiveValue(midPoint + halfStep * _abscissas[j]);
    }

    return halfStep * sum;
  }
}
