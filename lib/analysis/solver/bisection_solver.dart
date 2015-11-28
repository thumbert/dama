library analysis.solver.bisection_solver;


/**
 * One dimensional root (zero) finding.
 */
double bisectionSolver(Function f, num lower, num upper, {
  double tolerance: 1E-10, int maxIterations: 1000}) {

  if (lower >= upper)
    throw 'Lower limit needs to be lower than the upper limit.';

  int iter = 0;

  while (true) {
    num m = (lower + upper)/2.0;
    double fMin = f(lower);
    double fm = f(m);

    if (fm * fMin > 0)
      lower = m;
    else
      upper = m;

    if ((upper-lower).abs() <= tolerance) {
      m = (lower + upper)/2.0;
      return m;
    }
    iter += 1;
    if (iter > maxIterations)
      throw 'Maximum number of iterations has been exceeded';
  }
}
