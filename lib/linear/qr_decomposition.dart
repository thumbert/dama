library math.qr_decomposition;

import 'dart:math';
import 'dart:typed_data';
import 'package:dama/linear/matrix.dart';
import 'package:dama/linear/decomposition_solver.dart';

class QRDecomposition {
  late Matrix Q, R;

  /// threshold for the singularity test of the matrix
  num threshold;
  late DoubleMatrix _qrt;
  DoubleMatrix? _cachedQ, _cachedQT; //, _cachedR, _cachedH;

  /// the diagonal elements of R
  late List<num> _rDiag;

  QRDecomposition(Matrix x, {this.threshold = 1E-14}) {
    _qrt = x.transpose() as DoubleMatrix;

    _rDiag = List.filled(min(x.nrow, x.ncol), 0.0);

    decompose(_qrt);
  }

  void decompose(Matrix matrix) {
    for (var minor = 0; minor < min(matrix.nrow, matrix.ncol); minor++) {
      householderReflection(minor);
    }
  }

  void householderReflection(int minor) {
    var qrtMinor = _qrt.data[minor];

    var xNormSqr =
        qrtMinor.skip(minor).fold(0.0, (dynamic prev, e) => prev + e * e);

    final a = qrtMinor[minor] > 0 ? -sqrt(xNormSqr) : sqrt(xNormSqr);
    _rDiag[minor] = a;

    if (a != 0.0) {
      qrtMinor[minor] -= a;
      _qrt[[minor, minor]] = qrtMinor[minor];
      for (var col = minor + 1; col < _qrt.nrow; col++) {
        var qrtCol = _qrt.data[col];
        var alpha = 0.0;
        for (var row = minor; row < qrtCol.length; row++) {
          alpha -= qrtCol[row] * qrtMinor[row];
        }
        alpha /= a * qrtMinor[minor];

        // Subtract the column vector alpha*v from x.
        for (var row = minor; row < qrtCol.length; row++) {
          qrtCol[row] -= alpha * qrtMinor[row];
        }

        _qrt.setRow(col, qrtCol);
      }
    }
  }

  DoubleMatrix getR() {
    var m = _qrt.ncol;
    var n = _qrt.nrow;
    var ra = DoubleMatrix.filled(0.0, m, n);
    for (var row = min(m, n) - 1; row >= 0; row--) {
      ra[[row, row]] = _rDiag[row];
      for (var col = row + 1; col < n; col++) {
        ra[[row, col]] = _qrt[[col, row]];
      }
    }

    return ra;
  }

  /// Return the Q matrix of the QR decomposition.
  /// Matrix Q is orthogonal and has size [m x m]
  DoubleMatrix? getQ() {
    _cachedQ ??= _getQT()!.transpose();
    return _cachedQ;
  }

  DoubleMatrix? _getQT() {
    if (_cachedQT == null) {
      var m = _qrt.ncol;
      var n = _qrt.nrow;
      _cachedQT = DoubleMatrix.filled(0.0, m, m);

      for (var minor = m - 1; minor >= min(m, n); minor--) {
        _cachedQT![[minor, minor]] = 1.0;
      }

      for (var minor = min(m, n) - 1; minor >= 0; minor--) {
        List qrtMinor = _qrt.data[minor];
        _cachedQT![[minor, minor]] = 1.0;
        if (qrtMinor[minor] != 0.0) {
          for (var col = minor; col < m; col++) {
            num alpha = 0.0;
            for (var row = minor; row < m; row++) {
              alpha -= _cachedQT![[col, row]] * qrtMinor[row];
            }
            alpha /= _rDiag[minor] * qrtMinor[minor];

            for (var row = minor; row < m; row++) {
              _cachedQT![[col, row]] += -alpha * qrtMinor[row];
            }
          }
        }
      }
    }

    return _cachedQT;
  }

  /// Return the Householder reflector vectors.
//  Matrix getH() {
//    if (_cachedH == null) {
//
//    }
//
//    return _cachedH;
//  }

  DecompositionSolver getSolver() => _QRSolver(_qrt, _rDiag, threshold);
}

class _QRSolver implements DecompositionSolver {
  final DoubleMatrix _qrt;
  final List _rDiag;
  num threshold;

  _QRSolver(this._qrt, this._rDiag, this.threshold);

  @override
  bool isNonSingular() {
    for (var diag in _rDiag as Iterable<num>) {
      if (diag.abs() <= threshold) {
        return false;
      }
    }
    return true;
  }

  @override
  ColumnMatrix solveVector(ColumnMatrix b) {
    final n = _qrt.nrow;
    final m = _qrt.ncol;
    if (b.nrow != m) {
      throw 'Dimensions mismatch';
    }

    var x = Float64List(n);
    var y = Float64List.fromList(b.data);

    // apply Householder transforms to solve Q.y = b
    for (var minor = 0; minor < min(n, m); minor++) {
      var qrtMinor = _qrt.data[minor];
      num dotProduct = 0.0;
      for (var row = minor; row < m; row++) {
        dotProduct += y[row] * qrtMinor[row];
      }
      dotProduct /= _rDiag[minor] * qrtMinor[minor];

      for (var row = minor; row < m; row++) {
        y[row] += dotProduct * qrtMinor[row];
      }
    }

    // solve triangular system R.x = y
    for (var row = _rDiag.length - 1; row >= 0; --row) {
      y[row] /= _rDiag[row];
      final yRow = y[row];
      final qrtRow = _qrt.data[row];
      x[row] = yRow;
      for (var i = 0; i < row; i++) {
        y[i] -= yRow * qrtRow[i];
      }
    }

    return ColumnMatrix(x);
  }

  @override
  Matrix solveMatrix(Matrix b) {
    throw UnimplementedError('Fix me!');
    // final n = _qrt.nrow;
    // final m = _qrt.ncol;
    // if (b.nrow != m) throw 'Dimensions mismatch';
    //
    // if (!isNonSingular()) throw 'Matrix is singular';
    //
    // throw 'NOT YET IMPLEMENTED ...';
    //
    // final columns = b.ncol;
//    final int blockSize      = BlockRealMatrix.BLOCK_SIZE;
//    final int cBlocks        = (columns + blockSize - 1) / blockSize;
//    final double[][] xBlocks = BlockRealMatrix.createBlocksLayout(n, columns);
//    final double[][] y       = new double[b.getRowDimension()][blockSize];
//    final double[]   alpha   = new double[blockSize];

    // return Matrix([1], 1, 1); // TODO:  Fix me here!
  }

  @override
  Matrix inverse() {
    var n = _qrt.ncol;
    var b = DoubleMatrix.filled(0.0, n, n);
    for (var i = 0; i < n; i++) {
      b.setElement(i, i, 1.0);
    }
    return solveMatrix(b);
  }
}
