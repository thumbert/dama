part of matrix.dart;

class BlockMatrix extends Matrix {

  static int BLOCK_SIZE = 52;
  List<Float64List> _blocks = [];
  int _nrowBlocks;
  int _ncolBlocks;

  /**
   * A Matrix represented as block arrays for cache friendliness.
   */
  BlockMatrix(List<num> x, int nrow, int ncol, {bool byRow: false}) : super._empty(nrow, ncol) {

    _nrowBlocks = (nrow + BLOCK_SIZE -1)~/BLOCK_SIZE;
    _ncolBlocks = (ncol + BLOCK_SIZE -1)~/BLOCK_SIZE;

    // TODO: something about byRow here
    List<Float64List> rawData =  new List.generate(nrow, (i) => new Float64List(ncol));
    for (int j=0; j<ncol; j++)
      for (int i=0; i<nrow; i++)
        rawData[i][j] = x[i + j*nrow].toDouble();

     _toBlocksLayoutByRow(rawData);
  }

  void _toBlocksLayoutByRow(List<Float64List> rawData) {
    _blocks = new List.filled(_nrowBlocks*_ncolBlocks, []);
    int blockIndex = 0;
    for (int iBlock=0; iBlock<_nrowBlocks; iBlock++) {
      int pStart = iBlock*BLOCK_SIZE;
      int pEnd = min(pStart+BLOCK_SIZE, nrow);
      int iHeight = pEnd - pStart;
      for (int jBlock=0; jBlock<_ncolBlocks; jBlock++) {
        int qStart = jBlock*BLOCK_SIZE;
        int qEnd = min(qStart+BLOCK_SIZE, ncol);
        int jWidth = qEnd - qStart;

        _blocks[blockIndex] = new Float64List(iHeight*jWidth);
        // populate the block
        int index = 0;
        for (int p=pStart; p<pEnd; p++) {
          _blocks[blockIndex].setRange(index, index+jWidth, rawData[p].skip(qStart));
          index += jWidth;
        }
        ++blockIndex;
      }
    }
  }

  double element(int i, int j) {
    int iBlock = i ~/ BLOCK_SIZE;
    int jBlock = j ~/ BLOCK_SIZE;
    int k = (i - iBlock*BLOCK_SIZE)*_blockWidth(jBlock) + (j - jBlock*BLOCK_SIZE);
    return _blocks[iBlock*_ncolBlocks + jBlock][k];
  }

  void setElement(int i, int j, double value) {
    int iBlock = i ~/ BLOCK_SIZE;
    int jBlock = j ~/ BLOCK_SIZE;
    int k = (i - iBlock*BLOCK_SIZE)*_blockWidth(jBlock) + (j - jBlock*BLOCK_SIZE);
    _blocks[iBlock*_ncolBlocks + jBlock][k] = value;
  }


  ColumnMatrix column(int j) {
    var out = new Float64List(nrow);
    int jBlock = j ~/ BLOCK_SIZE;
    int jColumn  = j - jBlock * BLOCK_SIZE;
    int jWidth = _blockWidth(jBlock);

    int outIdx = 0;
    for (int iBlock=0; iBlock < _nrowBlocks; ++iBlock) {
      int iHeight = _blockHeight(iBlock);
      var block = _blocks[iBlock * _ncolBlocks + jBlock];
      for (int i = 0; i<iHeight; i++) {
        out[outIdx++] = block[i*jWidth + jColumn];
      }
    }

    return new ColumnMatrix(out);
  }

  /**
   * Get the height of a block.
   */
  int _blockHeight(int blockRow) =>
    (blockRow == _nrowBlocks-1) ? nrow - blockRow*BLOCK_SIZE : BLOCK_SIZE;

  /**
   * Get the width of the block.
   */
  int _blockWidth(int blockColumn) =>
    (blockColumn == _ncolBlocks-1) ? ncol - blockColumn*BLOCK_SIZE : BLOCK_SIZE;




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


  DoubleMatrix toDoubleMatrix() {
    Float64List data = new Float64List(nrow*ncol);
    for (int j = 0; j < ncol; j++) {
      for (int i = 0; i < nrow; i++) {
        data[i+j*nrow] = element(i,j);
      }
    }
    return new DoubleMatrix(data, nrow, ncol);
  }

  BlockMatrix transpose() {
    BlockMatrix res;
    // TODO:  continue
    return res;
  }


  String toString() => toDoubleMatrix().toString();


}


