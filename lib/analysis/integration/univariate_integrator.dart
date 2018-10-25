library univariate_integrator;

//import 'package:logging/logging.dart';
import 'package:dama/src/utils/incrementor.dart';


//final Logger _log = new Logger("UnivariateIntegrator");


abstract class UnivariateIntegrator {
  
  bool success;
  
  double getRelativeAccuracy();
  
  double getAbsoluteAccuracy();
  
  int getMinimalIterationCount();
  
  /**
   * Get the upper limit for the number of iterations.
   *
   * @return the actual upper limit
   */
  int getMaximalIterationCount();
  
  /**
   * Integrate the function in the given interval.
  *
   * @param maxEval Maximum number of evaluations.
   * @param f the integrand function
   * @param min the min bound for the interval
   * @param max the upper bound for the interval
   * @return the value of integral
   * @throws TooManyEvaluationsException if the maximum number of function
   * evaluations is exceeded.
   * @throws MaxCountExceededException if the maximum iteration count is exceeded
   * or the integrator detects convergence problems otherwise
   * @throws MathIllegalArgumentException if min > max or the endpoints do not
   * satisfy the requirements specified by the integrator
   * @throws NullArgumentException if {@code f} is {@code null}.
   */
  double integrate(int maxEval, Function f, num min, num max);
  
  /**
   * Get the number of function evaluations of the last run of the integrator.
   * @return number of function evaluations
   */
  int getEvaluations();
  
  /**
   * Get the number of iterations of the last run of the integrator.
   * @return number of iterations
   */
  int getIterations();
}



abstract class BaseAbstractUnivariateIntegrator implements UnivariateIntegrator {
  
  static final double DEFAULT_ABSOLUTE_ACCURACY = 1.0e-15;
  
  static final double DEFAULT_RELATIVE_ACCURACY = 1.0e-6;
  
  static final int DEFAULT_MIN_ITERATIONS_COUNT = 3;
  
  static final int DEFAULT_MAX_ITERATIONS_COUNT = 2147483647;
  
  Incrementor iterations;
  
  bool success = false;
  
  double _absoluteAccuracy;
  
  double _relativeAccuracy;
  
  int _minimalIterationCount;
  
  Incrementor _evaluations;
  
  Function _function;  // TODO: how can I specify it's a double -> double ??
  
  double _min;
  
  double _max;
  
  initialize({
      double relativeAccuracy, 
      double absoluteAccuracy,
      int minimalIterationCount, 
      int maximalIterationCount}) {
    
    if (relativeAccuracy == null) {
      _relativeAccuracy = DEFAULT_RELATIVE_ACCURACY;
    } else {
      _relativeAccuracy = relativeAccuracy;
    }
      
    if (absoluteAccuracy == null) {    
      _absoluteAccuracy = DEFAULT_ABSOLUTE_ACCURACY;
    } else {
      _absoluteAccuracy = absoluteAccuracy;
    }
      
    if (minimalIterationCount == null) {
      _minimalIterationCount = DEFAULT_MIN_ITERATIONS_COUNT;
    } else {
      _minimalIterationCount = minimalIterationCount; 
    }
      
    if (maximalIterationCount == null) 
      maximalIterationCount = DEFAULT_MAX_ITERATIONS_COUNT;
    
    iterations = new Incrementor(maximalIterationCount);
    
    assert(_minimalIterationCount > 0);
    assert(maximalIterationCount > _minimalIterationCount);
    
    _evaluations = new Incrementor();
  }
  
  double getRelativeAccuracy() => _relativeAccuracy;

  double getAbsoluteAccuracy() => _absoluteAccuracy;
  
  int getMinimalIterationCount() =>_minimalIterationCount;
  
  int getMaximalIterationCount() => iterations.maximalCount;
  
  int getEvaluations() => _evaluations.count;
  
  int getIterations() => iterations.count;
  
  double get min => _min;
  
  double get max => _max;
  
  double computeObjectiveValue(double point) {
     _evaluations.incrementCount(1);
    return _function(point);
  }
  
  setup(int maxEval, Function f, num lower, num upper) {
    assert(lower < upper);
    _min = lower.toDouble();
    _max = upper.toDouble();
    _function = f; 
    _evaluations.maximalCount = maxEval;
    iterations.resetCount();
  }
  
  double integrate(int maxEval, Function f, num lower, num upper) {
    setup(maxEval, f, lower, upper);
    
    double res = double.nan;
    try {
      res = doIntegrate();
      print("SUCCESS.  Function evaluations: " + getEvaluations().toString());
    } catch (e) {
      print("FAILED.  Too many evaluations or convergence problems. " + 
            "Function evaluations: " + getEvaluations().toString());
    }
    
    return res;
  }
  
  
  double doIntegrate();
}

