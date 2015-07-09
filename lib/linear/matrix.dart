library linear.matrix;

import 'dart:math';
import 'dart:typed_data';
//import 'package:dama/linear/diagonal_matrix.dart';

part 'diagonal_matrix.dart';
part 'column_matrix.dart';

class Matrix {
  final int nrow;
  final int ncol;
  List data; // stored by row: [[1,2,3]\n[4,5,6]]

  static String MULTIPLICATION_METHOD = 'NAIVE';

  Matrix._empty(int this.nrow, int this.ncol);

  /**
   * Create a matrix from a list of values.  Elements are filled in column major order, e.g.
   * for element [i,j] the index i varies faster.  You can fill elements in row major order by
   * specifying  the flag [byRow: true].
   */
  factory Matrix(List x, int nrow, int ncol, {bool byRow: false}) {
    if (x.length != nrow * ncol) throw 'Dimensions mismatch';

    return new DoubleMatrix(x, nrow, ncol, byRow: byRow);
  }

  /**
   * Create a Matrix with all entries set to given value.
   */
  factory Matrix.filled(num value, int nrow, int ncol) {
    return new DoubleMatrix.filled(value.toDouble(), nrow, ncol);
  }

  /**
   * Get the element [i,j] of the matrix.
   */
  element(int i, int j) => data[i][j];

  /**
   * Set the matrix element [i,j] to [value].
   */
  void setElement(int i, int j, num value) {
    data[i][j] = value.toDouble();
  }

  /**
   * Return a copy of this matrix.
   */
  Matrix copy() => new Matrix(new List.from(data), nrow, ncol);

  /**
   * Get the row with index [i] from the matrix.
   */
  Matrix row(int i) {
    return new Matrix(data[i], 1, ncol);
  }

  /**
   * Overwrite the row [i] of the matrix with [values].
   */
  void setRow(int i, List<num> values) {
    for (int j = 0; j < ncol; j++) data[i][j] = values[j].toDouble();
  }

  /**
   * Get the column with index [j] from the matrix.
   */
  Matrix column(int j) {
    List x = new List.generate(nrow, (i) => data[i][j], growable: false);
    return new Matrix(x, nrow, 1);
  }

  /**
   * Overwrite the column [j] of the matrix with [values].
   */
  void setColumn(int j, List<num> values) {
    for (int i = 0; i < nrow; i++) data[i][j] = values[i].toDouble();
  }

  /**
   * Row bind this matrix with [that] matrix.
   */
  Matrix rbind(Matrix that);

  /**
   * Column bind this matrix with [that] matrix.
   */
  Matrix cbind(Matrix that);

  /**
   * Multiply two matrices -- the naive way
   * [http://en.wikipedia.org/wiki/Matrix_multiplication#Algorithms_for_efficient_matrix_multiplication]
   *
   */
  Matrix multiply(Matrix that) {
    if (ncol != that.nrow) throw 'Dimensions mismatch';
    if (MULTIPLICATION_METHOD == 'NAIVE') return _multiplyNaive(that);
    else throw ('Unsupported multiplication method $MULTIPLICATION_METHOD');
  }

  Matrix _multiplyNaive(Matrix that) {
    Matrix res = new Matrix.filled(0.0, nrow, that.ncol);

    if (that is DiagonalMatrix) {
      // TODO: fill me in here ...

    } else {
      List c = that.transpose().data;
      for (int j = 0; j < that.ncol; j++) {
        for (int i = 0; i < nrow; i++) {
          var s = 0.0;
          for (int k = 0; k < ncol; k++) s += data[i][k] * c[j][k];
          res.data[i][j] = s;
        }
      }
    }

    return res;
  }

  /**
   * Reshape a matrix.
   */
  Matrix reshape(int nrow, int ncol) => new Matrix(data, nrow, ncol);

  /**
   * Return the main diagonal of the matrix.
   */
  List get diag {
    int s = min(nrow, ncol);
    List res = new List.filled(s, data[0][0]);
    if (s > 1) {
      for (int i = 1; i < s; i++) res[i] = data[i][i];
    }
    return res;
  }

  /**
   * Set the diagonal values of the matrix
   */
  set diag(List<num> values) {
    int s = min(nrow, ncol);
    for (int i = 0; i < s; i++) data[i][i] = values[i].toDouble();
  }

  /**
   * Transpose this matrix
   */
  Matrix transpose() {
    Matrix res = new DoubleMatrix.filled(0.0, ncol, nrow);

    for (int i = 0; i < ncol; i++)
      for (int j = 0; j < nrow; j++)
        res.data[i][j] = data[j][i];
    return res;
  }

  /**
   * Apply function f to each column of the matrix.  Return a row matrix.
   * Function f takes an Iterable argument and returns a value.
   */
  Matrix columnApply(Function f) {
    List res = [];
    for (int j = 0; j < ncol; j++) res.add(f(column(j).toList()));
    return new Matrix(res, 1, ncol);
  }

  /**
   * Apply function f to each row of the matrix.  Return a column matrix.
   * Function f takes an Iterable argument and returns a value.
   */
  Matrix rowApply(Function f) {
    List res = [];
    for (int i = 0; i < nrow; i++) res.add(f(row(i).toList()));
    return new Matrix(res, nrow, 1);
  }

  /**
   * Calculate the norm of the matrix.
   * argument [p] can be '1' or 'INFINITY'
   * If [p=1] it is the maximum absolute column sum of the matrix
   * If [p=INFINITY] it is the maximum absolute row sum of the matrix
   */
  num norm({String p: '1'}) {
    Function absSum = (List x) => x.fold(0.0, (a, num b) => a + b.abs());
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

  Matrix transpose_minor_diagonal() {
    List dataNew = [];
    for (int i = 0; i < nrow; i++) {
      for (int j = 0; j < ncol; j++) {
        dataNew.add(data[nrow * ncol - j * nrow - i - 1]);
      }
    }

    return new Matrix(dataNew, ncol, nrow);
  }

  Matrix reflect_diagonal() {
    List dataNew = [];
    for (int j = 0; j < ncol; j++) {
      for (int i = 0; i < nrow; i++) {
        dataNew.add(data[nrow * ncol - j * nrow - i - 1]);
      }
    }

    return new Matrix(dataNew, nrow, ncol);
  }

  /**
   * Extract the data from List<List> back into a List.
   */
  List toList({bool byRow: false }) {
    List res = [];
    if (byRow) {
      for (int i=0; i<nrow; i++)
        res.addAll(data[i]);
    } else {
      for (int j=0; j<ncol; j++)
        for (int i=0; i<nrow; i++)
          res.add(data[i][j]);
    }

    return res;
  }

  operator [](List<int> ind) {
    if (ind.length != 2) throw ('Need exacly 2 integers to subset.');
    if (ind[0] >= nrow || ind[1] >= ncol) throw ('Index out of range');
    return data[ind[0]][ind[1]];
  }

  operator []=(List<int> ind, num value) {
    if (ind.length != 2) throw ('Need exacly 2 integers to subset.');
    if (ind[0] >= nrow || ind[1] >= ncol) throw ('Indices out of range');
    data[ind[0]][ind[1]] = value.toDouble();
  }

  bool operator ==(Matrix that) {
    if (that.nrow != nrow || that.ncol != ncol) return false;

    for (int i = 0; i < nrow; i++)
      for (int j = 0; j < ncol; j++)
        if (data[i][j] != that.data[i][j]) return false;

    return true;
  }

  bool isSquare() => nrow == ncol ? true : false;

  _populateMatrix(List<num> x, List<List> data, {bool byRow: false}) {
    if (byRow) {
      for (int i = 0; i < nrow; i++)
        for (int j = 0; j < ncol; j++)
          data[i][j] = x[j + i * ncol].toDouble();
    } else {
      for (int i = 0; i < nrow; i++)
        for (int j = 0; j < ncol; j++)
          data[i][j] = x[i + j * nrow].toDouble();
    }
  }
}





class DoubleMatrix extends Matrix {
  List<Float64List> data;

  static int DECIMAL_DIGITS = 3;

  //DoubleMatrix._empty()

  /**
   * A matrix will all double elements backed by a List<Float64List>.
   */
  DoubleMatrix(List<num> x, int nrow, int ncol, {bool byRow: false}) : super._empty(nrow, ncol) {
    data = new List.generate(nrow, (i) => new Float64List(ncol));
    _populateMatrix(x, data, byRow: byRow);
  }

  DoubleMatrix.filled(double value, int nrow, int ncol) : super._empty(nrow, ncol) {
    data = new List.generate(nrow, (i) => new Float64List(ncol));
    _populateMatrix(new List.filled(nrow*ncol, value), data);
  }

  DoubleMatrix.zero(int nrow, int ncol) : super._empty(nrow, ncol) {
    data = new List.generate(nrow, (i) => new Float64List(ncol));
  }

  DoubleMatrix column(int j) {
    List<double> x = new List.generate(nrow, (i) => data[i][j]);
    return new DoubleMatrix(x, nrow, 1);
  }

  DoubleMatrix row(int i) => new DoubleMatrix(data[i], 1, ncol);

  /**
   * Row bind this matrix with [that] matrix.
   */
  DoubleMatrix rbind(DoubleMatrix that) {
    if (ncol != that.ncol) throw 'Dimensions mismatch';

    DoubleMatrix res = new Matrix.filled(0.0, nrow + that.nrow, ncol);
    res.data = new List.from(data)..addAll(that.data);
    return res;
  }

  /**
   * Column bind this matrix with [that] matrix.
   */
  DoubleMatrix cbind(DoubleMatrix that) {
    if (nrow != that.nrow) throw 'Dimensions mismatch';

    DoubleMatrix res = new Matrix.filled(0.0, nrow, ncol + that.ncol);
    for (int i = 0; i < nrow; i++) {
      var row = new List.from(data[i])..addAll(that.data[i]);
      res.data[i] = new Float64List.fromList(row);
    }
    return res;
  }

  toString() {
    List<String> out = [' ']..addAll(new List.generate(nrow, (i) => '[$i,]'));
    var width = out.last.length;
    out = out.map((String e) => e.padLeft(width)).toList();

    for (int j = 0; j < ncol; j++) {
      List col = column(j).toList();
      List<String> aux = ['[,$j]']..addAll(col.map((double e) => e.toStringAsFixed(DECIMAL_DIGITS)));

      var width = aux.fold(0, (prev, String e) => max(prev, e.length));
      aux = aux.map((String e) => e.padLeft(width)).toList(growable: false);
      for (int i = 0; i <= nrow; i++) out[i] = '${out[i]} ${aux[i]}';
    }
    return out.join("\n");
  }

}




class IntMatrix extends Matrix {
  List<Int32List> data;

  /**
   * A matrix will all int elements backed by a List<Int23List>.
   * Not sure how useful this is in the long run ...
   */
  IntMatrix(List x, int nrow, int ncol, {bool byRow: false}) : super._empty(nrow, ncol) {
    data = new List.generate(nrow, (i) => new Int32List(ncol));
    _populateMatrix(x, data, byRow: byRow);
  }

  IntMatrix.filled(int value, int nrow, int ncol) : super._empty(nrow, ncol) {
    data = new List.generate(nrow, (i) => new Int32List(ncol));
    _populateMatrix(new List.filled(nrow*ncol, value), data);
  }

  DoubleMatrix toDoubleMatrix() {
    DoubleMatrix d = new DoubleMatrix.zero(nrow, ncol);
    for (int i=0; i<nrow; i++)
      for (int j=0; j<ncol; j++)
        d.data[i][j] = data[i][j].toDouble();

    return d;
  }

  IntMatrix column(int j) {
    List<int> x = new List.generate(nrow, (i) => data[i][j]);
    return new IntMatrix(x, nrow, 1);
  }

  IntMatrix row(int i) => new IntMatrix(data[i], 1, ncol);

  /**
   * Row bind this matrix with [that] matrix.
   */
  IntMatrix rbind(IntMatrix that) {
    if (ncol != that.ncol) throw 'Dimensions mismatch';

    IntMatrix res = new IntMatrix.filled(0, nrow + that.nrow, ncol);
    res.data = new List.from(data)..addAll(that.data);
    return res;
  }

  /**
   * Column bind this matrix with [that] matrix.
   */
  IntMatrix cbind(IntMatrix that) {
    if (nrow != that.nrow) throw 'Dimensions mismatch';

    IntMatrix res = new IntMatrix.filled(0, nrow, ncol + that.ncol);
    for (int i = 0; i < nrow; i++) {
      var row = new List.from(data[i])..addAll(that.data[i]);
      res.data[i] = new Int32List.fromList(row);
    }
    return res;
  }


  toString() {
    List<String> out = [' ']..addAll(new List.generate(nrow, (i) => '[$i,]'));
    var width = out.last.length;
    out = out.map((String e) => e.padLeft(width)).toList();

    for (int j = 0; j < ncol; j++) {
      List col = column(j).toList();
      List<String> aux = ['[,$j]']..addAll(col.map((e) => e.toString()));

      var width = aux.fold(0, (prev, String e) => max(prev, e.length));
      aux = aux.map((String e) => e.padLeft(width)).toList(growable: false);
      for (int i = 0; i <= nrow; i++) out[i] = '${out[i]} ${aux[i]}';
    }
    return out.join("\n");
  }
}



