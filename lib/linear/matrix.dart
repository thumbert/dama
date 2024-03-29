library matrix.dart;

import 'dart:math';
import 'dart:typed_data';

part 'diagonal_matrix.dart';
part 'column_matrix.dart';
part 'block_matrix.dart';
part 'double_matrix.dart';

abstract class Matrix {
  final int nrow;
  final int ncol;

  static String MULTIPLICATION_METHOD = 'NAIVE';

  Matrix._empty(this.nrow, this.ncol);

  /// Create a matrix from a list of values.  Elements are filled in column major order, e.g.
  /// for element [i,j] the index i varies faster.  You can fill elements in row major order by
  /// specifying  the flag [byRow: true].
  factory Matrix(Iterable<num> x, int nrow, int ncol, {bool byRow = false}) {
    if (x.length != nrow * ncol) throw 'Dimensions mismatch';
    return DoubleMatrix(x as List<num>, nrow, ncol, byRow: byRow);
  }

  /// Create a Matrix with all entries set to a given value.
  factory Matrix.filled(num value, int nrow, int ncol) {
    return DoubleMatrix.filled(value.toDouble(), nrow, ncol);
  }

  /// Get the element [i,j] of the matrix.
  double element(int i, int j);

  /// Set the matrix element [i,j] to [value].
  void setElement(int i, int j, num value);

  ///Get the row with index [i] from the matrix.
  Matrix row(int i) {
    var res = List.filled(ncol, 0.0);
    for (var j = 0; j < ncol; j++) {
      res[j] = element(i, j);
    }
    return Matrix(res, 1, ncol);
  }

  /// Overwrite the row [i] of the matrix with [values].
  void setRow(int i, List<num> values) {
    for (var j = 0; j < ncol; j++) {
      setElement(i, j, values[j].toDouble());
    }
  }

  /// Get the column with index [j] from the matrix.
  Matrix column(int j) {
    var x = List.generate(nrow, (i) => element(i, j), growable: false);
    return Matrix(x, nrow, 1);
  }

  /// Overwrite the column [j] of the matrix with [values].
  void setColumn(int j, List<num> values) {
    for (var i = 0; i < nrow; i++) {
      setElement(i, j, values[i].toDouble());
    }
  }

  /// Reshape a matrix.  Arrange the given elements to a different matrix
  /// dimensions.  New dimensions should allow reshaping.
  Matrix reshape(int nrow, int ncol) {
    if (this.nrow * this.ncol != nrow * ncol) {
      throw 'Dimensions mismatch!';
    }
    return Matrix(toList(), nrow, ncol);
  }

  /// Return the main diagonal of the matrix.
  List<num> get diag {
    var s = min(nrow, ncol);
    var res = List.filled(s, element(0, 0));
    if (s > 1) {
      for (var i = 1; i < s; i++) {
        res[i] = element(i, i);
      }
    }
    return res;
  }

  /// Set the diagonal values of the matrix
  set diag(List<num> values) {
    var s = min(nrow, ncol);
    for (var i = 0; i < s; i++) {
      setElement(i, i, values[i].toDouble());
    }
  }

  /// Transpose this matrix
  Matrix transpose();

  /// Apply function f to each column of the matrix.  Return a row matrix.
  /// Function f takes an Iterable argument and returns a value.
  Matrix columnApply(Function f) {
    List<num?> res = <num>[];
    for (var j = 0; j < ncol; j++) {
      res.add(f(column(j).toList()));
    }
    return Matrix(res as Iterable<num>, 1, ncol);
  }

  /// Apply function f to each row of the matrix.  Return a column matrix.
  /// Function f takes an Iterable argument and returns a value.
  Matrix rowApply(Function f) {
    List<num?> res = <num>[];
    for (var i = 0; i < nrow; i++) {
      res.add(f(row(i).toList()));
    }
    return Matrix(res as Iterable<num>, nrow, 1);
  }

  /// Calculate the norm of the matrix.
  /// argument [p] can be '1' or 'INFINITY'
  /// If [p=1] it is the maximum absolute column sum of the matrix
  /// If [p=INFINITY] it is the maximum absolute row sum of the matrix
  num norm({String p = '1'}) {
    Function absSum =
        (List<num> x) => x.fold(0.0, (num a, num b) => a + b.abs());
    num res;
    if (p == '1') {
      var aux = columnApply(absSum).toList();
      res = aux.fold(aux.first, (a, b) => max(a, b));
    } else if (p == 'INFINITY') {
      var aux = rowApply(absSum).toList();
      res = aux.fold(aux.first, (a, b) => max(a, b));
    } else {
      throw ('Unknown value p: $p');
    }
    return res;
  }

  /// Extract the data from List<Float64List> back into a Float64List.
  Float64List toList({bool byRow = false}) {
    var res = Float64List(nrow * ncol);
    if (byRow) {
      for (var i = 0; i < nrow; i++) {
        for (var j = 0; j < ncol; j++) {
          res[i * ncol + j] = element(i, j);
        }
      }
    } else {
      for (var j = 0; j < ncol; j++) {
        for (var i = 0; i < nrow; i++) {
          res[j * nrow + i] = element(i, j);
        }
      }
    }

    return res;
  }

  dynamic operator [](List<int> ind) {
    if (ind.length != 2) throw ('Need exacly 2 integers to subset.');
    if (ind[0] >= nrow || ind[1] >= ncol) throw ('Index out of range');
    return element(ind[0], ind[1]);
  }

  operator []=(List<int> ind, num value) {
    if (ind.length != 2) throw ('Need exacly 2 integers to subset.');
    if (ind[0] >= nrow || ind[1] >= ncol) throw ('Indices out of range');
    setElement(ind[0], ind[1], value.toDouble());
  }

  @override
  bool operator ==(Object that) {
    if (that is! Matrix) return false;

    if (that.nrow != nrow || that.ncol != ncol) return false;

    for (var i = 0; i < nrow; i++) {
      for (var j = 0; j < ncol; j++) {
        if (element(i, j) != that.element(i, j)) return false;
      }
    }
    return true;
  }

  /// Check if this matrix is a square matrix or not
  bool isSquare() => nrow == ncol ? true : false;

  /// used in double_matrix.dart
  void _populateMatrix(List<num> x, List<List<double>> data,
      {bool byRow = false}) {
    if (byRow) {
      for (var i = 0; i < nrow; i++) {
        for (var j = 0; j < ncol; j++) {
          data[i][j] = x[j + i * ncol].toDouble();
        }
      }
    } else {
      for (var i = 0; i < nrow; i++) {
        for (var j = 0; j < ncol; j++) {
          data[i][j] = x[i + j * nrow].toDouble();
        }
      }
    }
  }
}
