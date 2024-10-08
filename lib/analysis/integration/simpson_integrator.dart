library simpson_integrator;

import 'package:dama/analysis/integration/univariate_integrator.dart';
import 'package:dama/analysis/integration/trapezoid_integrator.dart';

class SimpsonIntegrator extends BaseAbstractUnivariateIntegrator {
  final int simpsonMaxIterationsCount = 64;

  /// Implements <a href="http://mathworld.wolfram.com/SimpsonsRule.html">
  /// Simpson's Rule</a> for integration of real univariate functions. For
  /// reference, see <b>Introduction to Numerical Analysis</b>, ISBN 038795452X,
  /// chapter 3.
  /// <p>
  /// This implementation employs the basic trapezoid rule to calculate Simpson's
  /// rule.</p>
  SimpsonIntegrator(
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
    maximalIterationCount ??= simpsonMaxIterationsCount;
    if (maximalIterationCount > simpsonMaxIterationsCount) {
      throw 'Too many iterations for SimpsonIntegrator.';
    }

    super.initialize(
        relativeAccuracy: relativeAccuracy,
        absoluteAccuracy: absoluteAccuracy,
        minimalIterationCount: minimalIterationCount,
        maximalIterationCount: maximalIterationCount);
  }

  @override
  double doIntegrate() {
    var qTrap = TrapezoidIntegrator();
    if (getMinimalIterationCount() == 1) {
      return (4 * qTrap.stage(this, 1)! - qTrap.stage(this, 0)!) / 3.0;
    }

    // Simpson's rule requires at least two trapezoid stages.
    var olds = 0.0;
    var oldt = qTrap.stage(this, 0);
    while (true) {
      final t = qTrap.stage(this, iterations.count)!;
      iterations.incrementCount();
      final s = (4 * t - oldt!) / 3.0;
      if (iterations.count >= getMinimalIterationCount()) {
        final delta = (s - olds).abs();
        final rLimit = getRelativeAccuracy() * (olds.abs() + s.abs()) * 0.5;
        if ((delta <= rLimit) || (delta <= getAbsoluteAccuracy())) {
          return s;
        }
      }
      olds = s;
      oldt = t;
    }
  }
}
