library linear.lu_decomposition;

import 'dart:math';
import 'dart:typed_data';

import 'package:dama/linear/decomposition_solver.dart';

import 'matrix.dart';

/// Calculates the LUP-decomposition of a square matrix.
///Implementation taken from apache commons math.
///
///<p>The LUP-decomposition of a matrix A consists of three matrices L, U and
///P that satisfy: P&times;A = L&times;U. L is lower triangular (with unit
///diagonal terms), U is upper triangular and P is a permutation matrix. All
///matrices are m&times;m.</p>
///<p>As shown by the presence of the P matrix, this decomposition is
///implemented using partial pivoting.</p>
///<p>This class is based on the class with similar name from the
///<a href="http://math.nist.gov/javanumerics/jama/">JAMA</a> library.</p>
///<ul>
///<li>a {@link #getP() getP} method has been added,</li>
///<li>the {@code det} method has been renamed as {@link #getDeterminant()
///getDeterminant},</li>
///<li>the {@code getDoublePivot} method has been removed (but the int based
///{@link #getPivot() getPivot} method has been kept),</li>
///<li>the {@code solve} and {@code isNonSingular} methods have been replaced
///by a {@link #getSolver() getSolver} method and the equivalent methods
///provided by the returned {@link DecompositionSolver}.</li>
///</ul>
///
///@see <a href="http://mathworld.wolfram.com/LUDecomposition.html">MathWorld</a>
///@see <a href="http://en.wikipedia.org/wiki/LU_decomposition">Wikipedia</a>
class LuDecomposition {
  /// Entries of LU decomposition.
  late List<Float64List> _lu;

  /// Pivot permutation associated with LU decomposition. */
  late List<int> _pivot;

  /// Parity of the permutation associated with the LU decomposition. */
  late bool _even;

  /// Singularity indicator. */
  late bool _singular;

  /// Cached value of L. */
  DoubleMatrix? _cachedL;

  /// Cached value of U. */
  DoubleMatrix? _cachedU;

  /// Cached value of P. */
  DoubleMatrix? _cachedP;

  LuDecomposition(DoubleMatrix matrix, {double singularityThreshold = 1e-11}) {
    if (!matrix.isSquare()) {
      throw ArgumentError('Input matrix needs to be a square matrix');
    }

    final m = matrix.ncol;
    _lu = matrix.data;
    _pivot = List.generate(m, (i) => i);
    _even = true;
    _singular = false;

    for (var col = 0; col < m; col++) {
      /// upper
      for (var row = 0; row < col; row++) {
        final luRow = _lu[row];
        var sum = luRow[col];
        for (var i = 0; i < row; i++) {
          sum -= luRow[i] * _lu[i][col];
        }
        luRow[col] = sum;
      }

      /// lower
      var max = col; // permutation row
      var largest = double.negativeInfinity;
      for (var row = col; row < m; row++) {
        final luRow = _lu[row];
        var sum = luRow[col];
        for (var i = 0; i < col; i++) {
          sum -= luRow[i] * _lu[i][col];
        }
        luRow[col] = sum;

        /// maintain best permutation choice
        if (sum.abs() > largest) {
          largest = sum.abs();
          max = row;
        }
      }

      /// Singularity check
      if (_lu[max][col].abs() < singularityThreshold) {
        _singular = true;
        return;
      }

      /// Pivot if necessary
      if (max != col) {
        var tmp = 0.0;
        final luMax = _lu[max];
        final luCol = _lu[col];
        for (var i = 0; i < m; i++) {
          tmp = luMax[i];
          luMax[i] = luCol[i];
          luCol[i] = tmp;
        }
        var temp = _pivot[max];
        _pivot[max] = _pivot[col];
        _pivot[col] = temp;
        _even = !_even;
      }

      /// Divide the lower elements by the "winning" diagonal elt.
      final luDiag = _lu[col][col];
      for (var row = col + 1; row < m; row++) {
        _lu[row][col] /= luDiag;
      }
    }
  }

  /// Returns the matrix L of the decomposition.
  /// <p>L is a lower-triangular matrix</p>
  /// @return the L matrix (or null if decomposed matrix is singular)
  DoubleMatrix getL() {
    if ((_cachedL == null) && !_singular) {
      final m = _pivot.length;
      _cachedL = DoubleMatrix.filled(double.nan, m, m);
      for (var i = 0; i < m; ++i) {
        final luI = _lu[i];
        for (var j = 0; j < i; ++j) {
          _cachedL!.setElement(i, j, luI[j]);
        }
        _cachedL!.setElement(i, i, 1.0);
      }
    }
    return _cachedL!;
  }

  /// Returns the matrix U of the decomposition.
  /// <p>U is an upper-triangular matrix</p>
  /// Return the U matrix (or null if decomposed matrix is singular)
  DoubleMatrix getU() {
    if ((_cachedU == null) && !_singular) {
      final m = _pivot.length;
      _cachedU = DoubleMatrix.filled(double.nan, m, m);
      for (var i = 0; i < m; ++i) {
        final luI = _lu[i];
        for (var j = i; j < m; ++j) {
          _cachedU!.setElement(i, j, luI[j]);
        }
      }
    }
    return _cachedU!;
  }

  /// Returns the P rows permutation matrix.
  /// <p>P is a sparse matrix with exactly one element set to 1.0 in
  /// each row and each column, all other elements being set to 0.0.</p>
  /// <p>The positions of the 1 elements are given by the {@link #getPivot()
  /// pivot permutation vector}.</p>
  /// @return the P rows permutation matrix (or null if decomposed matrix is singular)
  /// @see #getPivot()
  DoubleMatrix getP() {
    if ((_cachedP == null) && !_singular) {
      final m = _pivot.length;
      _cachedP = DoubleMatrix.filled(double.nan, m, m);
      for (var i = 0; i < m; ++i) {
        _cachedP!.setElement(i, _pivot[i], 1.0);
      }
    }
    return _cachedP!;
  }

  /// Get the pivot permutation vector
  List<int> get pivot => List.from(_pivot);

  /// Get a solver for finding the A &times; X = B solution in exact linear
  /// sense.
  DecompositionSolver getSolver() => _Solver(_lu, _pivot, _singular);
}

class _Solver implements DecompositionSolver {
  List<Float64List> lu;
  List<int> pivot;
  bool singular;

  _Solver(this.lu, this.pivot, this.singular);

  @override
  bool isNonSingular() => !singular;

  @override
  ColumnMatrix solveVector(ColumnMatrix b) {
    final m = pivot.length;
    if (b.nrow != m) {
      throw ArgumentError('Dimensions mismatch');
    }

    if (singular) {
      throw ArgumentError('Matrix is singular');
    }

    var bp = List.filled(m, 0.0);

    // Apply permutations to b
    for (var row = 0; row < m; row++) {
      bp[row] = b.data[pivot[row]];
    }

    // Solve LY = b
    for (var col = 0; col < m; col++) {
      final bpCol = bp[col];
      for (var i = col + 1; i < m; i++) {
        bp[i] -= bpCol * lu[i][col];
      }
    }

    // Solve UX = Y
    for (var col = m - 1; col >= 0; col--) {
      bp[col] /= lu[col][col];
      final bpCol = bp[col];
      for (var i = 0; i < col; i++) {
        bp[i] -= bpCol * lu[i][col];
      }
    }

    return ColumnMatrix(bp);
  }

  @override
  Matrix solveMatrix(Matrix b) {
    final m = pivot.length;
    if (b.nrow != m) {
      throw ArgumentError('Dimensions mismatch');
    }

    if (singular) {
      throw ArgumentError('Matrix is singular');
    }

    final nColB = b.ncol;

    // Apply permutations to b
    var bp = DoubleMatrix.filled(double.nan, m, nColB);
    for (var row = 0; row < m; row++) {
      final bpRow = bp.data[row];
      final pRow = pivot[row];
      for (var col = 0; col < nColB; col++) {
        bpRow[col] = b.element(pRow, col);
      }
    }

    // Solve LY = b
    for (var col = 0; col < m; col++) {
      final bpCol = bp.data[col];
      for (var i = col + 1; i < m; i++) {
        final bpI = bp.data[i];
        final luICol = lu[i][col];
        for (var j = 0; j < nColB; j++) {
          bpI[j] -= bpCol[j] * luICol;
        }
      }
    }

    // Solve UX = Y
    for (var col = m - 1; col >= 0; col--) {
      final bpCol = bp.data[col];
      final luDiag = lu[col][col];
      for (var j = 0; j < nColB; j++) {
        bpCol[j] /= luDiag;
      }
      for (var i = 0; i < col; i++) {
        final bpI = bp.data[i];
        final luICol = lu[i][col];
        for (var j = 0; j < nColB; j++) {
          bpI[j] -= bpCol[j] * luICol;
        }
      }
    }

    return bp;
  }

  /// Get the inverse of the decomposed matrix
  @override
  Matrix inverse() {
    var n = pivot.length;
    var b = DoubleMatrix.filled(0.0, n, n);
    for (var i = 0; i < n; i++) {
      b.setElement(i, i, 1.0);
    }
    return solveMatrix(b);
  }
}
