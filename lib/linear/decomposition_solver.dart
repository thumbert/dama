library linear.decompositon_solver;

import 'package:dama/linear/matrix.dart';

/**
 * Interface handling decomposition algorithms that can solve A &times X = B.
 */
abstract class DecompositionSolver {
  /**
   * Solve the linear equation AX = B.
   */
  Matrix solve(ColumnMatrix b);
  /**
   * Check if the decomposed matrix is non-singular.
   */
  bool isNonSingular();
  /**
   * Get the inverse of the decomposed matrix.  If the inverse exists, the result is the same
   * as the inverse of the original matrix.
   */
  Matrix inverse(Matrix b);
}








