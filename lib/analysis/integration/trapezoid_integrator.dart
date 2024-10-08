library analysis.integration.trapezoid_integrator;

import 'package:dama/analysis/integration/univariate_integrator.dart';

class TrapezoidIntegrator extends BaseAbstractUnivariateIntegrator {
  static final int trapezoidMaxIterationsCount = 64;

  double? _s;

  TrapezoidIntegrator(
      {double? relativeAccuracy,
      double? absoluteAccuracy,
      int? minimalIterationCount,
      int? maximalIterationCount}) {
    relativeAccuracy ??=
        BaseAbstractUnivariateIntegrator.defaultRelativeAccuracy;
    absoluteAccuracy ??=
        BaseAbstractUnivariateIntegrator.defaultAbsoluteAccuracy;
    minimalIterationCount ??=
        BaseAbstractUnivariateIntegrator.defaultMinIterationsCount;
    maximalIterationCount ??= trapezoidMaxIterationsCount;
    if (maximalIterationCount > trapezoidMaxIterationsCount) {
      throw 'Too many iterations for TrapezoidIntegrator.';
    }

    super.initialize(
        relativeAccuracy: relativeAccuracy,
        absoluteAccuracy: absoluteAccuracy,
        minimalIterationCount: minimalIterationCount,
        maximalIterationCount: maximalIterationCount);
  }

  /// Compute the n-th stage integral of trapezoid rule. This function
  /// should only be called by API <code>integrate()</code> in the package.
  /// To save time it does not verify arguments - caller does.
  /// <p>
  /// The interval is divided equally into 2^n sections rather than an
  /// arbitrary m sections because this configuration can best utilize the
  /// already computed values.</p>
  ///
  /// @param baseIntegrator integrator holding integration parameters
  /// @param n the stage of 1/2 refinement, n = 0 is no refinement
  /// @return the value of n-th stage integral
  /// @throws TooManyEvaluationsException if the maximal number of evaluations
  /// is exceeded.
  double? stage(
      final BaseAbstractUnivariateIntegrator baseIntegrator, final int n) {
    if (n == 0) {
      final max = baseIntegrator.max;
      final min = baseIntegrator.min;
      _s = 0.5 *
          (max - min) *
          (baseIntegrator.computeObjectiveValue(min) +
              baseIntegrator.computeObjectiveValue(max));
      return _s;
    } else {
      final np = 1 << (n - 1); // number of new points in this stage
      var sum = 0.0;
      final max = baseIntegrator.max;
      final min = baseIntegrator.min;
      // spacing between adjacent new points
      final spacing = (max - min) / np;
      var x = min + 0.5 * spacing; // the first new point
      for (var i = 0; i < np; i++) {
        sum += baseIntegrator.computeObjectiveValue(x);
        x += spacing;
      }
      // add the new sum to previously calculated result
      _s = 0.5 * (_s! + sum * spacing);
      return _s;
    }
  }

  @override
  double? doIntegrate() {
    var oldt = stage(this, 0);
    iterations.incrementCount();
    while (true) {
      final i = iterations.count;
      final t = stage(this, i);
      if (i >= getMinimalIterationCount()) {
        final delta = (t! - oldt!).abs();
        final rLimit = getRelativeAccuracy() * (oldt + t).abs() * 0.5;
        if ((delta <= rLimit) || (delta <= getAbsoluteAccuracy())) {
          return t;
        }
      }
      oldt = t;
      iterations.incrementCount();
    }
  }
}
