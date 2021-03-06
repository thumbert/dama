part of matrix.dart;

class ColumnMatrix extends Matrix {
  late Float64List data;

  /// A DoubleMatrix of column 1
  ColumnMatrix(Iterable<num> x) : super._empty(x.length, 1) {
    if (x is Float64List) {
      data = x;
    } else {
      data = Float64List.fromList(x.map((e) => e.toDouble()).toList());
    }
  }

  ColumnMatrix.filled(int length, num value) : super._empty(length, 1) {
    data = Float64List.fromList(List.filled(length, value.toDouble()));
  }

  /// Column bind this matrix with [that] matrix.
  DoubleMatrix cbind(Matrix that) {
    if (nrow != that.nrow) throw 'Dimensions mismatch';

    var res = DoubleMatrix.filled(0.0, nrow, 1 + that.ncol);
    for (var i = 0; i < nrow; i++) {
      var row = [data[i], ...that.row(i).toList()];
      res.data[i] = Float64List.fromList(row);
    }
    return res;
  }

  @override
  DoubleMatrix transpose() => DoubleMatrix(data, 1, nrow);

  @override
  double element(int i, int j) => data[i];

  @override
  void setElement(int i, int j, num value) {
    data[i] = value.toDouble();
  }

  ColumnMatrix rbind(ColumnMatrix that) =>
      ColumnMatrix(data..addAll(that.data));

  DoubleMatrix toDoubleMatrix() => DoubleMatrix(data, data.length, 1);

  @override
  toString() => toDoubleMatrix().toString();
}
