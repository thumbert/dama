part of matrix.dart;


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

  /**
   * Get the row with index [i] from the matrix.
   */
  DoubleMatrix row(int i) => new DoubleMatrix(data[i], 1, ncol);

  /**
   * Get the element [i,j] of the matrix.
   */
  double element(int i, int j) => data[i][j];

  /**
   * Set the matrix element [i,j] to [value].
   */
  void setElement(int i, int j, num value) {
    data[i][j] = value.toDouble();
  }



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

  /**
   * Transpose this matrix
   */
  DoubleMatrix transpose() {
    DoubleMatrix res = new DoubleMatrix.filled(0.0, ncol, nrow);

    for (int i = 0; i < ncol; i++)
      for (int j = 0; j < nrow; j++)
        res.data[i][j] = data[j][i];
    return res;
  }


  DoubleMatrix _multiplyNaive(DoubleMatrix that) {
    DoubleMatrix res = new Matrix.filled(0.0, nrow, that.ncol);

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



  String toString() {
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
