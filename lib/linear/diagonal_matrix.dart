part of matrix.dart;

class DiagonalMatrix extends Matrix {

  Float64List _diag;

  /**
   * A specialized implementation for diagonal matrices.
   * [diag] is a list of elements on the diagonal.
   *
   */
  DiagonalMatrix(List<num> diag) : super._empty(diag.length, diag.length) {
    this._diag = new Float64List.fromList(diag.map((e)=>e.toDouble()).toList());
  }

  num element(int i, int j) {
    if (i != j) return 0;
    else return _diag[i];
  }

  void setElement(int i, int j, num value) {
    _diag[i] = value;
  }

  Matrix column(int j) {
    List res = new List.filled(nrow, 0);
    res[j] = data[j];
    return new Matrix(res, nrow, 1);
  }

  Matrix row(int i) {
    List res = new List.filled(ncol, 0);
    res[i] = data[i];
    return new Matrix(res, 1, ncol);
  }

  List get diag => _diag;
  set diag(List<num> values) {
    if (values.length == nrow) throw 'Dimensions mismatch';
    _diag = values;
  }

//  Matrix inverse() {
//    List inv = new List.generate(nrow, (i) => 1.0/data[i]);
//    return new DiagonalMatrix(inv);
//  }

  @override
  Matrix multiply(Matrix that) {
    if (ncol != that.nrow) throw 'Dimensions mismatch';
    List res = [];
    for (int j = 0; j < that.ncol; j++) {
      for (int i = 0; i < nrow; i++) {
        res.add(_diag[i] * that.element(i, j));
      }
    }

    return new Matrix(res, nrow, that.ncol);
  }

  Matrix cbind(Matrix that) {
    return new Matrix([], 1, 1);
  } // TODO:  continue
  Matrix rbind(Matrix that) {
    return new Matrix([], 1, 1);
  }


}


