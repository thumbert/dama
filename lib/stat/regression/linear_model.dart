library stat.regression.linear;

import 'dart:math';
import 'package:dama/dama.dart';
import 'package:dama/linear/lu_decomposition.dart';

import 'package:dama/linear/qr_decomposition.dart';
import 'package:dama/stat/regression/linear_model_summary.dart';

class LinearModel {
  /// Solve the ordinary least-square regression problem
  /// X b = y + \epsilon
  ///
  LinearModel(this.X, this.y, {this.names, this.threshold = 1E-10}) {
    if (names != null && names!.length != X.ncol) {
      throw ArgumentError(
          'Number of coefficient names don\'t match design matrix X dimension');
    }
    _qr = QRDecomposition(X, threshold: threshold);
  }

  /// The design matrix of independent (explanatory) variables.
  DoubleMatrix X;

  /// The dependent (response) variable.
  ColumnMatrix y;

  /// Coefficient names
  List<String>? names;

  /// QR decomposition threshold value
  double threshold;

  late QRDecomposition _qr;
  List<double>? _coeff;

  /// Get the regression coefficients.
  List<double> get coefficients {
    return _coeff ?? _qr.getSolver().solveVector(y).toList().toList();
  }

  /// If [pX] is not specified, use the original design matrix [X];
  List<double> predict({DoubleMatrix? pX}) {
    if (pX == null) {
      return X.multiply(DoubleMatrix(coefficients, X.ncol, 1)).toList();
    }
    return pX.multiply(DoubleMatrix(coefficients, X.ncol, 1)).toList();
  }

  /// Implement the equivalent of R's
  /// data("cars")
  /// model <- lm(dist ~ speed, data = cars)
  /// new <- data.frame(speed = seq(3, 27, 1))
  /// ci <- predict(model, new, interval="confidence", level=0.99)
  // List<num> predictConfidenceIntervals(DoubleMatrix pX, {required num level}) {}

  /// Calculate residuals
  List<double> residuals() {
    var res = <double>[];
    var yHat = predict();
    for (var i = 0; i < X.nrow; i++) {
      res.add(y.data[i] - yHat[i]);
    }
    return res;
  }

  double regressionStandardError() => sqrt(errorVariance());

  List<double> regressionParametersStandardErrors() {
    var betaVariance = calculateBetaVariance().data;
    var sigma2 = errorVariance();
    var res = List.filled(X.ncol, 0.0);
    for (var i = 0; i < X.ncol; i++) {
      res[i] = sqrt(sigma2 * betaVariance[i][i]);
    }
    return res;
  }

  double rSquared() {
    return 1 - residualSumOfSquares() / totalSumOfSquares();
  }

  double residualSumOfSquares() => residuals().fold(0.0, (a, b) => a + b * b);

  double totalSumOfSquares() {
    var meanY = mean(y.data);
    return y.data.fold(0.0, (a, b) => (a + (b - meanY) * (b - meanY)));
  }

  /// Calculates the variance-covariance matrix of the regression parameters.
  /// </p>
  /// <p>Var(b) = (X<sup>T</sup>X)<sup>-1</sup>
  /// </p>
  DoubleMatrix calculateBetaVariance() {
    var p = X.ncol;
    var rAug = _qr.getR().getSubmatrix(0, p - 1, 0, p - 1);
    var rInv = LuDecomposition(rAug).getSolver().inverse() as DoubleMatrix;
    return rInv.multiply(rInv.transpose());
  }

  double errorVariance() {
    var dp = residuals().fold((0.0), (double a, double b) => a + b * b);
    return dp / (X.nrow - X.ncol);
  }

  /// Organize a summary object, similar to R
  LinearModelSummary summary() => LinearModelSummary(this);
}
