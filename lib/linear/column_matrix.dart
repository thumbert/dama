part of matrix.dart;

class ColumnMatrix extends Matrix {

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
  DoubleMatrix cbind(Matrix that) {
    if (nrow != that.nrow) throw 'Dimensions mismatch';

    DoubleMatrix res = new DoubleMatrix.filled(0.0, nrow, 1 + that.ncol);
    for (int i = 0; i < nrow; i++) {
      var row = new List.from(data[i])..addAll(that.data[i]);
      res.data[i] = new Float64List.fromList(row);
    }
    return res;
  }


  ColumnMatrix rbind(ColumnMatrix that) => new ColumnMatrix(data..addAll(that.data));

}
