library univariate_integrator;

import 'package:dama/src/utils/incrementor.dart';

abstract class UnivariateIntegrator {
  late bool success;

  double getRelativeAccuracy();

  double getAbsoluteAccuracy();

  int getMinimalIterationCount();

  /// Get the upper limit for the number of iterations.
  ///
  /// @return the actual upper limit
  int getMaximalIterationCount();

  /// Integrate the function in the given interval.
  ///
  /// @param maxEval Maximum number of evaluations.
  /// @param f the integrand function
  /// @param min the min bound for the interval
  /// @param max the upper bound for the interval
  /// @return the value of integral
  /// @throws TooManyEvaluationsException if the maximum number of function
  /// evaluations is exceeded.
  /// @throws MaxCountExceededException if the maximum iteration count is exceeded
  /// or the integrator detects convergence problems otherwise
  /// @throws MathIllegalArgumentException if min > max or the endpoints do not
  /// satisfy the requirements specified by the integrator
  /// @throws NullArgumentException if {@code f} is {@code null}.
  double? integrate(int maxEval, double Function(double) f, num min, num max);

  /// Get the number of function evaluations of the last run of the integrator.
  /// @return number of function evaluations
  int getEvaluations();

  /// Get the number of iterations of the last run of the integrator.
  /// @return number of iterations
  int getIterations();
}

abstract class BaseAbstractUnivariateIntegrator
    implements UnivariateIntegrator {
  static const double defaultAbsoluteAccuracy = 1.0e-15;
  static const double defaultRelativeAccuracy = 1.0e-6;
  static const int defaultMinIterationsCount = 3;
  static const int defaultMaxIterationsCount = 2147483647;

  late Incrementor iterations;

  @override
  bool success = false;

  late double _absoluteAccuracy;

  late double _relativeAccuracy;

  late int minimalIterationCount;

  late Incrementor _evaluations;

  late double Function(double) _function;

  late double _min;

  late double _max;

  void initialize({
    double relativeAccuracy = defaultRelativeAccuracy,
    double absoluteAccuracy = defaultAbsoluteAccuracy,
    int minimalIterationCount = defaultMinIterationsCount,
    int maximalIterationCount = defaultMaxIterationsCount,
  }) {
    this.minimalIterationCount = minimalIterationCount;
    _absoluteAccuracy = absoluteAccuracy;
    _relativeAccuracy = relativeAccuracy;
    this.minimalIterationCount = minimalIterationCount;
    iterations = Incrementor(maximalIterationCount);
    assert(minimalIterationCount > 0);
    assert(maximalIterationCount > minimalIterationCount);
    _evaluations = Incrementor();
  }

  @override
  double getRelativeAccuracy() => _relativeAccuracy;

  @override
  double getAbsoluteAccuracy() => _absoluteAccuracy;

  @override
  int getMinimalIterationCount() => minimalIterationCount;

  @override
  int getMaximalIterationCount() => iterations.maximalCount;

  @override
  int getEvaluations() => _evaluations.count;

  @override
  int getIterations() => iterations.count;

  double get min => _min;

  double get max => _max;

  double computeObjectiveValue(double point) {
    _evaluations.incrementCount(1);
    return _function(point);
  }

  void setup(int maxEval, double Function(double) f, num lower, num upper) {
    assert(lower < upper);
    _min = lower.toDouble();
    _max = upper.toDouble();
    _function = f;
    _evaluations.maximalCount = maxEval;
    iterations.resetCount();
  }

  @override
  double? integrate(
      int maxEval, double Function(double) f, num lower, num upper) {
    setup(maxEval, f, lower, upper);

    double? res = double.nan;
    try {
      res = doIntegrate();
      //print("SUCCESS.  Function evaluations: " + getEvaluations().toString());
    } catch (e) {
//      print("FAILED.  Too many evaluations or convergence problems. " +
//            "Function evaluations: " + getEvaluations().toString());
    }

    return res;
  }

  double? doIntegrate();
}
