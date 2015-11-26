library filon_integrator;

import 'dart:math';
import 'package:dama/analysis/integration/univariate_integrator.dart';
import 'package:logging/logging.dart';

final Logger _log = new Logger("Filon");



class FilonIntegrator extends BaseAbstractUnivariateIntegrator {

  final int FILON_MAX_ITERATIONS_COUNT = 64;
  
  double _alpha, _beta, _gamma;
  num omega;  // the frequency

  /**
   * Implements Filon quadrature for integration of real univariate functions
   * of form \int_{a}^b f(x) \cos(omega x) dx, where the limits are finite.  For
   * reference, see <b>Handbook of Mathematical Functions</b>, by Abramowitz
   * and Stegun, page 890.
   * Also see: http://www.maths.usyd.edu.au/u/olver/papers/OlverThesis.pdf,
   * http://ltpth.web.psi.ch/seminars/2006/slides-rosenfelder-20060601.pdf
   *
   */
  FilonIntegrator(num omega, {double relativeAccuracy,
                     double absoluteAccuracy,
                     int minimalIterationCount,
                     int maximalIterationCount}) {
    if (relativeAccuracy == null) 
      relativeAccuracy = BaseAbstractUnivariateIntegrator.DEFAULT_RELATIVE_ACCURACY;
    if (absoluteAccuracy == null) 
      absoluteAccuracy = BaseAbstractUnivariateIntegrator.DEFAULT_ABSOLUTE_ACCURACY;
    if (minimalIterationCount == null) 
      minimalIterationCount = BaseAbstractUnivariateIntegrator.DEFAULT_MIN_ITERATIONS_COUNT;
    if (maximalIterationCount == null) 
      maximalIterationCount = FILON_MAX_ITERATIONS_COUNT;
    if (maximalIterationCount > FILON_MAX_ITERATIONS_COUNT) {
      throw "Too many iterations for FilonIntegrator.";
    }
    
    this.omega = omega;
    
    super.initialize(
        relativeAccuracy: relativeAccuracy, 
        absoluteAccuracy: absoluteAccuracy, 
        minimalIterationCount: minimalIterationCount, 
        maximalIterationCount: maximalIterationCount); 
    
  }
  
  alphaBetaGamma(double theta) {
    double theta2 = theta * theta;
    double theta3 = theta2 * theta;
    
    _alpha = 1/theta + sin(2*theta)/(2*theta2) - 2*pow(sin(theta),2)/theta3;
    _beta  = 2*((1+pow(cos(theta),2))/theta2 - sin(2*theta)/theta3);
    _gamma = 4*(-cos(theta)/theta2 + sin(theta)/theta3);  
  }
  
 
  
  double doIntegrate() {
    
    // compute first estimate with a single step
    _log.info("Level 1");
    double oldt = _stage(1);
    _log.info("Calculated value $oldt");
    
    int n = 2;
    while (true) {
      
      _log.fine("Level $n");
      
      // improve integral with a larger number of steps
      final double t = _stage(n);
      _log.info("Calculated value $t");

      // estimate error
      final double delta = (t - oldt).abs();
      final double limit =
          max(getAbsoluteAccuracy(),
              getRelativeAccuracy() * (oldt.abs() + t.abs()) * 0.5);

      // check convergence
      if ((iterations.count + 1 >= getMinimalIterationCount()) && (delta <= limit)) {
        return t;
      }

      // prepare next level
      n += 1;
      oldt = t;
      iterations.incrementCount();      
    } 
    
  }
    
 
  /**
   * Compute the n-th level integral 
   * @param n the level
   * @return the value of n-th level integral
   * @throws TooManyEvaluationsException if the maximum number of evaluations
   * is exceeded.
   */
   double _stage(final int n) {
    
     _log.info("Quad order: $n");
             
    // set up the step for the current stage
    final double step = (this.max - this.min);
    final double h = step/(2*n);           // spacing
    
    double sum   = 0.0;
    double cEven = 0.0;
    double cOdd  = 0.0;
    double x2j;
    double weight;
    
    for (int j = 0; j <= n; ++j) {
      weight = 1.0;
      x2j = this.min + 2*j*h;
      if (j == 0 || j == n) {
        weight = 0.5;
      }
      cEven += weight * cos(omega*x2j) * computeObjectiveValue(x2j);
      if (j > 0)
        cOdd += cos(omega*(x2j-h)) * computeObjectiveValue(x2j-h);
    }
  
    alphaBetaGamma(omega*h);
    
    sum = _alpha * (computeObjectiveValue(this.max)*sin(omega*this.max)  
                    - computeObjectiveValue(this.min)*sin(omega*this.min)) 
          + _beta * cEven 
          + _gamma * cOdd;

    return h * sum;
  }
   
}

  
  

