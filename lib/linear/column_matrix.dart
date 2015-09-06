part of matrix.dart;

class ColumnMatrix extends Matrix {
  Float64List data;

  /**
   * A DoubleMatrix of column 1
   */
  ColumnMatrix(List x) : super._empty(x.length, 1) {
    if (x is Float64List)
      data = x;
    else
      data = new Float64List.fromList(x.map((num e) => e.toDouble()).toList());
  }

  /**
   * Column bind this matrix with [that] matrix.
   */
  DoubleMatrix cbind(DoubleMatrix that) {
    if (nrow != that.nrow) throw 'Dimensions mismatch';

    DoubleMatrix res = new DoubleMatrix.filled(0.0, nrow, 1 + that.ncol);
    for (int i = 0; i < nrow; i++) {
      var row = [data[i]]..addAll(that.data[i]);
      res.data[i] = new Float64List.fromList(row);
    }
    return res;
  }

  DoubleMatrix transpose() => new DoubleMatrix(data, 1, nrow);

  double element(int i, int j) => data[i];
  void setElement(int i, int j, double value) {
    data[i] = value;
  }

  ColumnMatrix rbind(ColumnMatrix that) => new ColumnMatrix(data..addAll(that.data));

}
