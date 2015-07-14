part of matrix.dart;

class BlockMatrix extends Matrix {

  static int BLOCK_SIZE = 52;
  List<Float64List> _blocks;
  int _nrowBlocks;
  int _ncolBlocks;

  /**
   * A Matrix represented as block arrays for cache friendliness.
   */
  BlockMatrix(List<num> x, int nrow, int ncol, {bool byRow: false}) : super._empty(nrow, ncol) {

    _nrowBlocks = (nrow + BLOCK_SIZE -1)~/BLOCK_SIZE;
    _ncolBlocks = (ncol + BLOCK_SIZE -1)~/BLOCK_SIZE;

    if (byRow)
      _blocks = _toBlocksLayoutByRow(x);
  }

  _toBlocksLayoutByRow(List<num> x) {

    int blockIndex = 0;
    for (int iBlock=0; iBlock<_nrowBlocks; iBlock++) {
      int pStart = iBlock;
    }
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


