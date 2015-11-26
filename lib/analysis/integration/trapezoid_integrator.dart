library analysis.integration.trapezoid_integrator;

import 'package:dama/analysis/integration/univariate_integrator.dart';

class TrapezoidIntegrator extends BaseAbstractUnivariateIntegrator{
  
  static final int TRAPEZOID_MAX_ITERATIONS_COUNT = 64;
  
  double _s;

  TrapezoidIntegrator({
      double relativeAccuracy, 
      double absoluteAccuracy, 
      int minimalIterationCount, 
      int maximalIterationCount }) {
    if (relativeAccuracy == null) 
      relativeAccuracy = BaseAbstractUnivariateIntegrator.DEFAULT_RELATIVE_ACCURACY;
    if (absoluteAccuracy == null) 
      absoluteAccuracy = BaseAbstractUnivariateIntegrator.DEFAULT_ABSOLUTE_ACCURACY;
    if (minimalIterationCount == null) 
      minimalIterationCount = BaseAbstractUnivariateIntegrator.DEFAULT_MIN_ITERATIONS_COUNT;
    if (maximalIterationCount == null) 
      maximalIterationCount = TRAPEZOID_MAX_ITERATIONS_COUNT;
    if (maximalIterationCount > TRAPEZOID_MAX_ITERATIONS_COUNT) {
      throw "Too many iterations for TrapezoidIntegrator.";
    }
    
    super.initialize(
        relativeAccuracy: relativeAccuracy, 
        absoluteAccuracy: absoluteAccuracy, 
        minimalIterationCount: minimalIterationCount, 
        maximalIterationCount: maximalIterationCount); 
  }
  
  /**
   * Compute the n-th stage integral of trapezoid rule. This function
   * should only be called by API <code>integrate()</code> in the package.
   * To save time it does not verify arguments - caller does.
   * <p>
   * The interval is divided equally into 2^n sections rather than an
   * arbitrary m sections because this configuration can best utilize the
   * already computed values.</p>
  *
   * @param baseIntegrator integrator holding integration parameters
   * @param n the stage of 1/2 refinement, n = 0 is no refinement
   * @return the value of n-th stage integral
   * @throws TooManyEvaluationsException if the maximal number of evaluations
   * is exceeded.
   */
  double stage(final BaseAbstractUnivariateIntegrator baseIntegrator, final int n) {

    if (n == 0) {
      final double max = baseIntegrator.max;
      final double min = baseIntegrator.min;
      _s = 0.5 * (max - min) *
          (baseIntegrator.computeObjectiveValue(min) +
              baseIntegrator.computeObjectiveValue(max));
      return _s;
    } else {
      final int np = 1 << (n-1);           // number of new points in this stage
      double sum = 0.0;
      final double max = baseIntegrator.max;
      final double min = baseIntegrator.min;
      // spacing between adjacent new points
      final double spacing = (max - min) / np;
      double x = min + 0.5 * spacing;    // the first new point
      for (int i = 0; i < np; i++) {
        sum += baseIntegrator.computeObjectiveValue(x);
        x += spacing;
      }
      // add the new sum to previously calculated result
      _s = 0.5 * (_s + sum * spacing);
      return _s;
    }
  }

  
  double doIntegrate() {
    double oldt = stage(this, 0);
    iterations.incrementCount();
    while (true) {
      final int i = iterations.count;
      final double t = stage(this, i);
      if (i >= getMinimalIterationCount()) {
        final double delta = (t - oldt).abs();
        final double rLimit =
            getRelativeAccuracy() * (oldt + t).abs() * 0.5;
        if ((delta <= rLimit) || (delta <= getAbsoluteAccuracy())) {
          return t;
        }
      }
      oldt = t;
      iterations.incrementCount();
    }

    
  }
  
  
}