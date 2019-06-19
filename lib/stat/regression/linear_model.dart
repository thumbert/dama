library stat.regression.linear;

import 'dart:math';
import 'package:dama/dama.dart';
import 'package:dama/linear/lu_decomposition.dart';
import 'package:dama/linear/matrix.dart';
import 'package:dama/linear/qr_decomposition.dart';

class LinearModel {
  /// The design matrix of independent (explanatory) variables.
  DoubleMatrix X;

  /// The dependent (response) variable.
  ColumnMatrix y;

  double threshold;

  QRDecomposition _qr;
  
  List<double> _yHat;

  /// Solve the ordinary least-square regression problem
  /// X b = y + \epsilon
  ///
  LinearModel(DoubleMatrix this.X, ColumnMatrix this.y,
      {double this.threshold: 1E-10}) {
    _qr = QRDecomposition(X, threshold: threshold);
  }

  /// Get the regression coefficients.
  List<double> get coefficients {
    return _qr.getSolver().solveVector(y).toList().toList();
  }

  ///
  List<double> predict({DoubleMatrix pX}) {
    if (pX == null)  {
      _yHat ??= X.multiply(DoubleMatrix(coefficients, X.ncol, 1)).toList();
      return _yHat;
    }
    return pX.multiply(DoubleMatrix(coefficients, X.ncol, 1)).toList();
  }

  /// Calculate residuals
  List<double> residuals() {
    var res = <double>[];
    var yHat = predict();
    for (int i = 0; i < X.nrow; i++) {
      res.add(y.data[i] - yHat[i]);
    }
    return res;
  }


  double regressionStandardError() => sqrt(errorVariance());


  List<double> regressionParametersStandardErrors() {
    var betaVariance = calculateBetaVariance().data;
    var sigma2 = errorVariance();
    var res = List<double>(X.ncol);
    for (int i = 0; i < X.ncol; i++) {
      res[i] = sqrt(sigma2 * betaVariance[i][i]);
    }
    return res;
  }

  double rSquared() {
    return 1 - residualSumOfSquares()/totalSumOfSquares();
  }

  double residualSumOfSquares() => residuals().fold(0.0, (a,b) => a + b*b);

  double totalSumOfSquares() {
    var meanY = mean(y.data);
    return y.data.fold(0.0, (a,b) => (a + (b - meanY)*(b - meanY)));
  }


  /// Calculates the variance-covariance matrix of the regression parameters.
  /// </p>
  /// <p>Var(b) = (X<sup>T</sup>X)<sup>-1</sup>
  /// </p>
  DoubleMatrix calculateBetaVariance() {
    int p = X.ncol;
    var Raug = _qr.getR().getSubmatrix(0, p - 1, 0, p - 1);
    var Rinv = LuDecomposition(Raug).getSolver().inverse() as DoubleMatrix;
    return Rinv.multiply(Rinv.transpose());
  }


  double errorVariance() {
    var dp = residuals().fold((0.0), (a,b) => a + b*b);
    return dp/(X.nrow - X.ncol);
  }

}
