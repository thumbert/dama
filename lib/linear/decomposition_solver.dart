library linear.decompositon_solver;

import 'package:dama/linear/matrix.dart';

/**
 * Interface handling decomposition algorithms that can solve A &times X = B.
 */
abstract class DecompositionSolver {
  /**
   * Solve the linear equation AX = B.
   */
  ColumnMatrix solveVector(ColumnMatrix b);

  /**
   * Solve the linear equation AX=B.
   * Return a matrix X that minimizes the two nor of A\times(X-B)
   */
  Matrix solveMatrix(Matrix b);


  /**
   * Check if the decomposed matrix is non-singular.
   */
  bool isNonSingular();
  /**
   * Get the inverse of the decomposed matrix.  If the inverse exists, the result is the same
   * as the inverse of the original matrix.
   */
  Matrix inverse();
}








