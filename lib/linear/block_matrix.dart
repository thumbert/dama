part of matrix.dart;

class BlockMatrix extends Matrix {
  static int BLOCK_SIZE = 52;
  List<Float64List> _blocks = [];
  late int _nrowBlocks;
  late int _ncolBlocks;

  /// A Matrix represented as block arrays for cache friendliness.
  BlockMatrix(List<num> x, int nrow, int ncol, {bool byRow = false})
      : super._empty(nrow, ncol) {
    _nrowBlocks = (nrow + BLOCK_SIZE - 1) ~/ BLOCK_SIZE;
    _ncolBlocks = (ncol + BLOCK_SIZE - 1) ~/ BLOCK_SIZE;

    // TODO: something about byRow here
    var rawData = List<Float64List>.generate(nrow, (i) => Float64List(ncol));
    for (var j = 0; j < ncol; j++) {
      for (var i = 0; i < nrow; i++) {
        rawData[i][j] = x[i + j * nrow].toDouble();
      }
    }

    _toBlocksLayoutByRow(rawData);
  }

  void _toBlocksLayoutByRow(List<Float64List> rawData) {
    _blocks = List.filled(_nrowBlocks * _ncolBlocks, Float64List(0));
    var blockIndex = 0;
    for (var iBlock = 0; iBlock < _nrowBlocks; iBlock++) {
      var pStart = iBlock * BLOCK_SIZE;
      int pEnd = min(pStart + BLOCK_SIZE, nrow);
      var iHeight = pEnd - pStart;
      for (var jBlock = 0; jBlock < _ncolBlocks; jBlock++) {
        var qStart = jBlock * BLOCK_SIZE;
        int qEnd = min(qStart + BLOCK_SIZE, ncol);
        var jWidth = qEnd - qStart;

        _blocks[blockIndex] = Float64List(iHeight * jWidth);
        // populate the block
        var index = 0;
        for (var p = pStart; p < pEnd; p++) {
          _blocks[blockIndex]
              .setRange(index, index + jWidth, rawData[p].skip(qStart));
          index += jWidth;
        }
        ++blockIndex;
      }
    }
  }

  @override
  double element(int i, int j) {
    var iBlock = i ~/ BLOCK_SIZE;
    var jBlock = j ~/ BLOCK_SIZE;
    var k = (i - iBlock * BLOCK_SIZE) * _blockWidth(jBlock) +
        (j - jBlock * BLOCK_SIZE);
    return _blocks[iBlock * _ncolBlocks + jBlock][k];
  }

  @override
  void setElement(int i, int j, num value) {
    var iBlock = i ~/ BLOCK_SIZE;
    var jBlock = j ~/ BLOCK_SIZE;
    var k = (i - iBlock * BLOCK_SIZE) * _blockWidth(jBlock) +
        (j - jBlock * BLOCK_SIZE);
    _blocks[iBlock * _ncolBlocks + jBlock][k] = value.toDouble();
  }

  @override
  ColumnMatrix column(int j) {
    var out = Float64List(nrow);
    var jBlock = j ~/ BLOCK_SIZE;
    var jColumn = j - jBlock * BLOCK_SIZE;
    var jWidth = _blockWidth(jBlock);

    var outIdx = 0;
    for (var iBlock = 0; iBlock < _nrowBlocks; ++iBlock) {
      var iHeight = _blockHeight(iBlock);
      var block = _blocks[iBlock * _ncolBlocks + jBlock];
      for (var i = 0; i < iHeight; i++) {
        out[outIdx++] = block[i * jWidth + jColumn];
      }
    }

    return ColumnMatrix(out);
  }

  /// Get the height of a block.
  int _blockHeight(int blockRow) =>
      (blockRow == _nrowBlocks - 1) ? nrow - blockRow * BLOCK_SIZE : BLOCK_SIZE;

  /// Get the width of the block.
  int _blockWidth(int blockColumn) => (blockColumn == _ncolBlocks - 1)
      ? ncol - blockColumn * BLOCK_SIZE
      : BLOCK_SIZE;

  /// Column bind this matrix with [that] matrix.
  DoubleMatrix cbind(Matrix that) {
    if (nrow != that.nrow) throw 'Dimensions mismatch';

    var res = DoubleMatrix.filled(0.0, nrow, 1 + that.ncol);
//    for (int i = 0; i < nrow; i++) {
//      var row = new List.from(data[i])..addAll(that.data[i]);
//      res.data[i] = new Float64List.fromList(row);
//    }
    return res;
  }

  //ColumnMatrix rbind(ColumnMatrix that) => new ColumnMatrix(data..addAll(that.data));

  DoubleMatrix toDoubleMatrix() {
    var data = Float64List(nrow * ncol);
    for (var j = 0; j < ncol; j++) {
      for (var i = 0; i < nrow; i++) {
        data[i + j * nrow] = element(i, j);
      }
    }
    return DoubleMatrix(data, nrow, ncol);
  }

  @override
  String toString() => toDoubleMatrix().toString();

  @override
  Matrix transpose() {
    // TODO: implement transpose
    throw UnimplementedError();
  }
}
