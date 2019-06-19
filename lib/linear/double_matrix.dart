part of matrix.dart;

class DoubleMatrix extends Matrix {
  List<Float64List> data;

  static int _fmt_decimal_digits = 3;

  /// A matrix will all double elements backed by a List<Float64List>.
  DoubleMatrix(List<num> x, int nrow, int ncol, {bool byRow: false})
      : super._empty(nrow, ncol) {
    data = List.generate(nrow, (i) => Float64List(ncol));
    _populateMatrix(x, data, byRow: byRow);
  }

  DoubleMatrix.filled(double value, int nrow, int ncol)
      : super._empty(nrow, ncol) {
    data = List.generate(nrow, (i) => Float64List(ncol));
    _populateMatrix(List.filled(nrow * ncol, value), data);
  }

  DoubleMatrix.zero(int nrow, int ncol) : super._empty(nrow, ncol) {
    data = List.generate(nrow, (i) => Float64List(ncol));
  }

  DoubleMatrix column(int j) {
    List<double> x = List.generate(nrow, (i) => data[i][j]);
    return DoubleMatrix(x, nrow, 1);
  }

  /// Get the row with index [i] from the matrix as a DoubleMatrix.
  DoubleMatrix row(int i) => DoubleMatrix(data[i], 1, ncol);

  /// Get the element [i,j] of the matrix.
  double element(int i, int j) => data[i][j];

  /// Set the matrix element [i,j] to [value].
  void setElement(int i, int j, num value) {
    data[i][j] = value.toDouble();
  }

  /// Row bind this matrix with [that] matrix.
  DoubleMatrix rbind(DoubleMatrix that) {
    if (ncol != that.ncol) throw 'Dimensions mismatch';
    var res = DoubleMatrix.filled(0.0, nrow + that.nrow, ncol);
    res.data = List.from(data)..addAll(that.data);
    return res;
  }

  /// Column bind this matrix with [that] matrix.
  DoubleMatrix cbind(DoubleMatrix that) {
    if (nrow != that.nrow) throw 'Dimensions mismatch';
    var res = DoubleMatrix.filled(0.0, nrow, ncol + that.ncol);
    for (int i = 0; i < nrow; i++) {
      var row = List<double>.from(data[i])..addAll(that.data[i]);
      res.data[i] = Float64List.fromList(row);
    }
    return res;
  }

  /// Multiply two matrices -- the naive way
  /// [http://en.wikipedia.org/wiki/Matrix_multiplication#Algorithms_for_efficient_matrix_multiplication]
  DoubleMatrix multiply(DoubleMatrix that) {
    if (ncol != that.nrow) throw 'Dimensions mismatch';
    return _multiplyNaive(that);
  }

  DoubleMatrix _multiplyNaive(DoubleMatrix that) {
    var res = DoubleMatrix.filled(0.0, nrow, that.ncol);

//    if (that is DiagonalMatrix) {
//      // TODO: fill me in here ...
//
//    } else {
    Matrix c = that.transpose();
    for (int j = 0; j < that.ncol; j++) {
      for (int i = 0; i < nrow; i++) {
        var s = 0.0;
        for (int k = 0; k < ncol; k++) s += element(i, k) * c.element(j, k);
        res.setElement(i, j, s);
      }
    }
//    }
    return res;
  }

  /// Transpose this matrix
  DoubleMatrix transpose() {
    var res = DoubleMatrix.filled(0.0, ncol, nrow);
    for (int i = 0; i < ncol; i++)
      for (int j = 0; j < nrow; j++) res.data[i][j] = data[j][i];
    return res;
  }

  /// Get a submatrix of this matrix.
  /// where endRow, endColumn are inclusive!
  DoubleMatrix getSubmatrix(
      int startRow, int endRow, int startColumn, int endColumn) {
    if (endRow > nrow) throw ArgumentError('Input endRow can\'t be > $nrow');
    if (endColumn > ncol)
      throw ArgumentError('Input endColumn can\'t be > $ncol');
    if (startRow < 0) throw ArgumentError('Input startRow can\'t be < 0');
    if (startColumn < 0) throw ArgumentError('Input startColumn can\'t be < 0');
    var _data = <double>[];
    for (int i = startRow; i <= endRow; i++) {
      _data.addAll(data[i].sublist(startColumn, endColumn + 1));
    }
    return DoubleMatrix(
        _data, endRow - startRow + 1, endColumn - startColumn + 1,
        byRow: true);
  }

  String toString() {
    List<String> out = [' ']..addAll(new List.generate(nrow, (i) => '[$i,]'));
    var width = out.last.length;
    out = out.map((String e) => e.padLeft(width)).toList();

    for (int j = 0; j < ncol; j++) {
      List<double> col = column(j).toList();
      List<String> aux = ['[,$j]']
        ..addAll(col.map((double e) => e.toStringAsFixed(_fmt_decimal_digits)));

      var width = aux.fold(0, (int prev, String e) => max(prev, e.length));
      aux = aux.map((String e) => e.padLeft(width)).toList(growable: false);
      for (int i = 0; i <= nrow; i++) out[i] = '${out[i]} ${aux[i]}';
    }
    return out.join("\n");
  }
}
