library stat.regression.linear;

import 'package:dama/linear/matrix.dart';
import 'package:dama/linear/qr_decomposition.dart';

class LinearModel {

  /**
   * The design matrix of independent (explanatory) variables.
   */
  DoubleMatrix X;

  /**
   * The dependent (response) variable.
   */
  ColumnMatrix y;

  double threshold;

  QRDecomposition _qr;

  /**
   * Solve the ordinary least-square regression problem
   * X b = y + \epsilon
   */
  LinearModel(DoubleMatrix this.X, ColumnMatrix this.y, {double this.threshold: 1E-10}) {
    _qr = new QRDecomposition(X, threshold: threshold);
  }


  List get coefficients {
    return _qr.getSolver().solveVector(y).toList();
  }

}

